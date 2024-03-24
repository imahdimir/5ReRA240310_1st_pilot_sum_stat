#Default datasets and paths
if(!exists("BotttomlessA_used")) BotttomlessA_used <- 0 #to avoid the code getting stuck, this variable gets "0" if not defined
if(!exists("base_wd")) base_wd <- "~" #to avoid the code getting stuck
if(!exists("analysis_wd")) analysis_wd <- "/whatisagoodlife/Analysis/Analysis_Tushar/Misc. Survey Analysis/" #to avoid the code getting stuck

                        #### Standard Paths and datasets #### 

code_locations <- paste0(base_wd,analysis_wd,"/Code/hebrewucollaboration/")

default_gamma <- 59.9 # Make sure this uses newest value from MLE.

default_wd                                    <- paste0(base_wd,analysis_wd,"/temporary_files/")
default_input                                 <- paste0(base_wd,"/Dropbox/cleandata/")
default_raw_input                             <- paste0(base_wd,"/Dropbox/WIAGL_DATA/")
default_uncleaned_input                       <- paste0(base_wd,"/Dropbox/whatisagoodlife/Data/")
default_output                                <- paste0(base_wd,analysis_wd,"/Output/")
default_UAS_wd                                <- paste0(base_wd,"/Dropbox/whatisagoodlife/Surveys - UAS/")
semiparametric_means_all_33 <- paste0(default_input, "SemiParametric_3358.csv")
semiparametric_means <- paste0(default_input, "SemiParametric_3358_JustUKFour.csv")
mle_means <-  paste0(default_input,"MLE_Means_2316.csv")
mle_output_spaces_delimited <- paste0(default_input,"MLE_Output_1_6_2023.csv")
#default_output                                <- "/Users/dominickassirra/Dropbox/whatisagoodlife/Analysis/Analysis_Baseline/Other_Analyses/Test_Master_Script_Analyses_again/"

# workerId-workerNum map
default_workerIdNumMap <- paste0(default_raw_input, "WorkerIdNumMap.csv")

# Map of all Prescreen respondents with workerNums (i.e. those who did Baseline)
# Includes their workerNums and workerIds
default_prescreen_workerIdNumMap <- paste0(default_raw_input, "Prescreen/PrescreenWorkerIdNumMap.csv")

# Deidentified version (no workerId)
default_prescreen_workerNumMap_noId <- paste0(default_input, "PrescreenWorkerNumMap.csv")

big_five <- c("Extraversion","Agreeability","Conscientiousness","Neuroticism","Openness")
big_five_z_score <- paste0(big_five,"_Z_score")

# Defining combinations of Baseline and Life and Psych indices
baseline_indices_no_reverse_coding <- c(
  "strangersSum", "cost_difficultySum", "democratic_republic", "social_views_number",
  "economic_views_number", "religiousImportance_number", "trade", "immigration",
  "election_stolen", "numbers_words",
  #"possible",
  #"grade_self", 
  "understanding", 
  # "commute_pleasant",
  "thermometer",
  "effort", 
  "enjoyability"
)

baseline_indices_no_reverse_coding_long <- c(
  "Tendency to talk to strangers (0 to 4)",
  "Difficulty paying bills (0 to 18)",
  "Democratic-Republican  (-2 to 2)",
  "Socially Liberal to Conservative (-3 to 3)",
  "Economically Liberal to Conservative (-3 to 3)",
  "Religious Importance (0 to 3)",
  "Approves Trade Restrictions (-1 to 1)",
  "Immigration is Bad (-1 to 1)", 
  "2020 Election was Stolen (0 to 3)", 
  "Numbers vs Words (-1 to 1)",
  # "Interpretation of 'possible' (0 to 4)",
  # "How easily you grade yourself (0 to 4)",
  "How well you understood survey (0 to 2)",
  # "How pleasant your commute is (0 to 6)",
  "Warmth of feelings to Trump (0 to 100)",
  "Effort expended on survey (0 to 100)",
  "Enjoyability of survey (0 to 100)"
)


baseline_indices_yes_reverse_coding <- c(
  "humorReweighted", "gritReweighted"
)

baseline_indices_yes_reverse_coding_long <- c(
  "Coping Humor Scale (7 to 28)",
  "Grit Scale (12 to 60)"
)



# lifepsych_indices_no_reverse_coding <- c(
#   "MaximizationSum", "PerfectionismSum"
# )

# lifepsych_indices_no_reverse_coding_long <- c(
#  
#   "Maximization (12 to 60)",
#   "Perfectionism (8 to 40)"
# )

lifepsych_indices_yes_reverse_coding <- c(
  "ExtraversionReweighted",  "AgreeabilityReweighted", 
  "ConscientiousnessReweighted",  "NeuroticismReweighted", 
  "OpennessReweighted", 
 # "SocialDesirabilityReweighted",
#  "SocialComparisonReweighted",
 "GSOEPReweighted", 
  "DesireControlReweighted"
#"NPIReweighted", 
#"EmpathyReweighted",
#"EntitlementReweighted"
)

lifepsych_indices_yes_reverse_coding_long <- c(
  
  "Extraversion (3 to 15)",  
  "Agreeability (3 to 15)", 
  "Conscientiousness(3 to 15)", 
  "Neuroticism(3 to 15)", 
  "Openness(3 to 15)", 
 # "Social Desirability (0 to 13)",
#  "Tendency to Social Comparison (11 to 55)",
  "Locus of Control (10 to 70)", 
  "Desirability of Control (7 to 154)"
 # "Narcissism Index (0 to 16)",
 # "Empathy Index (0 to 80)",
  #"Entitlement Index (9 to 63)"
)


sources_of_scale_use =  c("NPISum",
                          "SocialDesirabilitySum",
                          "EmpathySum",
                          "PerfectionismSum",
                          "EntitlementSum",
                          "MaximizationSum",
                          "SocialComparisonSum"
)

source_of_scale_use_long = c("Narcissism Index (0 to 16)",
                             "Susceptibility to Social Desirability Index (0 to 13)",
                             "Empathy Index (0 to 80)",
                             "Perfectionism Index (8 to 40)",
                             "Entitlement Index (9 to 63)",
                             "Maximizing Index (12 to 60)",
                             "Tendency to Social Comparison (11 to 55)"
)

all_baseline_indices <- c(baseline_indices_no_reverse_coding,
                          baseline_indices_yes_reverse_coding
                          )

all_baseline_indices_long<-c(baseline_indices_no_reverse_coding_long,
                                  baseline_indices_yes_reverse_coding_long
                                  )

all_lifepsych_indices <- c(                           lifepsych_indices_yes_reverse_coding)

all_lifepsych_indices_long <- c(
                           lifepsych_indices_yes_reverse_coding_long)

all_indices_no_reverse_coding <- c(baseline_indices_no_reverse_coding)

all_indices_no_reverse_coding_long <- c(baseline_indices_no_reverse_coding_long)

all_indices_yes_reverse_coding <- c(baseline_indices_yes_reverse_coding,
                                    lifepsych_indices_yes_reverse_coding)

all_indices_yes_reverse_coding_long <- c(baseline_indices_yes_reverse_coding_long,
                                         lifepsych_indices_yes_reverse_coding_long)

all_indices_baseline_and_lifepsych <- c(all_baseline_indices,
                                        all_lifepsych_indices)

all_indices_baseline_and_lifepsych_long <- c(all_baseline_indices_long,
                                             all_lifepsych_indices_long)

### Define default paths for data ###                
default_data_baseline_500                         <- paste0(default_input, "data_demographics_ratings_500.csv")
#default_data_baseline_invite_InformativeNone  <- paste0(default_input, "data_demographics_ratings_500_OnlyInformativeNone.csv")
#default_data_baseline_invite_InformativeCQ    <- paste0(default_input, "data_demographics_ratings_500_OnlyInformativeCQ.csv")
#default_data_baseline_invite_InformativeAspect<- paste0(default_input, "data_demographics_ratings_500_OnlyInformativeAspect.csv")
#default_data_baseline_invite_InformativeBoth  <- paste0(default_input, "data_demographics_ratings_500_OnlyInformativeBoth.csv")
#default_data_baseline_noninvite               <- paste0(default_input, "data_demographics_ratings_500_OnlyExcluded.csv")
#default_data_baseline_invite                  <- paste0(default_input, "data_demographics_ratings_500_OnlyNonExcluded.csv")
#default_data_baseline2_invite                 <- paste0(default_input, "data_demographics_ratings_500_OnlyNonExcluded_2.csv")
default_data_baseline                         <- paste0(default_input, "data_demographics_ratings_500.csv")
default_data_baseline2                        <- paste0(default_input, "Baseline 500, Baseline 500 II (2020)/data2_demographics_ratings_500batch456.csv")
default_data_pilot_baseline                   <- paste0(default_input, "data_demographics_ratings.csv")
default_data_pilot_baseline_invited                   <- paste0(default_input, "data_demographics_ratings_OnlyNonExcluded.csv")
default_data_pilot_baseline2                  <- paste0(default_input, "data2_demographics_ratings.csv")
default_data_pilot_baseline2_timing           <- paste0(default_input, "baseline2_N=59_demographic_timing.csv")
default_data_Semiparametric_Jiannan_Results   <- paste0(default_input,"real_data_MMB-wx_regression-semi-2020-10-29 no star.csv")

default_data_baseline_4000                    <- paste0(default_input, "data_demographics_ratings_4000_batch2.csv")
default_data_baseline_4000_passed_QC         <- paste0(default_input, "data_demographics_ratings_4000_batch2_passed_QC.csv")
default_data_baseline_4000_passed_QC_post_cookie             <- paste0(default_input, "data_demographics_ratings_4000_batch2_passed_QC_post_cookie.csv")
default_data_baseline_4000_passed_QC_post_cookie_high_beta <- paste0(default_input, "data_demographics_ratings_4000_batch2_passed_QC_post_cookie_beta_OVER_0.5.csv")
default_data_baseline_4000_passed_QC_post_cookie_low_beta <- paste0(default_input, "data_demographics_ratings_4000_batch2_passed_QC_post_cookie_beta_UNDER_0.5.csv")
default_data_baseline_4000_passed_QC_pre_cookie <- paste0(default_input, "data_demographics_ratings_4000_batch2_passed_QC_pre_cookie.csv")
default_data_baseline_4000_failed_QC         <- paste0(default_input, "data_demographics_ratings_4000_batch2_failed_QC.csv")
default_data_baseline_4000_failed_QC_post_cookie         <- paste0(default_input, "data_demographics_ratings_4000_batch2_failed_QC_post_cookie.csv")
default_data_baseline_4000_failed_QC_pre_cookie         <- paste0(default_input, "data_demographics_ratings_4000_batch2_failed_QC_pre_cookie.csv")

