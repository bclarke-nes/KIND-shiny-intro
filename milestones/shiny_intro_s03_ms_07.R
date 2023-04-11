discharge_graph <- function(board) {
  data %>%
    filter(HBName == board) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup))
}
