#! /bin/bash

bam=$1
ref=$2
out=$3

# Creating the gatk code
code="gatk BaseRecalibrator  --input ${bam}"

for site in ../Data/knownsites/*.vcf
do
	code="${code} --known-sites ${site}"
done

code="${code} --output ${out} --reference ${ref}"

echo "This code is running.."
echo ${code}

# Making a running pseudo script
echo "#! /bin/bash" > run.sh
echo "bam=\$1" >> run.sh
echo "ref=\$2" >> run.sh
echo "out=\$3" >> run.sh
echo ${code} >> run.sh

# Make the script executable
chmod +x run.sh

# Execute the gatk command
bash run.sh ${bam} ${ref} ${out}

# Delete the pseudo script
rm run.sh
