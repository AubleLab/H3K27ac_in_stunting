# script goes through bed files in a folder and finds overlap with downloaded
# and curated EnhancerAtlas2 database = annotation

rm(list = ls())

library(tidyverse)
library(GenomicRanges)

# go through all master ned files
#!!!!!! add path to folder with BED files that should be annotated!!!!
bedPath = "path/to/folder/with/bed/files/to/be/annotated"
bedFiles = list.files(path = bedPath,pattern = ".bed", full.names = T)

# get database that I created from downloaded EnhancerAtlas2 files, convert it to GRanges object
# !!!!! change path to the local sorted EnhanceAtlas2 database
database = read.delim("localPathToDatabase/sortedDatabaseEnhancerAtlas.bed", 
                      header = F)
colnames(database) = c("chr", "start", "end")
databaseRanges = makeGRangesFromDataFrame(database)

# go through all the master bed files and overlap them with database
for (i in bedFiles){
  bedFileName = basename(i)
  
  # read in the bed file and convert to GRanges object
  bedTable = read.delim(i, header = F)
  colnames(bedTable) = c("chr", "start", "end")
  bedRanges = makeGRangesFromDataFrame(bedTable)
  
  # find overlaps between the bed file and database
  overlaps = findOverlaps(bedRanges, databaseRanges)
  
  # based on identified indexes extract the overlapping peaks and this gives the final annotation
  bedOverlaps = bedTable[overlaps@from,]
  databaseOverlaps = database[overlaps@to,]
  annotatedPeaks = cbind(bedOverlaps, databaseOverlaps)
  
  write.table(annotatedPeaks, paste0("annotated_",bedFileName), 
              sep = "\t", quote = F, row.names = F, col.names = F)
  
  uniqueGenes = unique(annotatedPeaks[,8])
  write.table(uniqueGenes, paste0("annotatied_listOfUniqeGenes_", tools::file_path_sans_ext(bedFileName),".txt"),
              sep = "\n", quote = F, row.names = F, col.names = F)
}
  
  
  
  
  
  
  
  
  
  
  





