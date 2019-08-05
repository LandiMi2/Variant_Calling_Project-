# Variant Calling Pipeline

This is a step wise guideline to reproducing a variant calling pipeline using `snakemake`.

**Ensure conda is installed in your machine**

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
