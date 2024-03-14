#!/usr/bin/env Rscript

install.packages("data.table")
install.packages("dplyr")
install.packages("glue")
install.packages("readxl")

library("data.table")
library("dplyr")
library("plinkFile")
library("genio")
library("ggplot2")
library("glue")
library('readxl')


plot_corr <- function(pair_type, pn, gtype, gn, info, dn) {

  st <- paste('corr', pair_type, gtype, info, sep = '_')
  fp <- glue('{dta_dir}/{st}.xlsx')
  
  ost <- paste('corr_hist', pair_type, gtype, info, sep = '_')
  fpo <- glue('{fig_dir}/{ost}.png')
  
  df <- read_excel(fp, col_names = F)
  
  n_snps <- nrow(df)
  
  ggsave(fpo)
  
}


out_dir <- '/Users/mmir/Library/CloudStorage/Dropbox/3-MBPro/0-sf-git-MBP/ReRA-first-pilot-sum-stat-20240310-sf/out'
fpi <- glue('{out_dir}/dur_m.xlsx')
fpo <- glue('{out_dir}/overall.png')

df <- read_excel(fpi)


ggplot(data.frame(df), aes(x = duration_m)) +
  geom_histogram(binwidth = 5, fill = "#56B4E9", colour = "#56B4E9", alpha = 0.5) +
  geom_vline(xintercept=mean(df$duration_m), linetype="dashed", color = 'red') +
  labs(title = 'Distribution of Survey Completion Time (n = 25)',
       x = "Duration (Minutes)",
       y = "Count") +
  scale_x_continuous(breaks=seq(0,155,5)) +
  theme_classic() 

ggsave(fpo)


fp <- '/Users/mmir/Library/CloudStorage/Dropbox/3-MBPro/0-sf-git-MBP/ReRA-first-pilot-sum-stat-20240310-sf/out/mean.xlsx'
df <- read_excel(fp)

names(df) <- c('name', 'mean', 'std')

ggplot() + 
  geom_bar(data = df, aes(x = name, y = mean), color = "black")


ggplot(df) + 
  geom_bar(aes(x=name, y=mean), position="dodge", stat="identity", fill='#56B4E9') + 
  geom_errorbar(aes(x=name, ymin=mean-std, ymax=mean+std), width=0.4, colour="orange", alpha=0.9, size=1.3) +
  labs(title = 'Overall and Across Tracks Mean Time (minutes)',
       x = '',
       y = "Mean (Minutes)") +
  theme_classic()

?geom_bar

 










