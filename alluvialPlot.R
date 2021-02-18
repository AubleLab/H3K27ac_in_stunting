rm(list = ls())
library(tidyverse)
#library(ggpubr)
library(ggalluvial)

# -------------upload results (supplemental tables)----------------------
# upload results for 1 year olds
res53 = read.csv("TableS4_diffAnalysis_1yr.csv")
# upload result for 18-week-olds
res18 = read.csv("TableS3_diffAnalysis_18wk.csv")

# -------------- create bed files from result file----------
# select only the known chromosomes
chromosomes = c(paste0("chr", seq(1,22)), "chrX")
bed53 = res53 %>% 
  select(X) %>% 
  tidyr::extract(X, c("chr", "start", "end"), regex = "(.*)_([^_]+)_([^_]+)$") %>% 
  filter(chr %in% chromosomes)
#write.table(bed53, "bed53.bed", sep = "\t", quote = F, row.names = F, col.names = F)

bed18 = res18 %>% 
  select(X) %>% 
  tidyr::extract(X, c("chr", "start", "end"), regex = "(.*)_([^_]+)_([^_]+)$") %>% 
  filter(chr %in% chromosomes)
# write.table(bed18, "bed18.bed", sep = "\t", quote = F, row.names = F, col.names = F)

# in command line - sort BED files and use bedtools to get intersections:
#sort -k1,1 -k2,2n bed53.bed > sortedbed53.bed
#sort -k1,1 -k2,2n bed18.bed > sortedbed18.bed
#bedtools intersect -a sortedbed18.bed -b sortedbed53.bed -wao > intersect18_vs53.bed


# upload the intersects: 
intersects = read.delim("intersect18_vs53.bed", header = F)

# ALUVIAL PLOT!
# connect peaks with results and create table indicating how a given 
# peak changes
aluvialTable = intersects %>% 
  filter(V4 != ".") %>% 
  unite(peak18, c("V1", "V2", "V3")) %>% 
  unite(peak53, c("V4", "V5", "V6")) %>% 
  dplyr::rename(overlap = V7) %>% 
  right_join(res18, by = c("peak18" = "X")) %>% 
  mutate(peak53 = ifelse(is.na(peak53), "nonExistent", peak53)) %>% 
  mutate(lfc18 = log2FoldChange) %>% 
  select(peak18, peak53, lfc18) %>% 
  full_join(res53, by = c("peak53" = "X")) %>% 
  mutate(lfc53 = log2FoldChange) %>% 
  select(peak18, peak53, lfc18, lfc53) %>% 
  mutate(week18 = ifelse(is.na(lfc18), "None",
                          ifelse(lfc18 < 0, "Up", "Down"))) %>% 
  mutate(week53 = ifelse(is.na(lfc53), "None",
                          ifelse(lfc53 < 0, "Up", "Down"))) %>% 
  select(week18, week53) %>% 
  unite("combo", week18:week53, remove = F) %>% 
  gather(key = "age", value = "direction", -combo) %>% 
  group_by(age, direction, combo) %>% 
  tally()

# factorize to enforce order we want
aluvialTable$direction <- factor(aluvialTable$direction, levels = c("Up", "Down", "None"))
# plot the alluvial plot
p = ggplot(aluvialTable,
       aes(x = age, stratum = direction, alluvium = combo,
           y = n,
           fill = direction, label = direction)) +
  scale_x_discrete(expand = c(.1, .1)) +
  geom_flow() +
  geom_stratum(alpha = .9) +
  geom_text(stat = "stratum", size = 6) +
  theme_void() + 
  scale_fill_manual(values = c("#C25B56", "#96C0CE", "#BEB9B5")) +
  ylab("a") + guides(fill=FALSE)

p

ggsave("alluvialPlot.pdf", width = 3, height = 2.5)

