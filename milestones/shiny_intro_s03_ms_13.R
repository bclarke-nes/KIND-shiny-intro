comp_map <- function(month_r, age = "18 plus", comp = "National") {
  
  month <- floor_date(month_r, unit = "month")
  comp_str <- paste0(comp)
  
  if (length(comp) == 1 && comp == "National") {
    comparator <- standardised_data_national %>%
      ungroup() %>%
      filter(AgeGroup == age) %>%
      filter(MonthOfDelay == month) %>%
      filter(!is.na(rate)) %>%
      select(MonthOfDelay, comp_rate = rate)
  } else {
    comparator <- standardised_data %>%
      filter(HBName %in% comp) %>%
      ungroup() %>%
      filter(AgeGroup == age) %>%
      filter(MonthOfDelay == month) %>%
      filter(!is.na(rate)) %>%
      group_by(MonthOfDelay) %>%
      mutate(
        ddtotal = sum(Total),
        ddpopn = sum(Popn),
        comp_rate = 10e4 * ddtotal / ddpopn
      ) %>%
      select(MonthOfDelay, comp_rate) %>%
      distinct()
  }
  
  df <- standardised_data %>%
    filter(HBName != "National") %>%
    filter(MonthOfDelay == month) %>%
    filter(AgeGroup == age) %>%
    filter(!is.na(rate)) %>%
    left_join(comparator) %>%
    mutate(comparative_rate = rate / comp_rate)
  
  Scot_HB <- read_rds("data/Scot_HB.RDS")
  
  ggplotly(Scot_HB %>%
             left_join(df, by = c("id_json" = "HB")) %>%
             ggplot() +
             geom_polygon(aes(
               x = long,
               y = lat,
               group = group,
               fill = comparative_rate
             )) +
             theme_void() +
             coord_sf(default_crs = sf::st_crs(4326)) +
             labs(fill = "") +
             scale_fill_gradientn(colours = c("green", "lightgrey", "red")) +
             theme(legend.position = "bottom",
                   panel.background = element_rect(fill='transparent'), # to set transparent background
                   plot.background = element_rect(fill='transparent', color=NA),
                   legend.background = element_rect(fill='transparent'),
                   legend.box.background = element_rect(fill='transparent')) +
             
             labs(title = glue("Relative delayed discharge, {month}, for the {age} age group"),
                  subtitle = glue("Compared to {comp_str} data")))
  
}



