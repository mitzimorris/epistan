library(readr)
library(dplyr)

anon_data_munged <- read_csv("anon_data_munged.csv")
anon_data_munged$eth = as.factor(anon_data_munged$eth)
anon_data_munged$age = as.factor(anon_data_munged$age)
anon_data_munged$sex = as.factor(anon_data_munged$sex)
anon_data_munged$eth[anon_data_munged$eth %in% c(c("Middle Eastern",
"American Indian and Alaska Native",
"Asian", "Native Hawaiian Other Pacific Islander", "Patient Refused", "Middle Eastern", "Unknown"))] = "Other"
anon_data_munged$eth = droplevels(anon_data_munged$eth)
table(anon_data_munged$eth)

anon_data_munged$zip3 = as.factor(anon_data_munged$zip %/% 100)
foo = anon_data_munged %>% group_by(eth,age,sex,zip3) %>% summarise(pos_tests = sum(y), .groups="keep") %>% ungroup()
bar = anon_data_munged %>% group_by(eth,age,sex,zip3) %>% summarise(tests = n(), .groups="keep") %>% ungroup()
foo[] <- lapply(foo, function(x) if(is.factor(x)) as.integer(x) else x)
strata = foo
strata$tests = bar$tests
write.csv(strata, "anon_sex_age_eth_zip3.csv", row.names=FALSE)
