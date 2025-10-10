library(dplyr)
library(readr)
library(sf)

# read in data
resolutions <- read_csv("data/temp/resolutions.csv")
letters <- read_csv("data/temp/letters_of_support.csv")
senate_districts <- read_sf("data/senate_districts.fgb")
senate_cities <- read_csv("data/senate_cities.csv")
senate_counties <- read_csv("data/senate_counties.csv")
assembly_districts <- read_sf("data/assembly_districts.fgb")
assembly_cities <- read_csv("data/assembly_cities.csv")
assembly_counties <- read_csv("data/assembly_counties.csv")

# county resolutions
resolutions <- resolutions |> 
  filter(Status == "Passed")

county_res <- resolutions |> 
  filter(
    str_detect(`Local Govt.`, "County"),
    !str_detect(`Local Govt.`, "\\("),
    !str_detect(`Local Govt.`, "Regional")
  ) |> 
  mutate(
    county_name = str_remove(`Local Govt.`, " County")
  ) |> 
  select(county_name)

county_res_senate <- county_res |> 
  left_join(senate_counties) |> 
  group_by(senate_district_label) |> 
  reframe(
    county_resolutions_passed = n(),
    county_resolution_names = paste(county_name, collapse = ", ")
  )

county_res_assembly <- county_res |> 
  left_join(assembly_counties) |> 
  group_by(assembly_district_label) |> 
  reframe(
    county_resolutions_passed = n(),
    county_resolution_names = paste(county_name, collapse = ", ")
  )

# city resolutions
city_res <- resolutions |> 
  filter(
    str_detect(`Local Govt.`, "City Council") |
      str_detect(`Local Govt.`, "\\(Sonoma")
  ) |> 
  mutate(
    city_name = str_remove(`Local Govt.`, " City Council"),
    city_name = str_remove(city_name, " \\(Sonoma County\\)"),
    city_name = case_when(
      city_name == "LA" ~ "Los Angeles",
      TRUE ~ city_name
    )
  ) |> 
  select(city_name)

city_res_senate <- city_res |> 
  left_join(senate_cities) |> 
  group_by(senate_district_label) |> 
  reframe(
    city_resolutions_passed = n(),
    city_resolution_names = paste(city_name, collapse = ", ")
  )

city_res_assembly <- city_res |> 
  left_join(assembly_cities) |> 
  group_by(assembly_district_label) |> 
  reframe(
    city_resolutions_passed = n(),
    city_resolution_names = paste(city_name, collapse = ", ")
  )

# letters of support
letters_summary <- letters |> 
  mutate(
    city_name = City,
    name_title = paste0(`First Name`, " ", `Last Name`, " (", `Elected Position/Title`, ")")
  ) |> 
  group_by(city_name) |> 
  reframe(
    number_of_letters = n(),
    letter_authors = paste(name_title, collapse = ", ")
  )

letters_senate <- letters_summary |> 
  left_join(senate_cities) |> 
  group_by(senate_district_label) |> 
  reframe(
    number_of_letters = sum(number_of_letters),
    letter_authors = paste(letter_authors, collapse = ", ")
  )

letters_assembly <- letters_summary |> 
  left_join(assembly_cities) |> 
  group_by(assembly_district_label) |> 
  reframe(
    number_of_letters = sum(number_of_letters),
    letter_authors = paste(letter_authors, collapse = ", ")
  )

# assembly districts
assembly <- assembly_districts |> 
  left_join(county_res_assembly) |> 
  left_join(city_res_assembly) |> 
  left_join(letters_assembly) |> 
  mutate(
    activity = ifelse(
      is.na(number_of_walkouts) &
        is.na(county_resolutions_passed) &
        is.na(city_resolutions_passed) &
        is.na(number_of_letters),
      FALSE,
      TRUE
    )
  )

write_sf(
  assembly,
  "data/temp/assembly.geojson",
  delete_dsn = T
)

# senate districts
senate <- senate_districts |> 
  left_join(county_res_senate) |> 
  left_join(city_res_senate) |> 
  left_join(letters_senate) |> 
  mutate(
  activity = ifelse(
    is.na(number_of_walkouts) &
      is.na(county_resolutions_passed) &
      is.na(city_resolutions_passed) &
      is.na(number_of_letters),
    FALSE,
    TRUE
  )
)

write_sf(
  senate,
  "data/temp/senate.geojson",
  delete_dsn = T
)
