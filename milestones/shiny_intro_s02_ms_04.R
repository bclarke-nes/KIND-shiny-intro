library(pacman)
p_load(shiny, tidyverse, lubridate, NHSRdatasets)

ui <- fluidPage(
  checkboxGroupInput(
    "org",
    label = "Select an org",
    choices = c("RJ1", "RLN", "RXK"),
    selected = "RJ1"
  ),
  radioButtons(
    "type_select",
    label = "Pick a type:",
    choices = c("1", "2"),
    selected = "1"
  ),
  plotOutput("compare_orgs")
)

server <- function(input, output, session) {
  output$compare_orgs <- renderPlot(
    ae_attendances %>%
      filter(org_code %in% input$org &
               type == input$type_select) %>%
      ggplot() +
      geom_line(aes(
        x = period, y = attendances, color = org_code
      ))
  )
  
}

shinyApp(ui, server)

