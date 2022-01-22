# Cities database

library(tidyverse)
library(countrycode)
library(arrow)

# US Cities
us_cities <- read_csv(file = "https://raw.githubusercontent.com/rfsaldanha/US-Cities-Database/main/csv/us_cities.csv") %>%
  select(name = COUNTY, lat = LATITUDE, lon = LONGITUDE) %>%
  mutate(country = "EUA")

# Other contries
temp_file <- tempfile()
temp_dir <- tempdir()
#download.file(url = "https://geonames.nga.mil/gns/html/cntyfile/geonames_fc_20220117.zip", mode = "wb", destfile = temp_file)
#unzip(zipfile = temp_file, exdir = temp_dir, files =  "Countries_populatedplaces_p.txt")
unzip(zipfile = "/Users/raphaelsaldanha/Downloads/geonames_fc_20220117.zip", exdir = temp_dir, files =  "Countries_populatedplaces_p.txt")
other_cities_db <- read_tsv(file = paste0(temp_dir, "/", "Countries_populatedplaces_p.txt"))
country_list <- countrycode::codelist %>%
  select(fips, country = country.name.en)

cities <- other_cities_db %>%
  select(name = FULL_NAME_RO, lat = LAT, lon = LONG, CC1) %>%
  left_join(country_list, by = c("CC1" = "fips")) %>%
  select(-CC1) %>%
  bind_rows(us_cities) %>%
  mutate(id = row_number())

write_feather(x = cities, sink = "cities.feather", compression = "uncompressed")
