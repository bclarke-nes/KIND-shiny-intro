library(pacman)
p_load(shiny, tidyverse, readxl, writexl, hrbrthemes, forcats, gghighlight, glue, geojsonio, broom, viridis, mapproj, sf, PostcodesioR, stringr, openxlsx)

# read the condition counts
hscp_counts <- read.xlsx("data/general-practice-recorded-diagnoses.xlsx", sheet = "Table 3a", startRow = 8) %>%
  select_all( ~ gsub("\\.", " ", .)) %>%
  mutate_all(~ gsub("-", "0", .)) %>% # true 0 values are "-"
  mutate_all(~ gsub("\\*", NA, .)) %>% # redacted for disclosure risk are "*"
  rename(`Whole of Scotland` = Total) # to save fooling about when we want to display WoS values

# read the populations
hscp_populations <- read.xlsx("data/general-practice-recorded-diagnoses.xlsx", sheet = "Table 3b", startRow = 7) %>%
  mutate(HSCP = (case_when(HSCP == "Total" ~ "Whole of Scotland",
                           TRUE ~ HSCP))) # to save fooling about when we want to display WoS values

# function to help join populations to conditions
poppo <- function(name) {
  
  hscp_populations %>%
    filter(HSCP == {{name}}) %>%
    pull(Population.Of.Returned.Practices)
}

# vectorise the function so that we can use it over the whole HSCP column at once
poppo2 <- Vectorize(poppo)

# pivot the count data
hscp_rates <- hscp_counts %>%
  pivot_longer(!Condition, names_to = "HSCP", values_to = "Count") %>%
  mutate(Count = as.numeric(Count)) %>%
  rowwise() %>%
  mutate(Population = poppo2(HSCP)) %>% # adds in the population values
  mutate(Rate = 1e4 * Count / Population)

write_rds(hscp_rates, "data/hscp_rates.RDS")

p_load(rgeos)
Scot_LAD_hscp <- geojson_read("data/SG_HealthIntegrationAuthority_2019/SG_NHS_IntegrationAuthority_2019.shp", what="sp")

Scot_LAD_hscp_sim <- gSimplify(Scot_LAD_hscp, tol=30, topologyPreserve=TRUE)
Scot_LAD_hscp@polygons <- Scot_LAD_hscp_sim@polygons

region_lookup_hscp <- tibble(id=1:length(Scot_LAD_hscp@data[["HIACode"]]), id_json = Scot_LAD_hscp@data[["HIACode"]], HIAName = Scot_LAD_hscp@data[["HIAName"]])

Scot_LAD_hscp <- Scot_LAD_hscp %>%
  tidy() %>%
  mutate(id = as.numeric(id)) %>%
  left_join(region_lookup_hscp, on=id, keep=F)

write_rds(Scot_LAD_hscp, "data/Scot_LAD_hscp.RDS")
