# data loading ----

library(pacman)
p_load(shiny, shinydashboard, plotly, tidyverse, lubridate,  glue, ggrepel)

# helper functions ----

tidy_age_groups <- function(df) {
  # helper to standardise age groups
    df %>% mutate(AgeGroup = case_when(
      AgeGroup == "18-74" ~ "18 - 74",
      AgeGroup == "18plus" ~ "18 plus",
      AgeGroup == "75plus" ~ "75 plus"))
    
}

message("Loading data from source, apologies for the delay")

# retrieve data from opendata and do preliminary processing ----

## delayed discharge data
data_raw <- read_csv("https://www.opendata.nhs.scot/dataset/52591cba-fd71-48b2-bac3-e71ac108dfee/resource/fd354e4b-6211-48ba-8e4f-8356a5ed4215/download/2022-12_delayed-discharge-beddays-health-board.csv")

## board names and codes
boards <- read_csv("https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv") %>%
  filter(HB %in% unique(data_raw$HBT)) %>%
  select(HBT = HB, HBName) %>%
  bind_rows(tibble(HBT = "S92000003", HBName = "National"))

## main delayed discharge data with board names
data <- data_raw %>% 
  tidy_age_groups %>%
  left_join(boards) %>%
  mutate(MonthOfDelay = ym(MonthOfDelay)) %>%
  group_by(MonthOfDelay, AgeGroup, HBName) %>%
  summarise(Total = sum(NumberOfDelayedBedDays, na.rm=T))

## population data for boards
popn_grouped <- read_csv("https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1/download/hb2019_pop_est_15072022.csv") %>%
  filter(Sex == "All" & Year >= 2016) %>%
  select(!3:5) %>%
  rename(AgeAll = AllAges) %>%
  pivot_longer(!c(Year, HB), names_to = "AgeGroup", names_pattern = "Age(.*)") %>%
  filter(AgeGroup != "All") %>%
  mutate(AgeGroup = case_when(AgeGroup == "90plus" ~ "90",
                              T ~ AgeGroup)) %>%
  mutate(AgeGroup = as.numeric(AgeGroup)) %>%
  filter(AgeGroup >= 18) %>%
  mutate(group = case_when(AgeGroup >= 18 & AgeGroup < 75  ~ "18-74",
                           T ~ "75plus")) %>%
  group_by(Year, HB, group) %>%
  summarise(total = sum(value)) %>%
  left_join(boards, by=c("HB" = "HBT")) %>%
  pivot_wider(names_from = group, values_from="total") %>%
  mutate(`18plus` = `18-74` + `75plus`) %>%
  pivot_longer(4:6, names_to = "AgeGroup", values_to = "Popn") %>% 
  tidy_age_groups

standardised_data <- data %>%
  mutate(Year = year(MonthOfDelay)) %>%
  left_join(popn_grouped, by=c("Year", "HBName", "AgeGroup")) %>%
  mutate(rate = Total / (Popn / 100000))

standardised_data_national <- standardised_data %>%
  filter(HBName == "National")

# write .rds files
write_rds(boards, "boards.rds")
write_rds(data, "data.rds")
write_rds(standardised_data, "standardised_data.rds")
write_rds(standardised_data_national, "standardised_data_national.rds")
