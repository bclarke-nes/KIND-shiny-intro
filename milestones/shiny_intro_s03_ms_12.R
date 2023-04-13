
stand_compare_boards <- function(boards, age, scot=FALSE) {
  
  comparison <- standardised_data_national %>%
    filter(AgeGroup == age) %>%
    filter(!is.na(rate))
  
  #damn labels (board data)
  labels <- standardised_data %>%
    filter(AgeGroup == age)  %>%
    filter(HBName %in% boards) %>%
    filter(!is.na(rate)) %>%
    group_by(HBName)%>%
    summarise(month = mean(MonthOfDelay), rate=mean(rate))
  
  #damn damn labels (board data)
  nat_label_height <- comparison %>%
    pull(rate)
  
  nat_label_height <- mean(nat_label_height, na.rm=T)
  
  if(scot==FALSE) {
    
    standardised_data %>%
      filter(HBName %in% boards) %>%
      filter(AgeGroup == age) %>%
      filter(!is.na(rate)) %>%
      ggplot() +
      geom_line(aes(x=MonthOfDelay, y=rate, color=HBName), alpha=0.9) +
      geom_label_repel(data = labels, aes(x=month, y=rate, color=HBName, label=HBName), alpha=0.9) +
      ggtitle(glue("Delayed discharge bed days, standardised per capita")) +
      theme(legend.position = "none", 
            plot.title = element_text(size=20)) +
      xlab("Month of delay") +
      ylab("Standardised delayed discharge rate, bed days per 100,000 population") 
    
  } else {
    standardised_data %>%
      filter(HBName %in% boards) %>%
      filter(AgeGroup == age) %>%
      filter(!is.na(rate)) %>%
      ggplot() +
      geom_line(
        data = comparison,
        aes(x = MonthOfDelay, y = rate),
        color = "dimgray",
        linewidth = 1,
        show.legend = "National average"
      ) +
      geom_label(data = comparison, aes(
        x = dmy("01-09-2021"),
        y = nat_label_height,
        label = HBName
      )) +
      geom_line(aes(x=MonthOfDelay, y=rate, color=HBName), alpha=0.9) +
      geom_label_repel(data = labels, aes(x=month, y=rate, color=HBName, label=HBName), alpha=0.9) +
      ggtitle(glue("Delayed discharge bed days, standardised per capita")) +
      theme(legend.position = "none", 
            plot.title = element_text(size=20)) +
      xlab("Month of delay") +
      ylab("Standardised delayed discharge rate, bed days per 100,000 population") 
    
  }
}

