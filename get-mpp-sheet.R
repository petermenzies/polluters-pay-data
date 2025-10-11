library(googlesheets4)
library(readr)

path_to_json <- list.files("auth", pattern = ".json", full.names = TRUE)
  
gs4_auth(
  path = path_to_json,
  scopes = "https://www.googleapis.com/auth/spreadsheets.readonly"
)

sheet_url <- "https://docs.google.com/spreadsheets/d/1UZFvmtcQGvsB7FzvAjqNTXwuIHFGgL1FqZwzedBHfKw/edit?gid=0#gid=0"

resolutions <- read_sheet("https://docs.google.com/spreadsheets/d/1UZFvmtcQGvsB7FzvAjqNTXwuIHFGgL1FqZwzedBHfKw/edit?gid=0#gid=0")

write_csv(resolutions, "data/temp/resolutions.csv")

gs4_deauth()
