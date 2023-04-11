library(pacman)
p_load(shiny, tidyverse)

ui <- fluidPage(
  "The mean number of attendances is: ",
  textOutput("mean_att"),
  plotOutput("att_period")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() +
      geom_smooth()
  )
}

shinyApp(ui, server)