# default_data_baseline_4000_500                <- paste0(default_input, "baseline_4000_500.csv")
# default_data_baseline_4000_500_passed_QC      <- paste0(default_input, "baseline_4000_500_passed_QC.csv")
# default_data_baseline_4000_500_failed_QC      <- paste0(default_input, "baseline_4000_500_failed_QC.csv")

default_choices_baseline_4000                 <- paste0(default_input, "long_clean/4000_batch2_Choices.csv")
default_posteriortypes                        <- paste0(base_wd,"/Dropbox/whatisagoodlife/Analysis/Analysis_Jeffrey/temporary_files/posterior_type_probabilities.csv")
default_summary                               <- paste0(base_wd,"/Dropbox/cleandata/597_summary_of_workers.csv")
default_tradeoffs_500                         <- paste0(base_wd,"/Dropbox/cleandata/tradeoff_analysis/data/tradeoffs_N=500_baseline.csv")
default_qualitycontrol_500                    <- paste0(default_input, "N=496_qc_summary.xlsx")


default_data_bottomlessA_no_mistaken_eats <- paste0(default_input, "4000_WideCleanedBottomlessMeanDupsNoMistakenEats.csv")

### Define default vectors for aspects ###                
default_aspect_list                           <- c(
  
  "satisfaction",
  "happiness",
  "worthwhileness",
  "no_anxiety",
  "ladder",
  "wb_you_family",
  "family_happiness",
  "physical_health",
  "mental_health",
  "sense_of_purpose",
  "sense_of_control",
  "having_people",
  "not_lonely",
  "no_anger",
  "no_sadness",
  "no_stress",
  "no_worry",
  "good_person",
  "possibilities",
  "time",
  "social_status",
  "safety",
  "financial_support",
  "not_unemployed",
  "eat",
  "housing_comfort",
  "enjoyment",
  "knowledge_skills",
  "local_safety",
  "local_air",
  "citizen_influence",
  "citizen_trust",
  "culture_honor"
  
  
  
)

default_long_names_aspect_list <- c(
  "how satisfied you are with your life",    
  "how happy you feel",
  "the extent to which you feel the things you do in your life are worthwhile",
  "you not feeling anxious",
  "your rating of your life on a ladder where the lowest rung is \"worst possible life for you\" and the highest rung is \"best possible life for you\"",
  "the overall well-being of you and your family",
  "the happiness of your family",
  "your physical health",
  "your mental health",
  "your sense of purpose",
  "your sense of control over your life",
  "you having people you can turn to in time of need",
  "you not being lonely",
  "the absence of anger in your life",
  "the absence of sadness in your life",
  "the absence of stress in your life",
  "the absence of worry in your life",
  "you being a good person",
  "you having many options and possibilities in your life and the freedom to choose among them",
  "you feeling that you have enough time for the things that are most important to you",
  "you being a winner in life",
  "your physical safety and security",
  "you being able to support your family financially",
  "you not having to worry about being unemployed",
  "you and your family having enough to eat",
  "your home being comfortable",
  "how much you enjoy your life",
  "your knowledge and skills",
  "your living environment not being spoiled by crime and violence",
  "the air in your area not being polluted",
  "the ability of ordinary citizens to influence your national government",
  "how much you can trust most people in your nation",
  "your cultures and traditions being honored"
)

default_aspect_names_map <- as.data.frame(cbind(default_aspect_list,
                                                default_long_names_aspect_list))
colnames(default_aspect_names_map) <- c("short_name", "long_name")

default_aspect_list_socially_desirable        <- c("physical_health", "mental_health","financial_support",
                                                   "knowledge_skills", "not_lonely", "having_people", "not_unemployed",
                                                   "time", "sense_of_control", "sense_of_purpose", "family_happiness", "social_status",
                                                   "possibilities", "good_person", "wb_you_family")

default_aspect_list_less_soc_des              <- setdiff(default_aspect_list,default_aspect_list_socially_desirable )
default_aspect_actuallist                     <- list("satisfaction", "worthwhileness", "happiness", "no_anxiety", "ladder", "enjoyment", "no_anger", "no_sadness", "no_stress", "no_worry", "wb_you_family", "citizen_influence", "citizen_trust", "culture_honor", "physical_health", "mental_health", "housing_comfort", "financial_support", "knowledge_skills", "safety", "local_safety", "not_lonely", "having_people", "not_unemployed", "local_air", "time", "sense_of_control", "sense_of_purpose", "family_happiness", "social_status", "eat", "possibilities", "good_person")
default_aspect_list_personal                  <- c("satisfaction", "worthwhileness", "happiness", "no_anxiety", "ladder", "enjoyment", "no_anger", "no_sadness", "no_stress", "no_worry", "wb_you_family", "physical_health", "mental_health", "housing_comfort", "financial_support", "knowledge_skills", "safety", "local_safety", "not_lonely", "having_people", "not_unemployed", "local_air", "time", "sense_of_control", "sense_of_purpose", "family_happiness", "social_status", "eat", "possibilities", "good_person")
default_aspect_list_personal_no_public_goods  <- c("satisfaction", "worthwhileness", "happiness", "no_anxiety", "ladder", "enjoyment", "no_anger", "no_sadness", "no_stress", "no_worry", "wb_you_family", "physical_health", "mental_health", "housing_comfort", "financial_support", "knowledge_skills", "safety", "not_lonely", "having_people", "not_unemployed", "time", "sense_of_control", "sense_of_purpose", "family_happiness", "social_status", "eat", "possibilities", "good_person")

default_aspect_actuallist_personal            <- list("satisfaction", "worthwhileness", "happiness", "no_anxiety", "ladder", "enjoyment", "no_anger", "no_sadness", "no_stress", "no_worry", "wb_you_family", "physical_health", "mental_health", "housing_comfort", "financial_support", "knowledge_skills", "safety", "local_safety", "not_lonely", "having_people", "not_unemployed", "local_air", "time", "sense_of_control", "sense_of_purpose", "family_happiness", "social_status", "eat", "possibilities", "good_person")

default_aspect_list_baseline2                 <- c("satisfaction2", "worthwhileness2", "happiness2", "no_anxiety2", "ladder2", "enjoyment2", "no_anger2", "no_sadness2", "no_stress2", "no_worry2", "wb_you_family2", "citizen_influence2", "citizen_trust2", "culture_honor2", "physical_health2", "mental_health2", "housing_comfort2", "financial_support2", "knowledge_skills2", "safety2", "local_safety2", "not_lonely2", "having_people2", "not_unemployed2", "local_air2", "time2", "sense_of_control2", "sense_of_purpose2", "family_happiness2", "social_status2", "eat2", "possibilities2", "good_person2")
default_aspect_actuallist_baseline2           <- list("satisfaction2", "worthwhileness2", "happiness2", "no_anxiety2", "ladder2", "enjoyment2", "no_anger2", "no_sadness2", "no_stress2", "no_worry2", "wb_you_family2", "citizen_influence2", "citizen_trust2", "culture_honor2", "physical_health2", "mental_health2", "housing_comfort2", "financial_support2", "knowledge_skills2", "safety2", "local_safety2", "not_lonely2", "having_people2", "not_unemployed2", "local_air2", "time2", "sense_of_control2", "sense_of_purpose2", "family_happiness2", "social_status2", "eat2", "possibilities2", "good_person2")
default_aspect_list_personal_baseline2        <- c("satisfaction2", "worthwhileness2", "happiness2", "no_anxiety2", "ladder2", "enjoyment2", "no_anger2", "no_sadness2", "no_stress2", "no_worry2", "wb_you_family2", "physical_health2", "mental_health2", "housing_comfort2", "financial_support2", "knowledge_skills2", "safety2", "local_safety2", "not_lonely2", "having_people2", "not_unemployed2", "local_air2", "time2", "sense_of_control2", "sense_of_purpose2", "family_happiness2", "social_status2", "eat2", "possibilities2", "good_person2")
default_aspect_actuallist_personal_baseline2  <- list("satisfaction2", "worthwhileness2", "happiness2", "no_anxiety2", "ladder2", "enjoyment2", "no_anger2", "no_sadness2", "no_stress2", "no_worry2", "wb_you_family2", "physical_health2", "mental_health2", "housing_comfort2", "financial_support2", "knowledge_skills2", "safety2", "local_safety2", "not_lonely2", "having_people2", "not_unemployed2", "local_air2", "time2", "sense_of_control2", "sense_of_purpose2", "family_happiness2", "social_status2", "eat2", "possibilities2", "good_person2")

default_category_default_aspects              <- c("private", "private", "private", "private_negative", "private", "private", "private_negative", "private_negative", "private_negative", "private_negative", "private", "national_local", "national_local", "national_local", "private", "private", "private", "private", "private", "private", "national_local", "private_negative", "private", "private_negative", "national_local", "private", "private", "private", "private", "private", "private", "private", "private")

default_aspect_compact_list                   <- c("satisfaction", "happiness", "ladder", "average_30", "average_33")
default_aspect_compact_actuallist             <- list("satisfaction", "happiness", "ladder", "average_30", "average_33")

default_kingpin_list = c(
  
  "happiness",
  "enjoyment",
  "satisfaction",
  "worthwhileness",
  "family_happiness",
  "good_person",
  "financial_support",
  "time",
  "mental_health",
  "physical_health",
  "ladder",
  "sense_of_control",
  "sense_of_purpose",
  "no_sadness",
  "not_lonely",
  "no_anxiety"
  
  
  
)
default_nonkinping_fh_list = setdiff(default_aspect_list_personal, default_kingpin_list)
# This is called "Core set" in the baseline=4000 preregistration


