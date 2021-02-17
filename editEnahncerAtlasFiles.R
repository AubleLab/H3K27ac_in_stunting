rm(list = ls())

library(tidyverse)

enhancerFiles = list.files(pattern = "*EP.txt")


for (i in enhancerFiles){
  enhancer = read.delim(i, header = F)
  
  cellType = unlist(strsplit(i, split = "_"))[1]
  
  enhancerEdit = enhancer %>% 
    select(V1) %>% 
    separate(V1, c("chr", "anot"), sep = ":") %>% 
    separate(anot, c("position", "anot"), sep = "_", extra = "merge") %>% 
    separate(position, c("start", "end"), sep = "-", estra = "merge") %>% 
    separate(anot, c("ensembleID", "geneName"), sep = "\\$", extra = "drop") %>% 
    mutate(cellType = cellType)
  
  write.table(enhancerEdit, paste0("editedFiles/", cellType, ".bed"), sep = "\t", quote = F, row.names = F, col.names = F)
}



