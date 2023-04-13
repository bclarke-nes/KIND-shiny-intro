
compare_boards <- function(boards, age, date_range=c(dmy("01/07/2016"), dmy("01/01/2023"))) {
  
  start <- date_range[1]
  end <- date_range[2]
  
  data %>%
    filter(HBName %in% boards) %>%
    filter(AgeGroup == age) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=HBName)) +
    ggtitle(glue("Delayed discharge bed days comparison for age group {age}")) +
    xlab("Month of delay") +
    ylab("Delayed discharge bed days") +
    scale_color_discrete(name = "Health boards")  +
    theme(plot.title = element_text(size=20),
          legend.title = element_text(size=20),
          legend.text = element_text(size=16)) +
    xlim(start, end)
  
}

