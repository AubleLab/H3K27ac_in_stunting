# H3K27ac in stunting
All scripts relevant to the paper describing H3K27ac changes in stunted children.

## Data preprocessing
### 1) Map FASTQ files to hg19
###### Prerequisites:
+ [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
+ [refgenie](http://refgenie.databio.org/en/latest/)
+ [samtools](http://www.htslib.org/)
+ [bedtools](https://bedtools.readthedocs.io/en/latest/index.html)

First check if you have bowtie2 index.\
`$ refgenie seek hg19/bowtie2_index`

If NOT found run following: \
`$ refgenie pull hg19/bowtie2_index` 

**From directory with compressed (.gz) FASTQ files run following script**\
`$ mapFASTQfiles_hg19.sh `

-Following sentence pops up:\
*`Give a full name (including pathway) of a file containing hg19 blacklisted sites.`*\
-Provide following (these are blacklisted sites defined by ENCODE - included here in */associated_files* folder):\
*`localPathTo_H3K27ac_in_stunting_folder/associated_files/hg19_blacklist.bed`*

### 2) Call peaks with MACS2
###### Prerequisites:
+ [MACS2](https://anaconda.org/bioconda/macs2)

From directory with all of the hg19 BAM files run following:\
`$ callPeaks.sh`

In our settings we used input as a control for peak calling, when asked provide name of the input BAM file (including path name). !!! Input BAM file should be placed at different location from the other BAM files, otherwise peak-calling will be done also on this file).\
*`What is the name of the control dataset (including path)?`*\
e.g. *`localPathToInputBAM/input.bam`*\
\
Outputs from peak-calling are placed into individual folders named after individual BAM files.

### 3) Use ROSE to identify putative enhancers and superenhancers
###### Prerequisites:
+ [ROSE](http://younglab.wi.mit.edu/super_enhancer_code.html)

Place all *broadPeak* files called with MACS2 in previous step into one folder. From this folder run:\
`$ broadPeakToGff.sh`

Run following script from a folder, where you have ROSE scripts saved and make sure to set up python 2.7 as default.\
`$ rose_enahncers.sh`

4 questions will pop up:\
*`What is the name of the folder with BAM files?`*\
provide:  *`local/path/to/BAM/files`*

*`What is the name of the control BAM file?`*\
e.g. *`local/path/to/input/BAM/input.bam`*


*`What is the name of the folder with gff files?`*\
provide:  *`local/path/to/GFF/files`*


*`Where should be the output files be placed?`*\
provide:  *`local/path/to/desired/output/dir`*

BAM files and GFF files are matched base on the file names. Outputs from the script are stored into the directory provided in the answer to the last question.

### 4) Create count tables
Move the output files from previous step ending with "_Enhancer.bed" into a separate folder and from here run following (separate for each age group): \
`cat *.bed | sort -k1,1 -k2,2n | bedtools merge -i stdin > masterEnhancers.bed`

Place the masterEnhancer.bed file into a folder containing all BAM files for a given age group and from this folder run: \
`bedtools multicov -bams *.bam -bed masterEnhancers.bed > countTable.txt`

First three columns in the table are genomic coordinates of regions of interest followed by counts for individual samples. Make sure to add sample names to the sample columns based on their order within the folder (`ls *.bam`).

### 5) Map FASTQ files to dm6
First check if you have bowtie2 index.\
`$ refgenie seek dm6/bowtie2_index`

If NOT found run following: \
`$ refgenie pull dm6/bowtie2_index` 

**From directory with compressed (.gz) FASTQ files run following script**\
`$ mapFASTQfiles_dm6.sh `

-Following sentence pops up:\
*`Give a full name (including pathway) of a file containing dm6 blacklisted sites.`*\
-Provide following (these are blacklisted sites defined by ENCODE - included here in */associated_files* folder):\
*`localPathTo_H3K27ac_in_stunting_folder/associated_files/dm6_blacklist.bed`*

### 6) Correct normalization factors

New corrected normalization factors are calculated with following R script using *Drosophila* mapping statistics from  */dm_factor_data/normalize_dm_counts_linModel.csv*

`new_norm_factors_linModel.R`

### 7) Connect genomic regions to genes with EnhancerAtlas 2

Go to [EnhancerAtlas](http://www.enhanceratlas.org/download.php) -> download gene-enhancer interactions (v2.0). here select cell types of interest. (Cell types selected in this manuscript: CD4+, CD8+, CD14+, CD19+, CD20+, GM10847, GM12878, GM12891, GM12892, GM18505, GM18526, GM18951, GM19099, GM19193, GM19238, GM19239, GM19240, PBMC). 

Curate the downloaded files, so they are in a tab delimited format with columns: chr, start, end, Ensemble ID, gene ID, cell type - for this use make directory **/editedFiles** and run following R script:

`editEnahncerAtlasFiles.R`

Then merge all parts into a final database. From terminal:

`$ cd pathToEditedFilesFolder/editedFiles/`\
`$ cat *.bed | sort -k1,1 -k2,2n > sortedDatabaseEnhancerAtlas.bed`

Once the database is created use following R script to annotated BED files. (Need to provide path to the folder with BED files, that should be annotated - line 11, and change path to the *sortedDatabaseEnhancerAtlas.bed`* file on line 16)

`annotate_with_EnhancerAtlas2_downloadedDatabase.R`

### 8) Alluvial plot to assess changes between ages
This analysis can be performed using R script: `alluvialPlot.R` with inputs in form of DESeq2 result tables for 18-week-old children and 1-year-old children. Follow instructions in the R script to generate the plots.

### 9) Create database for LOLA from CISTROME database
The CISTROME database for human transcription factors and histone marks can be downloaded from [CISTROME website](http://cistrome.org/db/#/bdown).\
From within a folder containing info about downloaded files: \
*human_factor_full_QC.txt*, \
*human_hm_full_QC.txt*,\
and actual folders with downloaded BED files: \
*human_factor/*, \
*human_hm/* 

Run following R script:\
`filterBloodSpecificFiles.R`\
\
The script creates new directories, where only BED files coming from blood cells are placed (*human_factor_blood/*, *human_hm_blood/*) and new info sheets are created (*human_factor_blood_QC.txt*, *human_hm_blood_QC.txt*).

LOLA takes database input in form of GRangesList object. To convert BED files into GRangesList objects, run following script from within directory containing the *human_factor_blood/*, and *human_hm_blood/* directories.\
`makeGRangesList_forLOLA.R`\
\
The script creates 2 GRangesList objects from the BED files: *human_factor_blood.Rdata*, and *human_hm_blood.Rdata*. It also produces a list of empty BED files (*human_factor_blood_unloaded.txt*, *human_hm_blood_unloaded.txt*) that were not added to the GRangesList objects, and will be therefore excluded from an annotation table created in the following step. 

LOLA annotation file requires number of lines within each bed file. From terminal run following: \
`$ cd localPathTo/human_factor_blood`
`$ num_of_lines_in_bed_files.sh > human_factor_blood_bedSize.txt`
`$ mv human_factor_blood_bedSize.txt ..`

`$ cd localPathTo/human_hm_blood`
`$ num_of_lines_in_bed_files.sh > human_hm_blood_bedSize.txt`
`$ mv human_hm_blood_bedSize.txt ..`

The region and collection annotations for LOLA can are then created by running following R script from within directory containing the *human_factor_blood/*, and *human_hm_blood/* directories.
`makeAnnotFiles_LOLA.R` \
The resulting files are then *human_factor_blood_regionAnno.csv*, *human_factor_blood_collectionAnno.csv*, *human_hm_blood_regionAnno.csv*, and *human_hm_blood_collectionAnno.csv*. 

You can now move the following list of files to a separate directory, where you want to have LOLA database stored, and you can remove the rest of the files.
Files for LOLA database: \
*human_factor_blood_collectionAnno.csv,\
human_factor_blood_regionAnno.csv,\
human_factor_blood.Rdata,\
human_hm_blood_collectionAnno.csv,\
human_hm_blood_regionAnno.csv,\
human_hm_blood.Rdata*

You can then run LOLA with help of following R script, where information about location of created database, location of BED file of interest and location of universe BED file must be provided between lnes 9-25. For more information on use od LOLA, you can click on the next [link](http://databio.org/lola/).

`LOLA_cistrome.R`

