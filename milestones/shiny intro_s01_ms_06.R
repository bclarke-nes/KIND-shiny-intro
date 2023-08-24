library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)

ui <- fluidPage(
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
 
    output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == "RF4") %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)
