#!/bin/bash
# Script goes through all bed files in a given folder and returns the number of lines in the BED file


for i in *.bed
do 
	id="$( cut -d '.' -f 1 <<< "$i" )"
	echo $i

	wc -l < $i
done






