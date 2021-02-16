# H3K27ac_in_stunting
All scripts relevant to the paper describing H3K27ac changes in stunted children.

## Data preprocessing
### 1) Map FASTQ files to hg19
###### Prerequisities:
+ [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
+ [refgenie](http://refgenie.databio.org/en/latest/)
+ [samtools](http://www.htslib.org/)
+ [bedtools](https://bedtools.readthedocs.io/en/latest/index.html)

First check if you have bowtie2 index and file with chromosome sizes.\
`$ refgenie seek hg19/bowtie2_index`\
\
If an index is not found runn following: \
`$ refgenie pull hg19/bowtie2_index` \
\
Do the same for chromosome sizes: \
`$ refgenie seek hg19/fasta.chrom_sizes`\
\
If not found:\
`$ refgenie pull hg19/fasta.chrom_sizes`


`mapFASTQfiles_hg19.sh `
