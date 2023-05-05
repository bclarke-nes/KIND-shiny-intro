library(pacman)
p_load(tidyverse, NHSRdatasets)

ae_attendances %>%
  filter(org_code %in% c("RJ1", "RLN", "RXK") & type == "1") %>%
  ggplot() +
  geom_line(aes(x = period, y = attendances, color = org_code))
