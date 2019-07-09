# Variant Calling Workflow Pipeline

## Background

Variant calling has become widely accepted in human genetics as a way of identifying variants associated with a specific trait, population or hereditary diseases. It employs next-generation sequencing data to identify two main types of variants, namely single nucleotide variants/polymorphism(SNPs) and INDELs (Small insertion or deletions) within a genome of interest. 

Whole exome sequencing data for human genome chromosome 1 was provided for accreditation of the icipe node. The data is based on hg19 GATK 2.8 bundle. The data was reported to have a mutation rate of 0.0003, a coverage of 50, and an error rate of 0.005. The training of the variant calling pipeline was done using two synthetic exome datasets for human chromosome 1 provided. Both the datasets contained variants determined from African genome ERR250949 combined with synthetic variants.

The reads for one training dataset were simulated using Wessim (REF) while those for the second dataset were simulated using a UIUC in-house simulator (unpublished). The latter dataset was expected to contain fewer false negative variants. Together with the datasets, vcf files containing the expected output for both the training datasets were also provided.

## Pipeline
The H3ABioNet have developed some [standard operating procedures (SOPs)](https://h3abionet.github.io/H3ABionet-SOPs/Variant-Calling) for the H3Africa Consortium. *icipe* node recently participated in the accreditation exercise, where they established a pipeline using the Jupyter Notebooks and Conda for package management. Although well documented and reproducible, it is not easily portable to other systems. This mini-project entails converting the pipeline to either Nextflow or snakemake. The current pipeline tested various tools for the same task; for example, we used both GATK and Freebayes for variant calling. The pipeline you create should be flexible enough to accommodate the various tools utilised in the provided pipeline. 

Find below the pipeline we used for our node accreditation:

![Variant_Calling](Figures/Variant_Pipeline.png)
Figure 1: **Flowchart of the Human Variant Calling Pipeline**. The format of the output files is added in (brackets). The tools used in each step are italicized and provided on the right. Double-headed arrows indicate steps which were ran more than once.

## Project Task
1. Reproduce the pipeline by setting up the workspace in the system you will be using
2. Perform downstream analysis after variant calling
3. Convert the pipeline into Nextflow or Snakemake

Through the project, you need to demonstrate collaborative research skills, informative visualization, and report writing. 
