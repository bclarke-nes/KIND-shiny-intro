library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)
orgs <- c("RF4", "R1H", "RQM") 

ui <- fluidPage(
  radioButtons("org_code", "Pick an org", choices=orgs, selected=orgs[1]),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == input$org_code) %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)
