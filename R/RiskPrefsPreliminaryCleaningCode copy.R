# Cleaning the Risk Preferences Survey data
# Code by: Dimitriy Leksanov
# Created on: 02/21/24
# Modified on: 02/21/24

rm(list = ls())
library(gdata)
setwd("~")
dataset <- "baseline_4000_passed_QC"
base_wd <- getwd()
base_wd <-gsub("/Documents|/Dropbox|/PC|/OneDrive","",base_wd)
analysis_wd <- ifelse(grepl("colby", base_wd), "/Dropbox/whatisagoodlife/Analysis/Analysis_Colby", ifelse(grepl("Colby",base_wd),"/Dropbox/whatisagoodlife/Analysis/Analysis_Colby",ifelse(grepl("dominic", base_wd),"/Dropbox/whatisagoodlife/Analysis/Analysis_Dominic",ifelse(grepl("johl", base_wd),"/Dropbox/whatisagoodlife/Analysis/Analysis_Jeffrey",ifelse(grepl("dimitriyl|leksa", base_wd),"/Dropbox/whatisagoodlife/Analysis/Analysis_Dimitriy", "/Dropbox/whatisagoodlife/Analysis/Analysis_Tushar")))))

# load the default packages
source(paste0(base_wd, "/Dropbox/whatisagoodlife/Analysis/Collaborative_Code/default_packages.R"))
packages <- default_packages
packages = packages[! packages %in% c("COEF")]
packages = packages[packages != "rgeolocate"] # deprecated package
new.packages <- packages[!(packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(packages, library, character.only = TRUE)

# load the default paths and functions
source(paste0(base_wd,"/Dropbox/whatisagoodlife/Analysis/Collaborative_Code/default_datasets_and_paths_new.R"))
source(paste0(base_wd,"/Dropbox/whatisagoodlife/Analysis/Collaborative_Code/default_all_functions.R"))


install.packages("magrittr") # package installations are only needed the first time you use it
install.packages("dplyr")    # alternative installation of the %>%
install.packages('tidyverse')




library(car)
library(gt)
library(htmltools)
library(shiny)
library(grid)
library("data.table")
library("dplyr")
library("plinkFile")
library("genio")
library("ggplot2")
library("glue")
library('readxl')
library(readr)
library(tidyverse)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)

set.seed(42)


# To create continual "numbering" for Fielding Waves, but with letters
letters_continual_order <- function(num) {
  final <- c()
  for (i in c(1:num)) {
    div_num = floor(i / 26)
    mod_num = i %% 26
    
    to_append = paste0(paste(rep("Z", div_num), collapse = ""), LETTERS[mod_num])
    final <- c(final, to_append)
    # print(final)
  }
  final
}


base_wd <- '/Users/mmir/Library/CloudStorage/Dropbox/D1-P/ReRA/RiskPreferences'

input_data_pilot <- paste0(base_wd, "/Pilot/")
input_data_raw <- paste0(base_wd, "/Pilot/Raw/")
input_data_pagetimes <- paste0(base_wd, "/Pilot/PageTimes/")
input_data_assignment_tables <- paste0(base_wd, "/Pilot/Manual_Qualification_Criteria/")

################# CHANGE THIS!!!! #####################
curr_date <- "2024-02-20"
date_for_hit_table <- "2024-02-28" # need to change this -- for Batch labeling!!
#######################################################

# Read in raw data
raw_data_1 <- read_csv(paste0(input_data_raw, "all_apps_wide_2024-02-02.csv"))
raw_data_2 <- read_csv(paste0(input_data_raw, "all_apps_wide_2024-02-20.csv"))
raw_data_new <- read_csv(paste0(input_data_raw, "all_apps_wide_", curr_date, ".csv"))

# Put the raw data files together
if (curr_date == "2024-02-20") { # raw_data_new == raw_data_2
  raw_data_1 %<>% filter(!(participant.code %in% raw_data_2$participant.code))
  raw_data <- as.data.frame(rbind(raw_data_1, raw_data_2))
} else {
  raw_data_2 %<>% filter(!(participant.code %in% raw_data_new$participant.code))
  raw_data_1 %<>% filter(!(participant.code %in% c(raw_data_2$participant.code,
                                                   raw_data_new$participant.code)))
  raw_data <- as.data.frame(rbind(raw_data_1, raw_data_2, raw_data_new))
}

# Read in Assignment Table
assignment_table <- read_csv(paste0(input_data_assignment_tables, "Assignment_table", curr_date, ".csv"))

# Read in people who have already been Bonused
already_bonused <- read_csv(paste0(input_data_pilot, "bonuses_sent_workerIds.csv"))

# Read in people who have already been Rejected
already_rejected <- read_csv(paste0(input_data_pilot, "assignments_rejected_workerIds.csv"))

# Read in the timing of each screen seen by participant
# Tells us whether the participant ever got to the end
page_times_data <- read_csv(paste0(input_data_pagetimes, "PageTimes-", curr_date, ".csv"))

# Allow for people who write their surveycode into "Feedback"
# Should be non-NA AND (presumably) 8 digits
assignment_table %<>% mutate(
  effective_surveycode = ifelse(is.na(surveycode), feedback,
                                ifelse(((nchar(surveycode) != 8) & (nchar(feedback) == 8)), feedback,
                                       surveycode))
)

# Merge in the people who have already been bonused or rejected
assignment_table %<>% merge(
  already_bonused,
  by.x = "WorkerId", by.y = "workerId", all.x = T
)

merged_data <- assignment_table %>% merge(
  raw_data,
  by.x = "effective_surveycode", by.y = "participant.code", all.y = T
)

# Trim the data for the timing of each screen seen by participant
page_times_data_trimmed <- page_times_data %>%
  select(participant_code, page_index, app_name, page_name, epoch_time_completed) %>%
  filter(!is.na(epoch_time_completed)) %>%
  group_by(participant_code) %>%
  arrange(desc(page_index)) %>%
  slice(1)

# Merge in the timing data
merged_data %<>% merge(
  page_times_data_trimmed, by.x = "effective_surveycode", by.y = "participant_code", all.x = T
)

# Remove NA WorkerId rows and keep only the most recent response (if they somehow took it twice)
merged_data %<>% filter(!is.na(WorkerId))
merged_data <- merged_data %>%
  group_by(WorkerId) %>%
  filter(participant.time_started_utc == max(participant.time_started_utc)) %>%
  ungroup()

# Now, need to keep track of the Fielding Batch
# Process of labelling lifepsych waves
already_fielded <- read_csv(paste0(input_data_pilot, "already_fielded_workerIds.csv"))
# Really specific tidying steps for the Pilot so that we have an easy reference for
# which track someone was assigned to 
already_fielded %<>% mutate(Batch = str_replace(Batch, "TSN", " --- TSN"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "TSI", " --- TSI"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "TL", " --- TL"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "CSN", " --- CSN"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "CSI", " --- CSI"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "CL", " --- CL"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch1", " --- TSI"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch2", " --- CSI"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch3", " --- TSN"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch4", " --- CSN"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch5", " --- TL"))
already_fielded %<>% mutate(Batch = str_replace(Batch, "Batch6", " --- CL"))
# How to handle "Hitgroup #" string that will be present in the Main survey fielding:
already_fielded %<>% mutate(Batch = str_replace(Batch, "Hitgroup", " --- -- "))
# Separate the Batch string from survey track abbreviation
already_fielded %<>% separate(Batch, into = c("fielding_batch_key", "PilotTrack"), sep = " --- ")
# Blank out PilotTrack for Main survey (non-Pilot) Batches
already_fielded %<>% mutate(PilotTrack = ifelse(PilotTrack %in% c("TSN", "TSI", "TL", "CSN", "CSI", "CL"),
                                                PilotTrack, ""))
# Set RiskPrefsSurvey to "Pilot" if in one of the Pilot tracks; "Main" otherwise
already_fielded %<>% mutate(RiskPrefsSurvey = ifelse(PilotTrack %in% c("TSN", "TSI", "TL", "CSN", "CSI", "CL"),
                                                     "Pilot", "Main"))

# Pull in the HIT Table - this gives us the CreationTime of each HIT
hittable <- read_csv(paste0("/Users/mmir/Library/CloudStorage/Dropbox/D1-P/ReRA/HITTables/HITTABLE", date_for_hit_table, ".csv")) %>%
  select(HITId, CreationTime, Description) %>%
  filter(str_detect(Description, "preferences for different payouts at varying levels of risk")) %>%
  mutate(
    CreationTime = as.numeric(CreationTime)
  )
hittable %<>% merge(merged_data %>% select(HITId, WorkerId), by = "HITId", all.x = T) %>%
  select(HITId, CreationTime, WorkerId)

# Merge in
already_fielded %<>% merge(hittable, by.x = "workerId", by.y = "WorkerId", all.x = T) 

# Get the earliest fielding time of every Fielding Batch
already_fielded_first_times <- already_fielded %>%
  select(fielding_batch_key, CreationTime) %>%
  group_by(fielding_batch_key) %>%
  arrange(CreationTime, .by_group = T) %>%
  slice(1) %>%
  rename(fielding_batch_creation_time = CreationTime) 
already_fielded_first_times$FieldingBatch = letters_continual_order(nrow(already_fielded_first_times))[1:nrow(already_fielded_first_times)]

# Finalize the Fielding Batch columns
already_fielded %<>% merge(already_fielded_first_times, by = "fielding_batch_key")
fielding_batch_columns <- already_fielded %>%
  filter(!is.na(workerId)) %>%
  select(workerId, FieldingBatch, fielding_batch_creation_time) %>%
  mutate(FieldingBatchCreationTime = lubridate::as_datetime(fielding_batch_creation_time)) %>%
  select(workerId, FieldingBatch, FieldingBatchCreationTime)

# Merge in
merged_data %<>% merge(fielding_batch_columns, by.x = "WorkerId", by.y = "workerId")

# Remove anyone who was rejected
merged_data %<>% filter(!(WorkerId %in% already_rejected$workerId))

# Merge in workerNums
workerId_workerNum_map <- read_csv(paste0(base_wd, "/Dropbox/WIAGL_DATA/WorkerIdNumMap.csv"))
merged_data %<>% merge(workerId_workerNum_map %>% rename(WorkerId = workerId), by = "WorkerId", all.x = T)

# Remove unnecessary columns
merged_data %<>% select(-c("effective_surveycode", "WorkerId",
                           "...1", "AssignmentId", "HITId", "AssignmentStatus",
                           "Answer", "RequesterFeedback", "surveycode", "feedback",
                           "moresurveys", "AutoApprovalTime", "ApprovalTime",
                           "AcceptTime", "SubmitTime", "Survey Code")) %>%
  rename(bonus_date = Date,
         bonus_amount = Amount)

# Reorder columns to put workerNum first
merged_data <- merged_data[, c("workerNum", setdiff(colnames(merged_data), c("workerNum")))]
merged_data %<>% mutate(total_payment = bonus_amount + 0.10)

write.csv(merged_data, paste0('/Users/mmir/Library/CloudStorage/Dropbox/D1-P/0-git-sf-P/ReRA-first-pilot-sum-stat-20240310-sf/mahdi-', curr_date, ".csv"), row.names = F)
