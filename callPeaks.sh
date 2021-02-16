#!/bin/bash

#This script gets all the BAM files present in the folder and runs peak calling with
# MACS2. It requires the name of the input, which will be used as control in 
# peak calling (input file shouldn't ba in the same folder)

echo -e "What is the name of the control dataset (including path)?"
read controlBAM

# get all of the BAM files in the folder and use the characters before the first occurence
# of "." as the sample ID
for BAMfile in *.bam  
 do  
 	# get the BAM file name and clean file name without any extensions
	fileName="${BAMfile%%.*}"
	
	mkdir $fileName
	macs2 callpeak -t $BAMfile -c $controlBAM -n $fileName --broad -g hs --broad-cutoff 0.01 --outdir ./$fileName
done

