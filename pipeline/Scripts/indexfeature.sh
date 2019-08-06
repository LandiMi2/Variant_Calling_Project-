#! /bin/bash

# Input directory
dir=$1

# Loop through the vcf files and index them
for file in ${dir}*.vcf
do
	echo "Indexing ${file} file"
	gatk IndexFeatureFile -F ${file}
done
