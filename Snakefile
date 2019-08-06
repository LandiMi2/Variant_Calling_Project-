#Snakemake workflow for variant callling process.
SAMPLES, = glob_wildcards("Data/{samples}_read1.fq.gz")
#REF, = glob_wildcards("Data/{ref}.fasta")
#KNOWNSITES, = glob_wildcards("Known_sites/{known}.vcf")


        
rule all:
        input: expand( "Data/{samples}_variant.vcf", samples = SAMPLES)
                 
        
rule fastaqc: 
    input:
         "Data/{samples}_read1.fq.gz", 
         "Data/{samples}_read2.fq.gz"
    output: 
        "Data/{samples}_read1_fastqc.zip",
        "Data/{samples}_read2_fastqc.zip",
        "Data/{samples}_read1_fastqc.html",
        "Data/{samples}_read2_fastqc.html"
    log:
        "Results/logs/{samples}.fastqc"
    conda:
        "envs/fastqc.yaml"
    shell:
        "fastqc {input} 2> {log}"


rule trimming: 
        input: 
            read_1 = "Data/{samples}_read1.fq.gz", 
            read_2 = "Data/{samples}_read2.fq.gz",
            html = "Data/{samples}_read1_fastqc.html",
	    fastqc = "Data/{samples}_read1_fastqc.zip"
  
        output:
            read1_paired = "Data/{samples}_read1_output_paired.fq.gz",
            read2_paired = "Data/{samples}_read2_output_paired.fq.gz",
            read1_unpaired = "Data/{samples}_read1_output_unpaired.fq.gz",
            read2_unpaired = "Data/{samples}_read2_output_unpaired.fq.gz"
        params:
            trim_options = " -phred33 ILLUMINACLIP:Truseq3.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"
        log:
            "Results/logs/{samples}.trim"   
        conda:
            "envs/trim.yaml"
        shell:
            "trimmomatic PE  {input.read_1} {input.read_2} {output.read1_paired} {output.read1_unpaired} {output.read2_paired} {output.read2_unpaired}" 
            "{params.trim_options} 2> {log}"

rule reference_index:
        input:
            fasta = "Data/chr1_ref.fasta" 
        output:
            touch("Data/makeindex.done")
        log:
            "Results/logs/makeidex.index"
        conda:
            "envs/index.yaml"
        shell:
            "bwa index {input.fasta} 2> {log} "


rule mapping:
        input:
            read1 = "Data/{samples}_read1_output_paired.fq.gz",
            read2 = "Data/{samples}_read2_output_paired.fq.gz",
            index_done = "Data/makeindex.done"
        output:
            "Data/{samples}.sam"
        
        threads: 3
        
        params:
            index = "Data/chr1_ref.fasta" 
        log:
            "Results/logs/{samples}.map"
        conda:
            "envs/map.yaml"
        shell:
            "bwa mem -t {threads} {params.index} {input.read1} {input.read2} > {output} 2> {log}"


rule sort_bam:
        input:
            "Data/{samples}.sam"
        output:
            "Data/{samples}.bam"
        shell:
            "samtools view -h -Sb {input} | samtools sort - > {output}"

rule bam_index:
        input:
            bam = "Data/{samples}.bam"
        
        output:
            touch("Data/{samples}bamindex.done")
        
        shell:
            "samtools index {input}"

rule removal_deduplication:
        input:
            bam =  "Data/{samples}.bam",
            bam_done = "Data/{samples}bamindex.done"
        output:
            "Data/{samples}_cleaned.bam"
        params:
            sam_index = "Data/{samples}.bam"
        log:
            "Results/logs/{samples}.deduplication"
        conda:
            "envs/deduplication.yaml"

        shell:
            "sambamba markdup -r {params.sam_index} {output} 2> {log}"

########
rule bam_clean_index:
        input:
            "Data/{samples}_cleaned.bam"
        
        output:
            "Data/{samples}_cleaned_bam.bai"
        log:
            "Results/logs/{samples}.clean"
        conda:
            "envs/clean.yaml"
        
        shell:
            "samtools index {input} 2> {log}"


rule ref_samtools_index:
        input:
            "Data/chr1_ref.fasta" 

        output:
            touch("Data/samtool_index.done")

        shell:
          "samtools faidx {input}"


rule Create_Ref_Dictonary: 
        input:
            "Data/chr1_ref.fasta",
            "Data/samtool_index.done"       
        output:
            "Data/chr1_ref.dict"
        log:
            "Results/logs/reference.dict"
        conda:
            "envs/refdict.yaml"
        shell:
            "gatk CreateSequenceDictionary -R {input[0]} -O {output} " "2> {log}"

rule Index_Feature_File:
        input:
            "Known_sites/Homo_sapiens_assembly38.dbsnp138.vcf",
        output:
            "Known_sites/Homo_sapiens_assembly38.dbsnp138.vcf.idx"
        log:
            "Results/logs/feature.index"
        
        shell:
            "gatk IndexFeatureFile -F {input[0]} 2> {log}"

rule AddOrReplaceReadGroups: 
        input:
            "Data/{samples}_cleaned.bam",
             "Data/{samples}_cleaned_bam.bai"
           
        output:
            "Data/{samples}_readgroups.bam"
        log:
            "Results/logs/{samples}.groups"
        shell:
            "gatk AddOrReplaceReadGroups -I {input[0]} -O {output} -ID 4 -LB lib1 -PL illumina -PU unit1 -SM 20 2> {log}"


rule BaseRecalibrator:
        input:
            "Data/chr1_ref.fasta",
            "Data/{samples}_readgroups.bam",
            "Known_sites/Homo_sapiens_assembly38.dbsnp138.vcf",
            "Data/chr1_ref.dict",
            "Known_sites/Homo_sapiens_assembly38.dbsnp138.vcf.idx"
           
            
        output:
            "Data/{samples}_recalibrator_report.grp"
        log:
            "Results/logs/{samples}.recalibrator"
        shell:
            "gatk BaseRecalibrator -R {input[0]} -I {input[1]} -O {output} --known-sites {input[2]} >2 {log}"
    
rule ApplyBQSR :
        input:
            "Data/{samples}_recalibrator_report.grp",
            "Data/{samples}_readgroups.bam"
        output:
            "Data/{samples}_recalibrated.bam"
        log:
            "Results/logs/{samples}.bsqr"
        shell:
            "gatk ApplyBQSR -bqsr {input[0]} -I {input[1]} -O {output} >2 {log}"

rule HaplotypeCaller:
        input:
            "Data/{samples}_recalibrated.bam",
            "Data/chr1_ref.fasta"

        output:
            "Data/{samples}_variant.vcf" 
        log:
            "Results/logs/{samples}.variant"

        shell:
            "gatk HaplotypeCaller -I {input[0]} -O {output} -R {input[1]} 2>{log}"



            
        




            














                