# 
# default_reference_characteristics <-  c("married", "degree_bachelor","ethn_white","employ_full_time","region_reside_midwest")
# default_long_names_reference <- c("Married", "Bachelor Degree", "White/Caucasian", "Employed full-time", "Residing in the Midwest")
# 
# default_nonreference_characteristics <-  c( "age_demean", "age_demean_2", "male", "hhadults", "hhchildren",
#                                           "hh_not_hh_children", "dem_log_income_psp", "married_not_with_partner_no_live",
#                                           "married_not_with_partner_live", "married_not_no_partner",
#                                          "separated","divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college",
#                                          "degree_nocollege","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish",
#                                          "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number", "region_reside_northeast", "region_reside_west", "region_reside_south")
# 
# default_long_names_nonreference               <-  c("Demeaned age", "Squared demeaned age", "Male", "Number of adults in household",
#                                                     "Number of children in household", "Number of children not in household",
#                                                     "Demeaned log(income/sqrt(hhsize))", "Not married but a partner outside the house", 
#                                                     "Not married but a partner in the house", 
#                                                     "Not married and no partner", "Separated", "Ever divorced", 
#                                                     "Widowed", "Other relationship status", "Graduate Degree",
#                                                     "Attended some college", "No college", "Other non-white", "Asian",
#                                                     "Black/African American","Hispanic/Latino/Spanish", 
#                                                     "Employed part-time", "Unemployed", "Out of labor force/other", "Religious attendance (0 to 5, 'Never' to 'More than once a week')", "Residing in the Northeast", "Residing in the West", "Residing in the South" )
# 
# default_characterstics_list <- c(default_reference_characteristics,default_nonreference_characteristics)
# default_characterstics_actuallist <- list("married", "degree_bachelor","ethn_white","employ_full_time","region_reside_midwest", "age_demean",
#                                           "age_demean_2", "male","hhadults", "hhchildren", "hh_not_hh_children", "dem_log_income_psp",
#                                           "married_not_with_partner_no_live", "married_not_with_partner_live", "married_not_no_partner", "separated","divorced","widowed",
#                                           "other_relationship",  "degree_graduate", "degree_some_college", "degree_nocollege","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number", "region_reside_northeast", "region_reside_west", "region_reside_south")
# default_long_names_characteristics            <- c(default_long_names_reference,default_long_names_nonreference)
# 




# This is "Simplified"


#default_simple_reference_characteristics <-  c(### Check if these are the refernce groups Miles wants.
#                                               "children_at_least_1", "hhsize_2more",### Check if these are the refernce groups Miles wants.
#                                               "ethn_white","employ_full_time","region_reside_midwest")### Check if these are the refernce groups Miles wants.
#default_simple_long_names_reference <- c("Married, not Separated", 
#                                        "One child", "At least 2 people in household",
 #                                        "White/Caucasian", "Employed full-time", "Residing in the Midwest")


default_blanchflower <- c("male", "statereside",   "married_not_separated",  "employ_part","employ_not_employed", "employ_OOLF_other")
default_blanchflower_long <- c("Male", "State of residence", "Married, not separated",
                               "Employed part-time", "Unemployed", "Out of labor force/other")
# 'state' isn't relevant for us, since Blancfhlower means country
default_blanchflower_limited <- c("male", "statereside")
default_blanchflower_limited_long <- c("Male", "State of residence")

default_simple_nonreference_characteristics_dec2022 <-  c( "age_demean_div_10", "age_demean_div_10_2", "male", 
                                                   "married_not_separated",
                                                   
                                                   "hhchildren_under19_1more",   
                                                   "hhchildren_under19_2more",
                                                   "hh_not_hh_children_under19_1more",
                                                   
                                                   "hh_not_hh_children_19over_1more",
                                                   "hhchildren_19over_1more",
                                                   "hhpeople_non_child_spouse_partner_1more",
                                                   "hh_member_disability_or_serious_problem",
                                                   "log_BMI", # Probably should be demeaned
                                                   "male_log_BMI",
                                                   "usborn",
                                                   "moved",
                                                   
                                            "democrat", 
                                            "dem_log_income_psp", "ever_divorced",
                                           
                                             "college_grad","ethn_other", "ethn_asian", 
                                            "ethn_black_african_american", "ethn_hispanic_latino_spanish", 
                                            "employ_part","employ_not_employed", "employ_OOLF_other", 
                                            "religiousAttendance_number",
                                            "region_reside_northeast", "region_reside_west", "region_reside_south",
                                            "log_height_numeric_meter",
                                            "log_height_numeric_meter_male",
                                            "density_quartile_2",
                                            "density_quartile_3",
                                            "density_quartile_4")

default_simple_long_names_nonreference_dec2022               <-  c("Demeaned age/10", "(Demeaned age/10) squared", "Male", 
                                                           "Married, not separated",
                                                           
                                                           ">=1 Children in HH <= age 18",   
                                                           ">=2 Children in HH <= age 18",
                                                           ">=1 Children out of HH <= age 18",
                                                           
                                                           ">=1 Children out of HH > age 18",
                                                           ">=1 Children in HH > age 18",
                                                           ">=1 People in HH aren't a spouse, partner, or child",
                                                           ">=1 Members of HH has Disability or Other Serious Problem",
                                                           "Log(BMI)",
                                                           "Male x Log(BMI)",
                                                           "Born in U.S.",
                                                           "Moved from Birth State",
                                                    "Political party is Democrat",
                                                    "Demeaned log(income/sqrt(hhsize))",
                                                    "Ever Divorced",
                                                   
                                                    
                                                    
                                                     "College Graduate", 
                                                    "Other non-white", "Asian",
                                                    "Black/African American","Hispanic/Latino/Spanish", 
                                                    "Employed part-time", "Unemployed", "Out of labor force/other",
                                                    "Religious attendance (0 to 5, 'Never' to 'More than once a week')",
                                                    "Residing in the Northeast", "Residing in the West", "Residing in the South",
                                                    "Log(height in meters)",
                                                    "Male x Log(height in meters)",
                                                    "2nd Quartile of population density",
                                                    "3rd Quartile of population density",
                                                    "4th Quartile of population density")

default_simple_nonreference_characteristics_feb2023 <-  c( "age_demean_div_10", "age_demean_div_10_2", "male", 
                                                   "married_not_separated",
                                                   
                                                   "hhchildren_under19_1more",   
                                                   
                                                   "obese",
                                                   
                                                   "democrat", 
                                                   
                                                   "log_income", "log_hhsize",
                                                   
                                                   "ever_divorced",
                                                   
                                                   "college_grad",
                                                   
                                                   "ethn_other", "ethn_asian", 
                                                   "ethn_black_african_american", "ethn_hispanic_latino_spanish", 
                                                   
                                                   "employ_part","employ_not_employed", "employ_OOLF_other", 
                                                   
                                                   "religiousAttendance_number",
                                                   
                                                   "region_reside_northeast", "region_reside_west", "region_reside_south",
                                                   
                                                   "density_quartile_4",
                                                   
                                                   "sunday", "monday", "tuesday",
                                                   "thursday", "friday", "saturday")

default_simple_long_names_nonreference_feb2022               <-  c("Demeaned age/10", "(Demeaned age/10) squared", "Male", 
                                                           "Married, not separated",
                                                           
                                                           "Have >= 1 child",
                                                           
                                                           "Obesity",
                                                           
                                                           "Political party is Democrat",
                                                           
                                                           "Log(HH income)", "Log(hhsize)",
                                                           
                                                           "Ever Divorced",
                                                           
                                                           "College Graduate", 
                                                           
                                                           "Other non-white", "Asian",
                                                           "Black/African American","Hispanic/Latino/Spanish", 
                                                           
                                                           "Employed part-time", "Unemployed", "Out of labor force/other",
                                                           
                                                           'Religious attendance (0 “Never” to 5 “More than once a week”)',
                                                           
                                                           "Residing in the Northeast", "Residing in the West", "Residing in the South",
                                                           
                                                           "4th Quartile of population density",
                                                           
                                                           "Taken Sunday", "Taken Monday", "Taken Tuesday",
                                                           "Taken Thursday", "Taken Friday", "Taken Saturday")

default_compactforpaper_nonreference_characteristics_feb2022 <-  c( "age_demean_div_10", "age_demean_div_10_2", "male", 
                                                            
                                                            "log_income", "log_hhsize",
                                                            
                                                            "religiousAttendance_number",
                                                            
                                                            "employ_not_employed",
                                                            
                                                            "college_grad",
                                                            
                                                            "married_not_separated",
                                                            
                                                            "ethn_asian", 
                                                            
                                                            "hhchildren_under19_1more")

default_compactforpaper_long_names_nonreference_feb2022               <-  c("Demeaned age/10", "(Demeaned age/10) squared", "Male", 
                                                                    
                                                                    "Log(HH income)", "Log(hhsize)",
                                                                    
                                                                    'Religious attendance (0 “Never” to 5 “More than once a week”)',
                                                                    
                                                                    "Unemployed",
                                                                    
                                                                    "College Graduate",
                                                                    
                                                                    "Married, not separated",
                                                                    
                                                                    "Asian",
                                                                    
                                                                    "Have >= 1 child")


##################

default_simple_nonreference_characteristics <-  c( "age_demean_div_10", 
                                                   "age_demean_div_10_2", 
                                                   
                                                   "log_income", 
                                                   
                                                   "employ_not_employed",
                                                   "employ_part",
                                                   "employ_OOLF_other",
                                                   
                                                   "married_not_separated",
                                                   "ever_divorced",
                                                   
                                                   "hhchildren_under19_1more",
                                                   
                                                   "log_hhsize",
                                                   
                                                   "college_grad",
                                                   
                                                   "male", 
                                                   
                                                   "religiousAttendance_number",
                                                   
                                                   
                                                   
                                                   
                                                   
                                                   "democrat",
                                                      
                                                   "obese",
                                                   
                                                   "ethn_black_african_american", 
                                                   "ethn_hispanic_latino_spanish", 
                                                   "ethn_asian",
                                                   "ethn_other",
                                                   
                                                   "region_reside_northeast", 
                                                   "region_reside_west", 
                                                   "region_reside_south",
                                                   
                                                   "density_quartile_4",
                                                   
                                                   "sunday", "monday", "tuesday",
                                                   "thursday", "friday", "saturday")


