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


out_dir <- '/Users/mmir/Library/CloudStorage/Dropbox/D1-P/0-git-sf-P/ReRA-first-pilot-sum-stat-20240310-sf/out'


# survey time dist

fpi <- glue('{out_dir}/dur_m.xlsx')
fpo <- glue('{out_dir}/overall.png')

df <- read_excel(fpi)


ggplot(data.frame(df), aes(x = duration_m)) +
  geom_histogram(binwidth = 5, fill = "#56B4E9", colour = "#56B4E9", alpha = 0.5) +
  geom_vline(xintercept=mean(df$duration_m), linetype="dashed", color = 'red') +
  labs(x = "Duration (Minutes)",
       y = "Count") +
  scale_x_continuous(breaks=seq(0,155,5)) +
  annotate("text", x=mean(df$duration_m) - 1.5, y=2.5, label= "mean", angle=90, size=6) +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))


ggsave(fpo)


# survey time by track

fp <- glue('{out_dir}/survey_time_by_track.xlsx')
df <- read_excel(fp, col_names = T)
fpo <- glue('{out_dir}/survey_time_by_track.png')


ggplot(df) + 
  geom_bar(aes(x=Track, y=Mean, group=factor(Track)), position="dodge", stat="identity", fill='#56B4E9', alpha = .5) + 
  scale_x_discrete(limits = df$Track) +
  scale_y_discrete(limits = seq(0, 80, 10)) + 
  geom_errorbar(aes(x=Track, ymin=Mean-STD, ymax=Mean+STD, group=factor(Track)), width=0.3, colour="orange", alpha=.9, size=1.2) +
  labs(x = '',
       y = "Mean Time (Minutes)") +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggsave(fpo)

###

# page time dist

fpi <- glue('{out_dir}/page_times_dist.xlsx')
fpo <- glue('{out_dir}/page_times_dist.png')

df <- read_excel(fpi)


ggplot(data.frame(df), aes(x = duration_m)) +
  geom_histogram(fill = "#56B4E9", colour = "#56B4E9", alpha = 0.5) +
  geom_vline(xintercept=mean(df$duration_m), linetype="dashed", color = 'red') +
  labs(x = "Page Duration (Minutes)",
       y = "Count") +
  scale_x_continuous(breaks=seq(0,25,1)) +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggsave(fpo)

##

# mean page time by track

fp <- glue('{out_dir}/page_times_mean.xlsx')
df <- read_excel(fp)

fpo <- glue('{out_dir}/mean_pt.png')

names(df) <- c('name', 'mean', 'std')


ggplot(df) + 
  geom_bar(aes(x=name, y=mean, group=factor(name)), position="dodge", stat="identity", fill='#56B4E9', alpha = .5) + 
  geom_errorbar(aes(x=name, ymin=mean-std, ymax=mean+std, group=factor(name)), width=0.3, colour="orange", alpha=.9, size=1.2) +
  labs(x = '',
       y = "Mean Time (Minutes)") +
  scale_x_discrete(limits = df$name) + 
  scale_y_discrete(limits=seq(-2,6, 1)) +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggsave(fpo)

##

# Ins page dist

fpi <- glue('{out_dir}/ins_times_dist.xlsx')
fpo <- glue('{out_dir}/ins_dist.png')

df <- read_excel(fpi)


ggplot(data.frame(df), aes(x = duration_m)) +
  geom_histogram(fill = "#56B4E9", colour = "#56B4E9", alpha = 0.5) +
  geom_vline(xintercept=mean(df$duration_m), linetype="dashed", color = 'red') +
  labs(x = "Instructions Page Duration (Minutes)",
       y = "Count") +
  scale_x_continuous(breaks=seq(0,25,1)) +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggsave(fpo)

##

# Ins mean 

fp <- glue('{out_dir}/ins_mean.xlsx')
df <- read_excel(fp)
fpo <- glue('{out_dir}/mean_ins.png')

names(df) <- c('name', 'mean', 'std')


ggplot(df) + 
  geom_bar(aes(x=name, y=mean, group=factor(name)), position="dodge", stat="identity", fill='#56B4E9', alpha = .5) + 
  geom_errorbar(aes(x=name, ymin=mean-std, ymax=mean+std, group=factor(name)), width=0.3, colour="orange", alpha=.9, size=1.2) +
  scale_x_discrete(limits = df$name) +
  labs(x = '',
       y = "Mean (Minutes)") +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

ggsave(fpo)

##

fp <- glue('{out_dir}/idle_time_pct.xlsx')
df <- read_excel(fp)
fpo <- glue('{out_dir}/idle_time_pct.png')


names(df) <- c('name', '2\u03C3', '3\u03C3')

library(reshape2)
molted=melt(df,id.vars=c("name"))
molted

df <- molted



ggplot(df) + 
  geom_bar(aes(name, value, fill=variable), position="dodge", stat="identity", alpha = .5) + 
  scale_x_discrete(limits = df$name[1:7]) +
  labs(x = '',
       y = "Idle Time Ratio (%)") +
  theme_bw() + 
  theme(text=element_text(size=20), panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.title=element_blank())

ggsave(fpo)




##




 










