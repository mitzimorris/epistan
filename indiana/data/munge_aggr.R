setwd("/Users/mitzi/github/toan/mrp-interface/data")
library(readr)
anon_data_munged <- read_csv("anon_data_munged.csv")
library(dplyr)
anon_data_munged$eth = as.factor(anon_data_munged$eth)
anon_data_munged$age = as.factor(anon_data_munged$age)
anon_data_munged$time = as.factor(anon_data_munged$time)
anon_data_munged$zip = as.factor(anon_data_munged$zip)
anon_data_munged$sex = as.factor(anon_data_munged$sex)
anon_data_munged$eth[anon_data_munged$eth %in% c(c("Middle Eastern",
"American Indian and Alaska Native",
"Asian", "Native Hawaiian Other Pacific Islander", "Patient Refused", "Middle Eastern", "Unknown"))] = "Other"
anon_data_munged$eth = droplevels(anon_data_munged$eth)
table(anon_data_munged$eth)
foo = anon_data_munged %>% group_by(eth,age,sex,time,zip) %>% summarise(cases = sum(y), .groups="keep") %>% ungroup()
bar = anon_data_munged %>% group_by(eth,age,sex,time,zip) %>% summarise(trials = n(), .groups="keep") %>% ungroup()
strata = foo
strata$trials = bar$trials
rm(list=c("bar", "foo"))
write.csv(strata, "anon_data_aggr.csv", row.names=FALSE)
