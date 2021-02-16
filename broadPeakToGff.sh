#!/bin/bash
# go through all broadPeak files in the folder and transform to gff - these are then used in rose
for sample in *.broadPeak 
 do  
   id="$( cut -d '.' -f 1 <<< "$sample" )"
   awk '{print $1 "\t" $4 "\t" "\t" $2 "\t" $3 "\t" "\t" $6 "\t" "\t" $4}' $sample > $id.gff
done

