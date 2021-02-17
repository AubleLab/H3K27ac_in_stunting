# H3K27ac_in_stunting
All scripts relevant to the paper describing H3K27ac changes in stunted children.

## Data preprocessing
### 1) Map FASTQ files to hg19
###### Prerequisities:
+ [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
+ [refgenie](http://refgenie.databio.org/en/latest/)
+ [samtools](http://www.htslib.org/)
+ [bedtools](https://bedtools.readthedocs.io/en/latest/index.html)

First check if you have bowtie2 index.\
`$ refgenie seek hg19/bowtie2_index`\
If NOT found run following: \
`$ refgenie pull hg19/bowtie2_index` 

**From directory with compressed FASTQ files run following script**\
`$ mapFASTQfiles_hg19.sh `\
-Following sentence pops up:\
*`Give a full name (including pathway) of a file containing hg19 blacklisted sites.`*\
-Provide following (these are blacklisted sites defined by ENCODE):\
*`localPathTo_H3K27ac_in_stunting_folder/associated_files/hg19_blacklist.bed`*

### 2) Call peaks with MACS2
###### Prerequisities:
+ [MACS2](https://anaconda.org/bioconda/macs2)

From directory with all of the hg19 BAM files run following:\
`$ callPeaks.sh`\
In our settings we used input as a control for peak calling, when asked provide name of the input BAM file (including path name). !!! Input BAM file should be placed at different location from the other BAM files, otherewise peak-calling will be done also on this file).\
*`What is the name of the control dataset (including path)?`*\
e.g. *`localPathToInputBAM/input.bam`*\
\
Outputs from peak-calling are placed into individual folders named after individual BAM files.

### 3) Use ROSE to identify putative enhancers and superenhancers
###### Prerequisities:
+ [ROSE](http://younglab.wi.mit.edu/super_enhancer_code.html)

Place all *broadPeak* files called with MACS2 in previous step into one folder. From this folder run:\
`$ broadPeakToGff.sh`

Run following script from a folder, where you have ROSE scripts saved and make sure to set up python 2.7 as default.\
`$ rose_enahncers.sh`

4 questions will pop up:\
*`What is the name of the folder with BAM files?`*\
provide:  *`localPathToBAMfiles/`*

*`What is the name of the control BAM file?`*\
e.g. *`localPathToInputBAM/input.bam`*


*`What is the name of the folder with gff files?`*\
provide:  *`localPathToGFFfiles/`*


*`Where should be the output files be placed?`*\
provide:  *`localPathToDesiredOutputDir/`*

BAM files and GFF files are matched base on the file names. Outputs from the script are stored into the directory provided in the answer to the last question.

### 4) Create count tables


### 5) Map FASTQ files to dm6
First check if you have bowtie2 index.\
`$ refgenie seek dm6/bowtie2_index`\
If NOT found run following: \
`$ refgenie pull dm6/bowtie2_index` 

**From directory with compressed FASTQ files run following script**\
`$ mapFASTQfiles_dm6.sh `\
-Following sentence pops up:\
*`Give a full name (including pathway) of a file containing dm6 blacklisted sites.`*\
-Provide following (these are blacklisted sites defined by ENCODE):\
*`localPathTo_H3K27ac_in_stunting_folder/associated_files/dm6_blacklist.bed`*
