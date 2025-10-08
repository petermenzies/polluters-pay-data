schools <- c(
  "Bonita Vista High School, California",
  "Cal State San Marcos, California",
  "Canyon Crest Academy, California",
  "Eastlake High School, California",
  "Grauer School, California",
  "Hilltop High School, California",
  "La Jolla High School, California",
  "Mission Bay High School, California",
  "Mt. Carmel High School, California",
  "Otay Ranch High School, California",
  "Pacific Beach Middle School, California",
  "Patrick Henry High School, California",
  "Point Loma High School, California",
  "The Preuss School, California",
  "San Diego High School, California",
  "SD School of Creative and Performing Arts, California",
  "Southwest High School, California",
  "University City High School, California",
  "UCSD, California",
  "Westview High School, California",
  "John Marshall High School, California",
  "La Salle College Preparatory, California",
  "Irvine Valley College, California",
  "Laguna Beach High School, California",
  "Woodbridge High School, California",
  "Saddleback College, California",
  "Half Moon Bay High School, California",
  "Santa Barbara High School, California",
  "UCSB, California",
  "Abraham Lincoln High School, California",
  "Alameda Science and Technology Institute, California",
  "Amador Valley High School, California",
  "Archie Williams High School, California",
  "Berkeley High School, California",
  "Carlmont High School, California",
  "El Cerrito High School, California",
  "Encinal Jr\\Sr High School, California",
  "Granada High School, California",
  "Head Royce High School, California",
  "Lick-Wilmerding High School, California",
  "Lowell High School, California",
  "San Mateo High School, California",
  "Santa Clara University, California",
  "Saint Francis High School, California",
  "C.K. McClatchy High School, California",
  "Granite Bay High School, California",
  "Rio Americano High School, California",
  "UC Davis, California",
  "Whitney High School, California"
)

geocoded <- schools |> 
  tidygeocoder::geo_arcgis()

geo_sf <- geocoded |> 
  st_as_sf(coords = c("long", "lat"), crs = 4326) |> 
  mutate(
    school = str_remove(address, ", California")
  ) |> 
  select(school)

write_sf(
  geo_sf,
  "walkouts.fgb",
  delete_dsn = T
)
