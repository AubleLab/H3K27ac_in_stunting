# H3K27ac_in_stunting
All scripts relevant to the paper describing H3K27ac changes in stunted children.

## Data preprocessing
### 1) Map FASTQ files to hg19
###### Prerequisities:
+ [bowtie2] (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
+ [refgenie] (http://refgenie.databio.org/en/latest/)
+ samtools
+ bedtools
`nohup batchtofastqc.sh > batchoutput.txt `
