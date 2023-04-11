library(pacman)
p_load(tidyverse, lubridate, glue, ggrepel)

# data loading and processing ----
# this script will either read processed data from rds files, or create them using s03_data.R if they do not exist
# it then contains functions to produce the graphs used in the session 3 and session 4 dashboards

source_files <- c("data/data.rds", "data/boards.rds", "data/standardised_data.rds", "data/standardised_data_national.rds")

if(all(file.exists(source_files))){
  
  data <- read_rds("data/data.rds")
  boards <- read_rds("data/boards.rds")
  standardised_data <- read_rds("data/standardised_data.rds")
  standardised_data_national <- read_rds("data/standardised_data_national.rds")
  
} else {
  source("data/s03_data.R")
  data <- read_rds("data/data.rds")
  boards <- read_rds("data/boards.rds")
  standardised_data <- read_rds("data/standardised_data.rds")
  standardised_data_national <- read_rds("data/standardised_data_national.rds")
}
