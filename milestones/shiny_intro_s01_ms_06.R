library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)

ui <- fluidPage(
  "The mean number of attendances per period is: ",
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == "RF4") %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == "RF4") %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line()
  )
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == "RF4") %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)