default_simple_long_names_nonreference               <-  c("Demeaned age/10",
                                                           "(Demeaned age)2/100",
                                                           
                                                           "Log(HH income)",
                                                           
                                                           "Unemployed",
                                                           "Employed part-time",
                                                           "Out of labor force/other",
                                                           
                                                           "Married, not separated",
                                                           "Ever divorced",
                                                           
                                                           "Have >=1 child",
                                                           
                                                           "Log(HH size)",
                                                           
                                                           "College grad",
                                                           
                                                           "Male",
                                                           
                                                           'Religious attendance (0 to 5, "Never" to "More than once a week")',
                                                           
                                                           
                                                           
                                                           
                                                           
                                                           "Democrat",
                                                           
                                                           "Obese",
                                                           
                                                           "Black/African American",
                                                           "Hispanic/Latino/Spanish",
                                                           "Asian",
                                                           "Other non-white",
                                                           
                                                           "Northeast",
                                                           "West",
                                                           "South",
                                                           
                                                           "Pop density high",
                                                           
                                                           "Sunday", "Monday", "Tuesday",
                                                           "Thursday", "Friday", "Saturday"
)

default_compactforpaper_nonreference_characteristics <-  c( "age_demean_div_10", 
                                                            "age_demean_div_10_2", 
                                                            
                                                            "log_income", 
                                                            
                                                            "employ_not_employed",
                                                            "employ_part",
                                                            "employ_OOLF_other",
                                                            
                                                            "married_not_separated",
                                                            "ever_divorced",
                                                            
                                                            "hhchildren_under19_1more",
                                                            
                                                            "log_hhsize",
                                                            
                                                            "college_grad",
                                                            
                                                            "male", 
                                                            
                                                            "religiousAttendance_number",
                                                            
                                                            "ethn_asian")

default_compactforpaper_long_names_nonreference               <-  c("Demeaned age/10",
                                                                    "(Demeaned age)2/100",
                                                                    
                                                                    "Log(HH income)",
                                                                    
                                                                    "Unemployed",
                                                                    "Employed part-time",
                                                                    "Out of labor force/other",
                                                                    
                                                                    "Married, not separated",
                                                                    "Ever divorced",
                                                                    
                                                                    "Have >=1 child",
                                                                    
                                                                    "Log(HH size)",
                                                                    
                                                                    "College grad",
                                                                    
                                                                    "Male",
                                                                    
                                                                    'Religious attendance (0 to 5, "Never" to "More than once a week")',
                                                                    
                                                                    "Asian")

default_simple_nonreference_characteristics_vigs = c(default_simple_nonreference_characteristics, "vig_at_end")

default_simple_long_names_nonreference_vigs = c(default_simple_long_names_nonreference, "CQs after aspects")
default_compactforpaper_nonreference_characteristics_vigs = c(default_compactforpaper_nonreference_characteristics, "vig_at_end")

default_compactforpaper_long_names_nonreference_vigs = c(default_compactforpaper_long_names_nonreference, "CQs after aspects")

##################

#SIMPLE EXTENSION SET 1
#########

default_simple_ext1_nonreference_characteristics <-  c()

default_simple_ext1_long_names_nonreference               <-  c()
# default_simple_characterstics_list <- c(default_simple_reference_characteristics,default_simple_nonreference_characteristics)
# default_simple_characterstics_actuallist <- list()
# 
# default_simple_long_names_characteristics            <- c(default_simple_long_names_reference,default_simple_long_names_nonreference)
# 

##################

# As of now, there is no SIMPLE EXTENSION SET 2
#########


# Core modified, plus disabilities


default_disabilities_reference_characteristics <-  c("married", "degree_bachelor","ethn_white","employ_full_time","region_reside_midwest")
default_disabilities_long_names_reference <- c("Married", "Bachelor Degree", "White/Caucasian", "Employed full-time", "Residing in the Midwest")

default_disabilities_nonreference_characteristics <-  c( "age_demean", "age_demean_2", "male", "hhadults", "children_total", "number_of_children_disabilities",
                                             "dem_log_income_psp", "married_not_with_partner_no_live", 
                                            "married_not_with_partner_live", "married_not_no_partner", 
                                            "separated","divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college",
                                            "degree_nocollege","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", 
                                            "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number", "region_reside_northeast", "region_reside_west", "region_reside_south")

default_disabilities_long_names_nonreference               <-  c("Demeaned age", "Squared demeaned age", "Male", "Number of adults in household",
                                                    "Number of children",  "Sum of disabilities across children",
                                                    "Demeaned log(income/sqrt(hhsize))", "Not married but a partner outside the house", 
                                                    "Not married but a partner in the house", "Not married and no partner", "Separated", "Ever divorced", "Widowed", "Other relationship status", "Graduate Degree", "Attended some college", "No college", "Other non-white", "Asian", "Black/African American","Hispanic/Latino/Spanish", "Employed part-time", "Unemployed", "Out of labor force/other", "Religious attendance (0 to 5, 'Never' to 'More than once a week')", "Residing in the Northeast", "Residing in the West", "Residing in the South" )

default_disabilities_characterstics_list <- c(default_disabilities_reference_characteristics,default_disabilities_nonreference_characteristics)
default_disabilities_characterstics_actuallist <- list("married", "degree_bachelor","ethn_white","employ_full_time","region_reside_midwest", "age_demean",
                                          "age_demean_2", "male","hhadults",  "children_total", "number_of_children_disabilities", "dem_log_income_psp",
                                          "married_not_with_partner_no_live", "married_not_with_partner_live", "married_not_no_partner", "separated","divorced","widowed",
                                          "other_relationship",  "degree_graduate", "degree_some_college", "degree_nocollege","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number", "region_reside_northeast", "region_reside_west", "region_reside_south")
default_disabilities_long_names_characteristics            <- c(default_disabilities_long_names_reference,default_disabilities_long_names_nonreference)




## Core plus difficult situations

# default_core_difficult_reference <- c(default_reference_characteristics)  
# default_core_difficult_nonreference <- c(default_nonreference_characteristics, "difficultSum_Z_score")  
# default_core_difficult <- c(default_core_difficult_reference,default_core_difficult_nonreference)  
# default_long_names_core_difficult_nonreference <- c(default_long_names_nonreference, "Difficult Situations Z-score")
# default_long_names_core_difficult_reference <- c(default_long_names_reference)
# default_long_names_core_difficult <- c(default_long_names_core_difficult_reference,default_long_names_core_difficult_nonreference)




## difficult situations

#default_core_difficult_reference <- c(default_reference_characteristics)  
difficult_nonreference <- c( "difficultSum")  
difficult <- difficult_nonreference
long_names_difficult_nonreference <- c("Number of Difficult Situations")
long_names_difficult <- long_names_difficult_nonreference









# This is a modified version of core set to have more typical definitions of racial demographics.
# default_jiannan_reference_characteristics <-  c("married", "degree_bachelor","white_only","employ_full_time","region_reside_midwest")
# default_jiannan_long_names_reference <- c("Married", "Bachelor Degree", "White/Caucasian only", "Employed full-time", "Residing in the Midwest")
# 
# default_jiannan_nonreference_characteristics <-  c("age_demean", "age_demean_2", "male", "hhadults", "hhchildren", 
#                                            "hh_not_hh_children", "dem_log_income_psp", "married_not_with_partner_no_live", 
#                                            "married_not_with_partner_live", "married_not_no_partner", 
#                                            "separated","divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college",
#                                            "degree_nocollege","other_only", "asian_only", "black_only", "hispanic_only", "multi_race",
#                                            "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number", "region_reside_northeast", "region_reside_west", "region_reside_south")
# 
# default_jiannan_long_names_nonreference               <-  c("Demeaned age", "Squared demeaned age", "Male", "Number of adults in household",
#                                                     "Number of children in household", "Number of children not in household",
#                                                     "Demeaned log(income/sqrt(hhsize))", "Not married but a partner outside the house", 
#                                                     "Not married but a partner in the house", "Not married and no partner", "Separated", "Divorced",
#                                                     "Widowed", "Other relationship status", "Graduate Degree", "Attended some college",
#                                                     "No college", "Other race only", "Asian only", "Black/African American only","Hispanic/Latino/Spanish only",
#                                                     "Multiple races",
#                                                     "Part-time employed", "Unemployed", "Out of labor force/other", "Religious attendance (0 to 5, 'Never' to 'More than once a week')", "Residing in the Northeast", "Residing in the West", "Residing in the South" )
# 
# default_jiannan_long_names_characteristics            <- c(default_jiannan_long_names_reference,default_jiannan_long_names_nonreference)
# 
# 
# 
# 
# ### A specific regression requested by Kristen.
# default_nonreference_KristenAug2 <- c("age_demean", "age_demean_2", "log_income", "hhchildren_none", "male")
# 
# default_long_names_nonreference_KristenAug2                <-  c("Demeaned age", "Squared demeaned age","Log income", "No children", "Male")
# 
# 
# 
# 
# 
# 
# 
# 
# # Drop these from 
# default_others <- c( "other_relationship", "ethn_other", "employ_OOLF_other")
# default_long_others <- c("Other relationship status", "Other race","Out of labor force/other" )
# # This is a literature set - which wasn't defined in the preregistration.
# default_reference_characteristics_literature <-  c("married", "degree_bachelor","ethn_white","employ_full_time")
# default_long_names_reference_literature <- c("Married", "Bachelor Degree", "White/Caucasian", "Employed full-time")
# default_nonreference_characteristics_literature <-  c("age_demean", "age_demean_2","male","humorSum_Z_score", "gritSum_Z_score", "hhadults", "hhchildren", "hh_not_hh_children", "dem_log_income_psp", 
#                                                       "married_not_with_partner_no_live", "married_not_with_partner_live","married_not_no_partner","separated" ,"divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college", "degree_nocollege",
#                                                       "ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number")
# default_long_names_nonreference_literature               <-  c("Demeaned age", "Squared demeaned age", "Male", "Coping humor scale (Z-score)", 
#                                                                "Grit scale (Z-score)", "Number of adults in household", "Number of children in household",
#                                                                "Number of children not in household", "Demeaned log(income/sqrt(hhsize))", 
#                                                                "Not married but a partner outside the house", "Not married but a partner in the house", "Not married, no partner",
#                                                                "Separated", "Divorced", "Widowed", "Other relationship status", "Graduate Degree", "Attended some college", 
#                                                                "No college", "Other race", "Asian", "Black/African American","Hispanic/Latino/Spanish", "Part-time employed", "Unemployed", "Out of labor force/other", "Religious attendance (0 to 5, 'Never' to 'More than once a week')")
# default_characterstics_list_literature <- c(default_reference_characteristics_literature,default_nonreference_characteristics_literature)
# default_characterstics_actuallist_literature <- list("married", "degree_bachelor","ethn_white","employ_full_time","age_demean", "age_demean_2","male","humorSum_Z_score", "gritSum_Z_score", "hhadults", "hhchildren", "hh_not_hh_children", "dem_log_income_psp", 
#                                                      "married_not_with_partner_no_live", "married_not_with_partner_live", "married_not_no_partner", "separated","divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college", "degree_nocollege",
#                                                      "ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number"
# 
#                                                      )
# default_long_names_characteristics_literature            <- c(default_long_names_reference_literature,default_long_names_nonreference_literature)








