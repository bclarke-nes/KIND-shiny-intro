library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)
orgs <- c("RF4", "R1H", "RQM") 

ui <- fluidPage(
  radioButtons("org_code", "Pick an org", choices=orgs, selected=orgs[1]),
  "The mean number of attendances per period is: ",
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == input$org_code) %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == input$org_code) %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line()
  )
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == input$org_code) %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)
