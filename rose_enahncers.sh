#!/bin/bash
#run this script from the folder with ROSE scripts:

# pathway to the folder with BAM files
echo -e What is the name of the folder with BAM files?
read BAMfolder


# second BAM file is an input
echo -e What is the name of the control BAM file?
read control

# GFF file is generated from .broadPeak file from MACS:
# awk '{print $1 "\t" $4 "\t" "\t" $2 "\t" $3 "\t" "\t" $6 "\t" "\t" $4}' *.broadPeak > example.gff
# -> now run shell script from folder containing broadPeak files: BroadPeakToGff.sh

echo -e What is the name of the folder with gff files?
read peakFolder

echo -e Where should be the output files be placed?
read output


mkdir helpDir
# go through the folder containing bam files 
# get the bam file name without pathway

for bamFile in ${BAMfolder}/*.bam
do
	#show the BAM file with pathway to it
	echo "Following BAM file is being processed:"
    echo $bamFile
    
    # get the bam file name without pathway
    bamName=$(basename $bamFile)
    
    # replace .bam with _peaks.gff (this way we find matching pairs)
    peakName=${bamName/".bam"/"_peaks.gff"}
    
    # append the pathway to the peak file name
    peakFile="$peakFolder/$peakName"
    echo "With following GFF file:"
    echo $peakFile
    
    # run rose
    python ROSE_main.py -g HG19 -i $peakFile -r $bamFile -c $control -o $output -s 12500 -t 2500
done