default_extension_set_1_nonreference <- c("humorSum_Z_score","gritSum_Z_score",
                                          "strangersSum_Z_score","cost_difficultySum_Z_score",
                                          "democratic_republic", "social_views_number", "economic_views_number", 
                                          "religiousImportance_number","effort","enjoyability", "numbers_words" ,
                                          "possible", "grade_self","understanding", "trade", "immigration", "thermometer", 
                                          "election_stolen", "commute_pleasant")
default_extension_set_1 <- c(default_extension_set_1_nonreference)
default_long_names_extension_set_1_nonreference   <- c("Coping humor scale (Z-score)", "Grit scale (Z-score)", "Talking to strangers scale (Z-score)", "Cost difficulty scale (Z-score)", 
                                                       "Political party (-2 to 2, Democrat to Republican)", "Social views (-3 to 3, Very liberal to Very conservative)", "Economic views (-3 to 3, Very liberal to Very conservative)",
                                                       "Religious importance (0 to 3, Not Important to Very Important", "Effort on survey (0-100)", "Enjoyability of survey (0-100)", 
                                                       "Did you pay more attention to numbers or words? (-1 to 1 in 2/3 increments, All Numbers to All Words)",
                                                       "Interpretation of 'possible' (0-4, 'possible for you at this time' to 'possible for someone, someday)",
                                                       "How easily you grade yourself (1-5, Much tougher than to Much easier than) ", "How well you understood the survey (0-100)",
                                                       "Support for trade restrictions (-1 to 1, Fewer Restrictions to More Restrictions)", "Opposition to immigration (-1 to 1, Good to Bad)",
                                                       "Feelings about Trump (0-100, cold to warm)", "Belief that election was stolen (0-3, Biden definitely won to Trump definitely won",
                                                       "How pleasant commute is (1-7, Horrible to Wonderful)")
default_long_name_extension_set_1 <- c(default_long_names_extension_set_1_nonreference)

default_extension_set_2_nonreference <- c("people_per_sq_mile", "log_height_numeric_meter", "log_BMI",
                                          "hh_member_disability_or_serious_problem", "usborn", "moved")
default_extension_set_2 <- c(default_extension_set_2_nonreference)

default_long_names_extension_set_2_nonreference   <- c("People per square mile in zip code", "log(Height in meters)", "log(BMI)",
                                                       "At least 1 person has a mental or physical disability or other serious problem (indicator)",
                                                       "Born in US (indicator)", "Moved since they were born (indicator)")
default_long_name_extension_set_2 <- c(default_long_names_extension_set_2_nonreference)

  
  
  
  
  
  
  ### Not complete.
  
 # default_reference_characteristics_3 <-  c()
 # default_long_names_reference_3 <- c()
 # default_nonreference_characteristics_3 <-  c( "percent_gifts", "percent_bills",
#                                                "percent_charity", "help_others_hours",
#                                                "sleep_hours",
 #                                               "commute_minutes_weekly")
#  default_long_names_nonreference_3              <-  c("Percent of HH income spent on gifts (for self or others)",
 #                                                      "Percent of HH income spent on bills",
 #                                                      "Percent of HH income spent on bills",
  #                                                     "Hours per year you spend doing things for others",
   #                                                    "Hours slept per night (weighted average of weekend and weekday hours)",
    #                                                   "Commute minutes (weekly)"
     #                                                  )
  #default_characterstics_list_3 <- c(default_reference_characteristics_literature,default_nonreference_characteristics_literature)
#  default_characterstics_actuallist_3 <- list("married", "degree_bachelor","ethn_white","employ_full_time","age_demean", "age_demean_2","male","humorSum_Z_score", "gritSum_Z_score", "hhadults", "hhchildren", "hh_not_hh_children", "dem_log_income_psp", 
 #                                                      "married_not_with_partner_no_live", "married_not_with_partner_live", "married_not_no_partner", "separated","divorced","widowed","other_relationship",  "degree_graduate", "degree_some_college", "degree_nocollege",
  #                                                     "ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "employ_part","employ_not_employed", "employ_OOLF_other", "religiousAttendance_number"
   #                                                    
  #)
#  default_long_names_characteristics_3            <- c(default_long_names_reference_literature,default_long_names_nonreference_literature)
  
  
UAS_aspects <- c("happiness", "enjoyment", "satisfaction", "no_sadness", "worthwhileness", "family_happiness", "good_person", "financial_support", "time", "not_lonely", "no_anxiety", "mental_health", "physical_health", "ladder", "sense_of_control", "sense_of_purpose", "no_anger", "no_stress", "no_worry", "wb_you_family", "possibilities", "having_people", "safety")  
  
#default_life_psych_reference <- c(default_reference_characteristics_literature)  
#default_life_psych_nonreference <- c(default_nonreference_characteristics_literature, "NPISum_Z_score", 
#                                     "PerfectionismSum_Z_score",
#                                     big_five_z_score, 
#                                     "MaximizationSum_Z_score",
#                                     "difficultSum_Z_score",
#                                     "WealthSum_Z_score",
#                                     "DesireControlSum_Z_score",
#                                     "GSOEPSum_Z_score"
#                                     
#                                     )  
# default_life_psych <- c(default_life_psych_reference,default_life_psych_nonreference)  
# default_long_names_life_psych_nonreference <- c(default_long_names_nonreference_literature, 
#                                                 "Narcissistic Z score", 
#                                                 "Perfectionism Z Score",
#                                                 big_five_z_score, 
#                                                 "Maximizing Z-score", 
#                                                 "Difficult Situations Z-score",
#                                                 "Wealth Index Z-score",
#                                                 "Desire for Control Z-score",
#                                                 "Locus of Control Z-score"
#                                                 )
# default_long_names_life_psych_reference <- c(default_long_names_reference_literature)
# default_long_names_lifepsych <- c(default_long_names_life_psych_reference,default_long_names_life_psych_nonreference)




# default_life_psych_no_controls_nonreference <- c( "NPISum_Z_score", "PerfectionismSum_Z_score",big_five_z_score, "MaximizationSum_Z_score", "difficultSum_Z_score", "WealthSum_Z_score")  
# default_life_psych_no_controls <- c(default_life_psych_no_controls_nonreference)  
# default_long_names_life_psych_no_controls_nonreference <- c("Narcissistic Z score", "Perfectionism Z Score",big_five_z_score, "Maximizing Z-score", "Difficult Situations Z-score", "Wealth Index Z-score")
# 
# default_long_names_lifepsych <- c(default_long_names_life_psych_no_controls_reference,default_long_names_life_psych_no_controls_nonreference)


