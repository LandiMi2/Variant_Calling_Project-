# Variant Calling Pipeline

This is a step wise guideline to reproducing a variant calling pipeline using `snakemake` for paired end reads.

**Ensure conda is installed on your machine**

To reproduce the analysis with the packages used recreate the variant calling environment on your machine with all packages used
```
conda env create -n variant-calling -f envs/variant-calling.yaml
```
    
Activate the environment
```
conda activate variant-calling
```
Create the data folder and download the data

````
mkdir -p Data && cd Data
wget -r -nH --cut-dirs=2 --no-parent --reject="index.html*" http://hpc01.icipe.org/ibt2020/Data/
`````


Perform a dry run to confirm workflow is set to run from start to end without any errors 
```
snakemake -np
```
     
Run your analysis and specify number of core to use using `-j` (optional)
```
snakemake -j 4
```

# Folder organization
Before starting analysis organize your folders as follows:

## Data
This folder contains three sub-folders:
1. **reads** - contains your raw reads files.
     * `WES_chr1_50X_E0.005_merged_read1.fq.gz`
     * `WES_chr1_50X_E0.005_merged_read2.fq.gz`
2. **reference** - contains your reference.
     * `chr1_ref.fasta`
3. **knownsites** - contains vcf files for known variants.
     * `WES_chr1_50X_E0.005_merged_golden.NoChrInNames.vcf`
     * `1.1KGIndels.chr1.vcf`
     * `1.MillsIndels.chr1.vcf`
4. **b37** - the b37 gatk bundle.
     * `1000G_omni2.5.b37.vcf`
     * `dbsnp_138.b37.vcf`
     * `hapmap_3.3.b37.vcf`
     * `Mills_and_1000G_gold_standard.indels.b37.vcf`

Other folders are generated during the analysis.

**NB:** The data used in this pipeline development was borrowed from [H3ABioNet](https://h3abionet.github.io/H3ABionet-SOPs/Variant-Calling-5-0.html) and b37 bundle was accessed from [gatk](https://github.com/snewhouse/ngs_nextflow/wiki/GATK-Bundle).
