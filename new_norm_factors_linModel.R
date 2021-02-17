rm(list = ls())
# script for regressing out the relationship between the
# percentage of mapped drosophila reads and the total number of reads
# -> output are final normalization factors used in the differential
# analysis by DESeq2

library(tidyverse)
library(ggpubr)

dm_numbers = read.csv("dm_factor_data/normalize_dm_counts_linModel.csv")

# 1) ---get the linear model stats---
fitPercent = lm(dm_percent  ~ num_of_reads, data = dm_numbers)
summary(fitPercent)

# plot scatte plot with linear mode fit
p = ggplot(dm_numbers, aes(x = num_of_reads, y = dm_percent))
p + geom_point(size = 2.5, aes(color = phenotype)) +
  scale_color_manual(values=c("#74828F", "#C25B56")) + 
  theme_bw(base_size = 12) + 
  ylab("% of drosophila reads") + 
  xlab("# of sequenced reads") + 
  theme(legend.position="bottom") + 
  geom_smooth(method = "lm", se = F, color = "black") + 
  stat_cor(label.y = 1.8)
ggsave("D_dmPrecent_linModel.pdf", width = 3, height = 3)


# 2) ---get residuals and recalculate normalization factors---
# get the residuals
plotResid = fitPercent$model
plotResid$resid = fitPercent$residuals
plotResid$phenotype = dm_numbers$phenotype
plotResid$scaledResid  = fitPercent$residuals + 1

# plot residuals
p = ggplot(plotResid, aes(y = resid, x = num_of_reads))
p + geom_point(size = 2.5, aes(color = phenotype))+
  scale_color_manual(values=c("#74828F", "#C25B56")) + 
  theme_bw(base_size = 12) + 
  ylab("residual") + 
  xlab("# of sequenced reads") + 
  theme(legend.position="bottom") 
ggsave("E_dmPrecent_linModel_residual.pdf", width = 3, height = 3)

# plot residuals with scaling factor + 1 (this way we don't get negative values)
p = ggplot(plotResid, aes(y = scaledResid, x = num_of_reads))
p + geom_point(size = 2.5, aes(color = phenotype))+
  scale_color_manual(values=c("#74828F", "#C25B56")) + 
  theme_bw(base_size = 12) + 
  ylab("residual + 1") + 
  xlab("# of sequenced reads") + 
  theme(legend.position="bottom") 
#ggsave("E_dmPrecent_linModel_residual_plus1.pdf", width = 3, height = 3)

# calculate the new scaling factors = normalized mapped drosophila reads
# = total reads * new scaling factor [%] / 100
dm_numbers$dm_mapped_normalized = round(plotResid$num_of_reads * plotResid$scaledResid / 100)
dm_numbers$dm_norm_factor = dm_numbers$dm_mapped_normalized / 500000