dominics_old_default_characterstics_actuallist             <- list("age_demean", "age_demean_2", "male", "dem_log_income_psp","married", "married_not_no_partner", "married_not_with_partner", "degree_graduate", "degree_bachelor", "degree_some_college", "degree_highschool","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish",  "employ_not_employed", "employ_out_of_labor_force", "employ_full_time", "employ_part", "employ_other", "region_reside_midwest", "region_reside_northeast", "region_reside_west", "region_reside_south","religiousAttendance_number",  "hhsize_2more","hhsize_1more",	"hhsize_3more", "hhsize_5more",	"hhsize_10more", "hhchildren_1more", "hhchildren_5more")
dominics_old_default_characterstics_list_baseline2         <- c("age_demean2", "age_demean_22", "male2", "dem_log_income_psp2", "married2", "married_not_no_partner2", "married_not_with_partner2", "degree_graduate2", "degree_bachelor2", "degree_some_college2", "degree_highschool2","ethn_other2", "ethn_asian2", "ethn_black_african_american2", "ethn_hispanic_latino_spanish2", "employ_not_employed2", "employ_out_of_labor_force2","employ_full_time2", "employ_part2", "employ_other2","region_reside_midwest2", "region_reside_northeast2", "region_reside_west2", "region_reside_south2", "religiousAttendance_number2", "hhsize_2more2", "hhsize_1more2",	"hhsize_3more2", "hhsize_5more2",	"hhsize_10more2", "hhchildren_1more2", "hhchildren_5more2")
default_characterstics_actuallist_baseline2   <- list("age_demean2", "age_demean_22", "male2", "dem_log_income_psp2", "married2", "married_not_no_partner2", "married_not_with_partner2", "degree_graduate2", "degree_bachelor2", "degree_some_college2", "degree_highschool2","ethn_other2", "ethn_asian2", "ethn_black_african_american2", "ethn_hispanic_latino_spanish2", "employ_not_employed2", "employ_out_of_labor_force2","employ_full_time2", "employ_part2", "employ_other2","region_reside_midwest2", "region_reside_northeast2", "region_reside_west2", "region_reside_south2", "religiousAttendance_number2", "hhsize_2more2", "hhsize_1more2",	"hhsize_3more2", "hhsize_5more2",	"hhsize_10more2", "hhchildren_1more2", "hhchildren_5more2")
#dominics_old_ 
### Define default vectors for demographics ###                
dominics_old_default_characterstics_list                   <- c("age_demean", "age_demean_2", "male", "dem_log_income_psp","married", "married_not_no_partner", "married_not_with_partner", "degree_graduate", "degree_bachelor", "degree_some_college", "degree_highschool","ethn_other", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish",  "employ_not_employed", "employ_out_of_labor_force", "employ_full_time", "employ_part", "employ_other", "region_reside_midwest", "region_reside_northeast", "region_reside_west", "region_reside_south","religiousAttendance_number",  "hhsize_2more","hhsize_1more",	"hhsize_3more", "hhsize_5more",	"hhsize_10more", "hhchildren_1more", "hhchildren_5more")

dominics_old_default_reference_characteristics             <- c("married", "degree_bachelor","ethn_other","employ_full_time","region_reside_midwest","hhsize_1more")
dominics_old_default_nonreference_characteristics          <- c("age_demean", "age_demean_2", "male", "dem_log_income_psp", "married_not_no_partner", "married_not_with_partner", "degree_graduate", "degree_some_college", "degree_highschool","ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish",  "employ_not_employed", "employ_out_of_labor_force", "employ_part", "employ_other","region_reside_northeast", "region_reside_west", "region_reside_south","religiousAttendance_number",  "hhsize_2more","hhsize_3more", "hhsize_5more",	"hhsize_10more", "hhchildren_1more", "hhchildren_5more")
dominics_old_default_nonreference_characteristics2         <- c("age_demean2", "age_demean_22", "male2", "dem_log_income_psp2", "married_not_no_partner2", "married_not_with_partner2", "degree_graduate2", "degree_some_college2", "degree_highschool2","ethn_asian2", "ethn_black_african_american2", "ethn_hispanic_latino_spanish2",  "employ_not_employed2", "employ_out_of_labor_force2", "employ_part2", "employ_other2","region_reside_northeast2", "region_reside_west2", "region_reside_south2","religiousAttendance_number2",  "hhsize_2more2","hhsize_3more2", "hhsize_5more2",	"hhsize_10more2", "hhchildren_1more2", "hhchildren_5more2")




dans_characteristics_list                     <- c("age_demean", "age_demean_2", "male", "dem_log_income_psp","religiousAttendance_number","employ_not_employed","married_not_no_partner","ethn_asian", "hhchildren_1exactly", "hhchildren_2more", "ethn_hispanic_latino_spanish", "ethn_black_african_american", "married_not_with_partner","region_reside_west","region_reside_northeast", "region_reside_south", "degree_graduate", "degree_some_college", "degree_highschool")
dans_characteristics_longnames_list           <- c("Demeaned age","Squared demeaned Age", "Being male", "Demeaned log(income/sqrt(hhsize))", "Religious attendance (0 to 5, 'Never' to 'More than once a week')","Unemployed", "Not married and no partner",  "Asian", "Living with 1 child", "Living with 2 or more children","Hispanic/Lationo/Spanish","Black/African American", "Not married but a partner","Residing in the West","Residing in the Northeast", "Residing in the South",    "Graduate Degree", "Attended some college", "Highschool")
dans_characteristics_actuallist               <- list("age_demean", "age_demean_2", "male", "dem_log_income_psp","religiousAttendance_number","employ_not_employed","married_not_no_partner","ethn_asian", "hhchildren_1exactly", "hhchildren_2more", "ethn_hispanic_latino_spanish", "ethn_black_african_american", "married_not_with_partner", "region_reside_west","region_reside_northeast", "region_reside_south", "degree_graduate", "degree_some_college", "degree_highschool")
dans_characteristics_reported_longnames       <- c("Demeaned age","Squared demeaned Age", "Being male", "Demeaned log(income/sqrt(hhsize))",  "Religious attendance (0 to 5, 'Never' to 'More than once a week')", "Unemployed", "Not married and no partner",  "Asian", "Living with 1 child", "Living with 2 or more children")
dans_characteristics_reported_shortnames      <- c("age_demean", "age_demean_2", "male", "dem_log_income_psp","religiousAttendance_number","employ_not_employed","married_not_no_partner","ethn_asian", "hhchildren_1exactly", "hhchildren_2more")

literature_characteristics_shortnames         <- c("age_demean", "age_demean_2","income_equalabove_median", "male", "ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish", "education_equalabove_median")
literature_characteristics_longnames          <- c("Demeaned age", "Squared demeaned Age","Having income equal or above median income in the sample", "Being male", "Asian", "Black/African American", "Hispanic/Latino/Spanish", "Education equal or above the median education")

literature_2_characteristics_shortnames       <- c("min_ageminus45_0", "max_ageminus45_0", "male", "log_income_above_mean", "married_not_no_partner", "married_not_with_partner", "degree_graduate", "degree_some_college", "degree_highschool","ethn_asian", "ethn_black_african_american", "ethn_hispanic_latino_spanish",  "employ_not_employed", "employ_out_of_labor_force", "employ_part", "employ_other","region_reside_northeast", "region_reside_west", "region_reside_south","religiousAttendance_number",  "hhsize_2more","hhsize_3more", "hhsize_5more",	"hhsize_10more", "hhchildren_1more", "hhchildren_5more")
literature_2_characteristics_longnames        <- c("Min(Age-45,0)","Max(Age-45,0)", "Being male", "Demeaned log(income)", "Not married and no partner", "Not married but a partner", "Graduate Degree", "Attended some college", "Highschool",  "Asian", "Black/African American","Hispanic/Lationo/Spanish","Unemployed","Out of Labor Force","Part-time employed", "Other employment","Residing in the Northeast", "Residing in the West", "Residing in the South", "Religious attendance (0 to 5, 'Never' to 'More than once a week')",  "Living in a 2-person household","Living in a 3 or 4-person household","Living in a 5 to 9 person household","Living in a 10 or more-person household", "Living with 1 to 4 children", "Living with 5 or more children"  )

### Define default vectors for calibration questions ###   
default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
default_calibration_list_personal             <- c("calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
default_calibration_list_impersonal           <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3")
default_calibration_list_pilot                <- c("calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_info_1", "calibration_info_2", "calibration_info_3")
default_calibration_list_100                  <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_black_1", "calibration_black_2", "calibration_black_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
default_calibration_list_lowmedium            <- c("calibration_curve_1", "calibration_curve_2", "calibration_blue_1", "calibration_blue_2", "calibration_region_1", "calibration_region_2",  "calibration_crime_1", "calibration_crime_2","calibration_info_1", "calibration_info_2", "calibration_remember_1", "calibration_remember_2")
default_calibration_list_lowmedium_personal   <- c("calibration_crime_1", "calibration_crime_2","calibration_info_1", "calibration_info_2", "calibration_remember_1", "calibration_remember_2")
default_calibration_list_lowmedium_impersonal <- c("calibration_curve_1", "calibration_curve_2", "calibration_blue_1", "calibration_blue_2", "calibration_region_1", "calibration_region_2")
default_calibration_actuallist                <- list("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
default_calibration_actuallist_personal       <- list("calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
default_calibration_actuallist_impersonal     <- list("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3")
default_calibration_list_baseline2            <- c("calibration_curve_12", "calibration_curve_22", "calibration_curve_32", "calibration_blue_12", "calibration_blue_22", "calibration_blue_32", "calibration_region_12", "calibration_region_22", "calibration_region_32", "calibration_crime_12", "calibration_crime_22", "calibration_crime_32", "calibration_info_12", "calibration_info_22", "calibration_info_32", "calibration_remember_12", "calibration_remember_22", "calibration_remember_32")
default_calibration_list_baseline2_personal   <- c("calibration_crime_12", "calibration_crime_22", "calibration_crime_32", "calibration_info_12", "calibration_info_22", "calibration_info_32", "calibration_remember_12", "calibration_remember_22", "calibration_remember_32")
default_calibration_list_baseline2_impersonal <- c("calibration_curve_12", "calibration_curve_22", "calibration_curve_32", "calibration_blue_12", "calibration_blue_22", "calibration_blue_32", "calibration_region_12", "calibration_region_22", "calibration_region_32")
default_calibration_actuallist_baseline2      <- list("calibration_curve_12", "calibration_curve_22", "calibration_curve_32", "calibration_blue_12", "calibration_blue_22", "calibration_blue_32", "calibration_region_12", "calibration_region_22", "calibration_region_32", "calibration_crime_12", "calibration_crime_22", "calibration_crime_32", "calibration_info_12", "calibration_info_22", "calibration_info_32", "calibration_remember_12", "calibration_remember_22", "calibration_remember_32")
default_calibration_actuallist_baseline2_personal   <- list("calibration_crime_12", "calibration_crime_22", "calibration_crime_32", "calibration_info_12", "calibration_info_22", "calibration_info_32", "calibration_remember_12", "calibration_remember_22", "calibration_remember_32")
default_calibration_actuallist_baseline2_impersonal <- list("calibration_curve_12", "calibration_curve_22", "calibration_curve_32", "calibration_blue_12", "calibration_blue_22", "calibration_blue_32", "calibration_region_12", "calibration_region_22", "calibration_region_32")
default_calibration_actuallist_lowmedium      <- list("calibration_curve_1", "calibration_curve_2", "calibration_blue_1", "calibration_blue_2", "calibration_region_1", "calibration_region_2",  "calibration_crime_1", "calibration_crime_2","calibration_info_1", "calibration_info_2", "calibration_remember_1", "calibration_remember_2")
default_calibration_actuallist_lowmedium_personal   <- list("calibration_crime_1", "calibration_crime_2","calibration_info_1", "calibration_info_2", "calibration_remember_1", "calibration_remember_2")
default_calibration_actuallist_lowmedium_impersonal <- list("calibration_curve_1", "calibration_curve_2", "calibration_blue_1", "calibration_blue_2", "calibration_region_1", "calibration_region_2")
default_calibration_names_list                <- c("How curved is this line (least curved)", "How curved is this line (medium curved)", "How curved is this line (most curved)", "How dark is this circle (least dark)", "How dark is this circle (medium dark)", "How dark is this circle (most dark)", "How big is this region compared to others (small)", "How big is this region compared to others (medium)", "How big is this region compared to others (big)", "Environment spoiled by crime and violence (least spoiled)", "Environment spoiled by crime and violence (medium spoiled)", "Environment spoiled by crime and violence (most spoiled)", "Access to information (least information)", "Access to information (medium information)", "Access to information (most information)", "Ability to remember things (least memory)", "Ability to remember things (medium memory)", "Ability to remember things (high memory)")
default_calibration_names_list_personal       <- c("Environment spoiled by crime and violence (least spoiled)", "Environment spoiled by crime and violence (medium spoiled)", "Environment spoiled by crime and violence (most spoiled)", "Access to information (least information)", "Access to information (medium information)", "Access to information (most information)", "Ability to remember things (least memory)", "Ability to remember things (medium memory)", "Ability to remember things (high memory)")
default_calibration_names_list_impersonal     <- c("How curved is this line (least curved)", "How curved is this line (medium curved)", "How curved is this line (most curved)", "How dark is this circle (least dark)", "How dark is this circle (medium dark)", "How dark is this circle (most dark)", "How big is this region compared to others (small)", "How big is this region compared to others (medium)", "How big is this region compared to others (big)")

jiannan_calibration_list                      <- c("calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")


### Default for various other things ###
jiannan_completion_check                      <- c("dem_log_income_psp","ethn_black_african_american","hhchildren_1more","married_not_no_partner","age_demean_2","hh_not_hh_children", "hhchildren","hhsize","hhadults","hhincome","log_income_per_sqrt_person","age","age_demean","male","married","married_not_with_partner","degree_bachelor","degree_graduate","degree_some_college","degree_highschool","ethn_other","ethn_asian","ethn_hispanic_latino_spanish","ethn_other","employ_full_time","employ_not_employed","employ_part","employ_out_of_labor_force","employ_other","region_reside_west","region_reside_northeast","region_reside_south","region_reside_midwest","statesize_reside_big","statesize_reside_small","height_numeric_meter","weightKG","BMI","BMI_deviation_from_optimal","BMI_squareddeviation_from_optimal","religiousAttendance_number","hhsize_2more","hhsize_3more","hhsize_5more","hhsize_10more","hhchildren_5more","hhchildren_1exactly","hhchildren_2more")
default_numbercalibrationquestions_in_triplet <- 3
default_numbercalibrationquestions_triplets <- 6
default_ALL_calibration_cleaning_list <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")



if(dataset=="BottomlessA_all" | dataset=="bottomlessA"){
  default_data <- paste0(default_input,"500_WideCleanedBottomlessMeanDups.csv")
  default_data_bottomless_long_uncleaned <-  paste0(default_input,"500_LongCleanedBottomless.csv")
    
  default_long_CQ_data<- paste0(default_input,"500_CQ_Long_CleanedBottomless.csv")
  default_long_aspect_data <- paste0(default_input,"500_Aspect_Long_CleanedBottomless.csv")
  default_long_aspect_data_renamed <- paste0(default_input,"500_NamesAdjusted_Aspect_Long_CleanedBottomless.csv")
  default_long_aspect_data_renamed_meandups <- paste0(default_input,"500_NamesAdjusted_Aspect_Long_CleanedBottomlessMeanDups.csv")
  
  # Various cuts.
  default_self_data_bottomless <- paste0(default_input,"500_SelfWideCleanedBottomlessMeanDups.csv")
  default_self_CQ_data_bottomless <- paste0(default_input,"500_CQ_SelfWideCleanedBottomless.csv")
  
  default_nonself_data_bottomless <- paste0(default_input,"500_NonSelfWideCleanedBottomlessMeanDups.csv")
  default_nonself_CQ_data_bottomless <- paste0(default_input,"500_CQ_NonSelfWideCleanedBottomless.csv")
  
  default_male_data_bottomless <- paste0(default_input,"500_MaleWideCleanedBottomlessMeanDups.csv")
  default_male_CQ_data_bottomless <- paste0(default_input,"500_CQ_MalefWideCleanedBottomless.csv")
  
  default_female_data_bottomless <- paste0(default_input,"500_FemaleWideCleanedBottomlessMeanDups.csv")
  default_female_CQ_data_bottomless <- paste0(default_input,"500_CQ_FemaleWideCleanedBottomless.csv")
  
  default_output <- paste0(default_output,dataset,"/")
  default_data_bottomless_CQ <- paste0(default_input,"500_CQ_WideCleanedBottomless.csv")
  default_data_bottomless_CQ_age <- paste0(default_input,"500_WideAgesCleanedBottomless.csv")
  default_data_bottomless_aspect <- paste0(default_input,"500_Aspect_WideCleanedBottomless.csv")
  default_dictionary_bottomless_CQ <- paste0(default_input,"500_CQ_Dictionary_Bottomless.csv")
  default_dictionary_bottomless_aspect <- paste0(default_input,"500_Aspect_Dictionary_Bottomless.csv")
  default_dictionary_ScaleFrames <- paste0(base_wd,"/Dropbox/whatisagoodlife/Data/cleandata/500_ScaleFrames_Dictionary_Bottomless.csv")
  title_name <- "BottomlessA_invitees from baseline 500"
  default_data_bottomlessA_all2 <- paste0(default_input,"500_WideCleanedBottomlessMeanDups2.csv")
  # default_output <- paste0(default_output,dataset,"/")
} else if(dataset=="bottomlessA2"){
  default_data_bottomless <- paste0(default_input,"500_WideCleanedBottomlessMeanDups2.csv")
  default_data_bottomless_long_uncleaned <-  paste0(default_input,"500_LongCleanedBottomless2.csv")
  
  default_long_CQ_data<- paste0(default_input,"500_CQ_Long_CleanedBottomless2.csv")
  default_long_aspect_data <- paste0(default_input,"500_Aspect_Long_CleanedBottomless2.csv")
  default_long_aspect_data_renamed <- paste0(default_input,"500_NamesAdjusted_Aspect_Long_CleanedBottomless2.csv")
  default_long_aspect_data_renamed_meandups <- paste0(default_input,"500_NamesAdjusted_Aspect_Long_CleanedBottomlessMeanDups2.csv")
  
  title_name <- "BottomlessA2: invitees from baseline 500"
  
  # Various cuts.
  default_self_data_bottomless <- paste0(default_input,"500_SelfWideCleanedBottomlessMeanDups2.csv")
  default_self_CQ_data_bottomless <- paste0(default_input,"500_CQ_SelfWideCleanedBottomless2.csv")
  
  default_nonself_data_bottomless <- paste0(default_input,"500_NonSelfWideCleanedBottomlessMeanDups2.csv")
  default_nonself_CQ_data_bottomless <- paste0(default_input,"500_CQ_NonSelfWideCleanedBottomless2.csv")
  
  
  default_male_data_bottomless <- paste0(default_input,"500_MaleWideCleanedBottomlessMeanDups2.csv")
  default_male_CQ_data_bottomless <- paste0(default_input,"500_CQ_MalefWideCleanedBottomless2.csv")
  
  default_female_data_bottomless <- paste0(default_input,"500_FemaleWideCleanedBottomlessMeanDups2.csv")
  default_female_CQ_data_bottomless <- paste0(default_input,"500_CQ_FemaleWideCleanedBottomless2.csv")
  
  default_summary <- paste0(base_wd,"/Dropbox/cleandata/597_summary_of_workers2.csv")
  default_output <- paste0(default_output,dataset,"/")
  
  
} else if(dataset=="LifePsychBaseline"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- paste0(default_input,"LifePsych_baseline.csv")
  title_name <- "Population: People who took LifePsych and baseline 4000"
  superset_titlename <- "Population: 2022 sample, passed quality control"
  default_superset <- default_data_baseline_4000_passed_QC # waiting on Miles
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset=="baseline_4000"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- default_data_baseline_4000
  default_superset <- default_data_baseline_4000_passed_QC
  default_data_choices <- default_choices_baseline_4000
  default_summary <- paste0(base_wd,"/Dropbox/cleandata/baseline4000_batch_2flag_summary.csv")
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset=="baseline_4000_passed_QC"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  data_for_ages                  <- read_labelled_csv(default_data_baseline_4000)
  mean_age_entire_4000 = mean(data_for_ages$age,na.rm=TRUE)
  mean_logincomepsp_entire_4000 = mean(data_for_ages$log_income_per_sqrt_person,na.rm=TRUE)
  default_data <- default_data_baseline_4000_passed_QC
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC
  superset_titlename<- "Population: passed quality control"
  title_name <- "Population: passed QC"
}else if(dataset=="baseline_4000_passed_QC_post_cookie"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- default_data_baseline_4000_passed_QC_post_cookie
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC_post_cookie
  superset_titlename<- "Population: passed quality control, post cookie"
  title_name <- "Population: passed QC, post cookie"
}else if(dataset=="baseline_4000_passed_QC_post_cookie_high_beta"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- default_data_baseline_4000_passed_QC_post_cookie_high_beta
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC_post_cookie_high_beta
  superset_titlename<- "Population: 2022 sample, passed quality control, post cookie, beta-hat > 0.5"
  title_name <- "Population: 2022 sample, passed QC, post cookie, beta-hat > 0.5"
}else if(dataset=="baseline_4000_passed_QC_post_cookie_low_beta"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- default_data_baseline_4000_passed_QC_post_cookie_low_beta
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC_post_cookie_low_beta
  superset_titlename<- "Population: 2022 sample, passed QC, post cookie, beta-hat <= 0.5\n"
  title_name <- "Population: 2022 sample, passed QC, post cookie, beta-hat <= 0.5\n"
}else if(dataset=="baseline_4000_passed_QC_pre_cookie"){
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_data <- default_data_baseline_4000_passed_QC_pre_cookie
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC_pre_cookie
  superset_titlename<- "Population: passed quality control, pre cookie"
  title_name <- "Population: passed QC, pre cookie"
}else if(dataset=="baseline_4000_failed_QC"){
  default_data <- default_data_baseline_4000_failed_QC
  default_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_passed_QC
  superset_titlename <- "Population: Pooled, 2020 and 2022 samples, passed quality control"
  title_name <- "Population: failed quality control"
}else if(dataset == "baseline_500" ) {
  default_data <- default_data_baseline
# } else if(dataset == "baseline_4000_500" ) {
#   title_name <- "Population: Pooled, baselines 500 + 4000"
#   default_data <- default_data_baseline_4000_500
#   default_superset <- default_data_baseline_4000_500_passed_QC
#   superset_titlename <- "Population: Pooled, 2020 and 2022 samples"
#   default_long_aspect_data <- paste0(default_input, "long_clean/baseline_4000_500_Aspect_Long_CleanedBottomless.csv")
#   default_long_CQ_data <- paste0(default_input, "long_clean/baseline_4000_500_CQ_Long_CleanedBottomless.csv")
#   default_choice_data <- paste0(default_input, "long_clean/baseline_4000_500_Choices.csv")
#   default_choice_data_passedQC <- paste0(default_input, "long_clean/baseline_4000_500_Choices_passedQC.csv")
#   default_choice_data_failedQC <- paste0(default_input, "long_clean/baseline_4000_500_Choices_failedQC.csv")
#   default_output <- paste0(default_output,dataset,"/")
# } else if(dataset == "baseline_4000_500_passed_QC" ) {
#   title_name <- "Population: Pooled, 2020 and 2022 samples, passed quality control"
#   default_data <- default_data_baseline_4000_500_passed_QC
#   default_superset <- default_data_baseline_4000_500_passed_QC
#   superset_titlename <-  "Population: Pooled, 2020 and 2022 samples, passed quality control"
#   default_output <- paste0(default_output,dataset,"/")
# } else if(dataset == "baseline_4000_500_failed_QC" ) {
#   title_name <- "Population: Pooled, 2020 and 2022 samples, failed quality control"
#   default_superset <- default_data_baseline_4000_500_passed_QC
#   default_data <- default_data_baseline_4000_500_failed_QC
#   superset_titlename <-  "Population: Pooled, 2020 and 2022 samples, passed quality control"
#   default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "baseline_500_passed_QC" ) { 
  default_data <- default_data_baseline_invite
  default_superset <- default_data_baseline_invite
  title_name <- "Baseline 500 only, passed QC"
  superset_titlename <- "Population: baseline 500 only, passed QC"
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "baseline_500_failed_QC" ) { 
  default_data <- default_data_baseline_noninvite
  default_superset <- default_data_baseline_invite
  superset_titlename <- "Population: baseline 500 only, failed QC"
  title_name <- "Baseline 500 only, passed QC"
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "baseline_participate" ) { 
  default_data <- default_data_baseline_participate # Not ready yet to use.
  
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "invite_InformativeBoth" ) { 
  default_data <- default_data_baseline_invite_InformativeBoth
  
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "invite_InformativeCQ" ) { 
  default_data <- default_data_baseline_invite_InformativeCQ
  
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "invite_InformativeAspect" ) { 
  default_data <- default_data_baseline_invite_InformativeAspect
  
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "invite_InformativeNone" ) { 
  default_data <- default_data_baseline_invite_InformativeNone
  
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "Bottomless_averaged_baseline_4000_500" ) { 
  default_data <- paste0(default_input, "Bottomless_averaged_", "baseline_4000_500.csv" )
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_500
  title_name <- "Population: Pooled baselines 500 + 4000, averaged with bottomlessA block 1"
}  else if(dataset == "Bottomless_averaged_baseline_4000_500_passed_QC" ) { 
  default_data <- paste0(default_input, "Bottomless_averaged_", "baseline_4000_500_passed_QC.csv" )
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_500
  
  title_name <- "Population: Pooled baselines 500 + 4000, passed QC, averaged with bottomlessA block 1"
  
}  else if(dataset == "Bottomless_averaged_baseline_4000_500_failed_QC" ) { 
  default_data <- paste0(default_input, "Bottomless_averaged_", "baseline_4000_500_failed_QC.csv" )
  default_output <- paste0(default_output,dataset,"/")
  default_superset <- default_data_baseline_4000_500
  title_name <- "Population: Pooled baselines 500 + 4000, failed QC, averaged with bottomlessA block 1"
  
}  else if(dataset == "Paper Stuff" ) { 
  default_output <- paste0(default_output,dataset,"/")
  
}  else if(dataset == "BottomlessA_4000") {
  bottomlessA_CQ_Dict<-paste0(default_input,"4000_CQ_Dictionary_Bottomless.csv")
 
  default_data <- paste0(default_input, "4000_WideCleanedBottomlessMeanDups.csv")
  default_superset <- paste0(default_input, "4000_WideCleanedBottomlessMeanDups.csv")
  default_output <- paste0(default_output,dataset,"/")
}   else if(dataset == "BottomlessA_4000_NoMistakes") {
 
   bottomlessA_CQ_Dict<-paste0(default_input,"4000_CQ_Dictionary_Bottomless.csv")
  default_data <- paste0(default_input, "4000_WideCleanedBottomlessMeanDupsNoMistakenCQs.csv")
  default_superset <- paste0(default_input, "4000_WideCleanedBottomlessMeanDupsNoMistakenCQs.csv")
  default_output <- paste0(default_output,dataset,"/")
} else if(dataset == "BottomlessA_4000_NAdOutMistakenCQs") {
  bottomlessA_CQ_Dict<-paste0(default_input,"4000_CQ_Dictionary_Bottomless.csv")

  default_data <- paste0(default_input, "4000_WideCleanedBottomlessMeanDupsMistakenCQsNAdOut.csv")
  default_superset <- paste0(default_input, "4000_WideCleanedBottomlessMeanDupsMistakenCQsNAdOut.csv")
  default_output <- paste0(default_output,dataset,"/")
}else if(dataset == "Simulated_Baseline") {
  default_data<-paste0(default_input,"simulated_3000.csv")
  analysis_calibration_list                      <- c("calibration_curve_1", "calibration_curve_2", "calibration_curve_3", "calibration_blue_1", "calibration_blue_2", "calibration_blue_3", "calibration_region_1", "calibration_region_2", "calibration_region_3", "calibration_crime_1", "calibration_crime_2", "calibration_crime_3", "calibration_info_1", "calibration_info_2", "calibration_info_3", "calibration_remember_1", "calibration_remember_2", "calibration_remember_3")
  
  default_superset <- default_data
  default_output <- paste0(default_output,dataset,"/")
  title_name = "Population: Simulated Data, using Jiannan's most recent model."
}

# For the UAS Survey
if (dataset == "UAS") {
  default_input <- paste0(default_UAS_wd, "Data/")
  default_data <- paste0(default_input, "Sample data/uas571.dta")
}

dataset_subsample_selected2 <- ifelse(dataset=="baseline_500","default_data_baseline2",ifelse(dataset=="baseline_invite","default_data_baseline2_invite",ifelse(dataset=="baseline_noninvite2","default_data_baseline_noninvite2",ifelse(dataset=="baseline_participate","default_data_baseline_participate2",ifelse(dataset=="BottomlessA_all" | dataset=="bottomlessA","default_data_bottomlessA_all2",ifelse(dataset=="invite_InformativeBoth","default_data_baseline_invite_InformativeBoth2",ifelse(dataset=="invite_InformativeCQ","default_data_baseline_invite_InformativeCQ2",ifelse(dataset=="invite_InformativeAspect","default_data_baseline_invite_InformativeAspect2",ifelse(dataset=="invite_InformativeNone","default_data_baseline_invite_InformativeNone2",NA))))))))) 
if(!is.na(dataset_subsample_selected2)) default_data2 <- get(dataset_subsample_selected2)

# Other items that are useful
# Adding a map of states to names
all_state_longnames <- c("Alaska","Arizona","Colorado","Idaho","Montana","Nevada","New Mexico","Utah","Wyoming", "California","Hawaii","Oregon","Washington", 
                         "Connecticut","Maine","Massachusetts","New Hampshire","Rhode Island","Vermont","New Jersey","New York","Pennsylvania", 
                         "Texas","Delaware","Maryland", "District of Columbia", "Virginia","West Virginia","Kentucky","North Carolina","South Carolina","Tennessee","Georgia","Florida","Alabama","Mississippi","Arkansas","Louisiana","Oklahoma", 
                         "North Dakota","South Dakota","Nebraska","Kansas","Minnesota","Iowa","Missouri","Wisconsin","Illinois","Indiana","Michigan","Ohio", "Puerto Rico")
all_state_longnames_with_abbrevs <- c("Alaska (AK)","Arizona (AZ)","Colorado (CO)","Idaho (ID)","Montana (MT)","Nevada (NV)","New Mexico (NM)","Utah (UT)","Wyoming (WY)","California (CA)","Hawaii (HI)","Oregon (OR)","Washington (WA)", 
                         "Connecticut (CT)","Maine (ME)","Massachusetts (MA)","New Hampshire (NH)","Rhode Island (RI)","Vermont (VT)","New Jersey (NJ)","New York (NY)","Pennsylvania (PA)", 
                         "Texas (TX)","Delaware (DE)","Maryland (MD)", "District of Columbia (DC)", "Virginia (VA)","West Virginia (WV)","Kentucky (KY)","North Carolina (NC)","South Carolina (SC)","Tennessee (TN)","Georgia (GA)","Florida (FL)","Alabama (AL)","Mississippi (MS)","Arkansas (AR)","Louisiana (LA)","Oklahoma (OK)", 
                         "North Dakota (ND)","South Dakota (SD)","Nebraska (NE)","Kansas (KS)","Minnesota (MN)","Iowa (IA)","Missouri (MO)","Wisconsin (WI)","Illinois (IL)","Indiana (IN)","Michigan (MI)","Ohio (OH)", "Puerto Rico (PR)")
all_state_abbrevs <- c("AK","AZ","CO","ID","MT","NV","NM","UT","WY","CA","HI","OR","WA", 
                         "CT","ME","MA","NH","RI","VT","NJ","NY","PA", 
                         "TX","DE","MD", "DC", "VA","WV","KY","NC","SC","TN","GA","FL","AL","MS","AR","LA","OK", 
                         "ND","SD","NE","KS","MN","IA","MO","WI","IL","IN","MI","OH", "PR")
state_names_map <- as.data.frame(
  cbind(
    all_state_longnames,
    all_state_longnames_with_abbrevs,
    all_state_abbrevs
  )
)
colnames(state_names_map) <- c("longname", "longname_abbrev", "abbrev")
