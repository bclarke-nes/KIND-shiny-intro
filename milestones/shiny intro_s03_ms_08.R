data %>%
  filter(HBName == "NHS Borders") %>%
  ggplot() +
  geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup))
