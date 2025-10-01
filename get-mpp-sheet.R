library(googlesheets4)

path_to_json <- list.files("auth", pattern = ".json", full.names = TRUE)
  
gs4_auth(
  path = path_to_json,
  scopes = "https://www.googleapis.com/auth/spreadsheets.readonly"
)

sheet_url <- "https://docs.google.com/spreadsheets/d/1UZFvmtcQGvsB7FzvAjqNTXwuIHFGgL1FqZwzedBHfKw/edit?gid=0#gid=0"

resolutions <- read_sheet("https://docs.google.com/spreadsheets/d/1UZFvmtcQGvsB7FzvAjqNTXwuIHFGgL1FqZwzedBHfKw/edit?gid=0#gid=0")

gs4_deauth()
