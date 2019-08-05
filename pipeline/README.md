# Variant Calling Pipeline

This is a step wise guideline to reproducing a variant calling pipeline using `snakemake` for paired end reads.

**Ensure conda is installed on your machine**

To reproduce the analysis with the packages used recreate the variant calling environment on your machine with all packages used
```
conda create -n variant-calling -f envs/variant-calling.yaml
```
    
Activate the environment
```
conda activate variant-calling
```

Perform a dry run using using snakemake
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
This folder contains three folders:
1. **reads** - contains your raw reads files.
     * `WES_chr1_50X_E0.005_merged_read1.fq.gz`
     * `WES_chr1_50X_E0.005_merged_read2.fq.gz`
2. **reference** - contains your reference.
     * `chr1_ref.fasta`
3. **knownsites** - contains vcf files for known variants.
     * `WES_chr1_50X_E0.005_merged_golden.NoChrInNames.vcf`

Other folders are generated during the analysis.
