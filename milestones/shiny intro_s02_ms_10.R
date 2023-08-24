library(pacman)
p_load(tidyverse, NHSRdatasets)

ae_attendances %>%
  filter(type == "1") %>%
  group_by(period) %>%
  summarise(attendances = mean(attendances)) %>%
  ggplot() +
  geom_line(aes(x = period, y = attendances), color = "darkblue")
