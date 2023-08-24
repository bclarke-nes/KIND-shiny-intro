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
