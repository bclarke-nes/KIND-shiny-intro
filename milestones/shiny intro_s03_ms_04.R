library(pacman)
p_load(tidyverse, lubridate, glue, ggrepel, here)
i_am("R/s03.R")

# data loading and processing ----
# this script will either read processed data from rds files, or create them using s03_data.R if they do not exist
# it then contains functions to produce the graphs used in the session 3 and session 4 dashboards

source_files <- c(here("data", "data.rds"),
                  here("data", "boards.rds"),
                  here("data", "standardised_data.rds"),
                  here("data", "standardised_data_national.rds"))

if(!all(file.exists(source_files))){
  source(here("R", "s03_data.R"), local = TRUE)
}
data <- read_rds(source_files[1])
boards <- read_rds(source_files[2])
standardised_data <- read_rds(source_files[3])
standardised_data_national <- read_rds(source_files[4])
