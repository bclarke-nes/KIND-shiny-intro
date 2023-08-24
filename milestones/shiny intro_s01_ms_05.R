library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage(
    plotOutput("att_period")
)

server <- function(input, output, session) {
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == "RF4") %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() 
  )
}

shinyApp(ui, server)
