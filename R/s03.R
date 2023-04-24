library(pacman)
p_load(tidyverse, lubridate, glue, ggrepel)

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
  

# functions ----
discharge_graph <- function(board) {
 # single board values
   # note that we don't need to do any fancy data masking here to pass the arguments
  
  data %>%
    filter(HBName == board) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup)) +
    ggtitle(glue("{board} delayed discharge bed days")) +
    xlab("Month of delay") +
    ylab("Delayed discharge bed days") +
    scale_color_discrete(name = "Age group") +
    theme(plot.title = element_text(size=20),
          legend.title = element_text(size=20),
          legend.text = element_text(size=16))
  
}
