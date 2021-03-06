# sf_example_simple.R

library(sf)
library(magrittr)
library(data.table)
library(RPostgreSQL)
library(mapview)

# source('C:/Users/zach/Documents/Code/COVID19-Data-Exploration/scripts/R/session2/insert_report_data.R')
# -------- Access the COVID-19 Database --------- #
source(file.path(git.path,'Code/config_files/db_config.R'))
con <- db_connect.fn()
full.dt<-dbGetQuery(con,'SELECT * FROM covid_data.report_data') %>% data.table
dbDisconnect(con)  
# ----------------------------------------------- #

# remove NA's 
report_data.dt <- report_data.dt[!is.na(report_data.dt$latitude) & 
                                 !is.na(report_data.dt$longitude),]

# Create spatial object from data table and view on global map
report_data.sf <- st_as_sf(report_data.dt, coords = c("longitude", "latitude"), crs=4326)
mapview(report_data.sf)

us_data.dt <- report_data.dt[report_data.dt$country_region=='US',]
us_data.sf <- st_as_sf(us_data.dt, coords = c("longitude", "latitude"), crs=4326)
mapview(us_data.sf)

# bench::mark(
#     b1 <- report_data.dt[report_data.dt$country_region=='US',],
#     b2 <- report_data.sf[report_data.sf$country_region=='US',] %>% data.table
# )
