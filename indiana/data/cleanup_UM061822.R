# clean raw data

setwd("/Users/mitzi/github/toan/mrp-interface/data")
library(readxl)
library(dplyr)

raw_data = read_excel("UM061822RNA.xlsx")
zip_covars = read.csv("zip_covariates.csv")

# unused columns
raw_data <- raw_data[, -c(11:51)]
raw_data$`RNA/Antigen Question of Interest` = NULL
raw_data$`RNA/Antigen Result Date` = NULL

# simple names
colnames(raw_data)[colnames(raw_data) == "Age"] <- "age_yr"
colnames(raw_data)[colnames(raw_data) == "ZIP"] <- "zip"
colnames(raw_data)[colnames(raw_data) == "SEX"] <- "sex"
colnames(raw_data)[colnames(raw_data) == "RACE"] <- "eth"
colnames(raw_data)[colnames(raw_data) == "RNA/Antigen  Speciman Date"] <- "test_date"
colnames(raw_data)[colnames(raw_data) == "RNA/Antigen Order Results"] <- "y"

# drop rows with unknown sex
raw_data = raw_data[!raw_data$sex == "Unknown", ]

# drop rows with zips we don't know about
all_zips = unique(raw_data$zip)
known_zips = zip_covars$zip
unknown_zips = all_zips[!all_zips %in% known_zips]
raw_data$no_zip_covars = raw_data$zip %in% unknown_zips
table(raw_data$no_zip_covars)
raw_data = raw_data[!raw_data$no_zip_covars, ]
table(raw_data$zip)
length(table(raw_data$zip))
raw_data$no_zip_covars = NULL


dedup = unique(raw_data)
dedup = dedup %>% filter(complete.cases(.))

# y is 0/1
dedup$y = ifelse(dedup$y == "Negative", 0, 1)


# group ages
dedup$age <- cut(dedup$age_yr, breaks=c(0, 17, 34, 64, 74, max(dedup$age_yr)+1),
	     labels = c("0-17", "18-34", "35-64", "65-74", "75+"), right = FALSE)

# create ordered factor of weeks
dedup$day = as.Date(dedup$test_date, format="%m/%d/%y")
dedup$time <- paste(as.integer(format(dedup$day, "%W")) + 1, format(dedup$day, "%Y"), sep="/")
dedup$day = NULL

write.csv(raw_data, "anon_data_munged.csv", row.names=FALSE)
