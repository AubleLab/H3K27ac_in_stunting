library(tidyverse)

# create new directories only for blood BED files
dir.create("human_factor_blood")
dir.create("human_hm_blood")

# load info about TFs 
infoTF = read.delim("human_factor_full_QC.txt")

# select only blood BED files
bloodTF = infoTF %>% 
  filter(Tissue_type == "Blood" | Tissue_type == "Peripheral Blood")

# mode them to a designated directory
bedFiles = paste0("human_factor/",bloodTF$DCid, "_sort_peaks.narrowPeak.bed")

file.copy(bedFiles, "human_factor_blood/")

# create a new infor spread sheet
write.table(bloodTF, "human_factor_blood_QC.txt", quote = F, sep = "\t", row.names = F)

# -----do the same for histone marks

# load info about histone marks
infoHM = read.delim("human_hm_full_QC.txt")

# select only blood BED files
bloodHM = infoHM %>% 
  filter(Tissue_type == "Blood" | Tissue_type == "Peripheral Blood")

# mode them to a designated directory
bedFilesHM = paste0("human_hm/",bloodHM$DCid, "_sort_peaks.narrowPeak.bed")

file.copy(bedFilesHM, "human_hm_blood/")

for (i in bedFilesHM){
  if(!file.copy(i, "human_hm_blood/")){
    
    fileToCopy = paste0(unlist(strsplit(i, split = "_sort"))[1], "_b_sort_peaks.broadPeak.bed")
    
    file.copy(fileToCopy, paste0("human_hm_blood/"))
  } 
}


# create a new info spread sheet
write.table(bloodHM, "human_hm_blood_QC.txt", quote = F, sep = "\t", row.names = F)






