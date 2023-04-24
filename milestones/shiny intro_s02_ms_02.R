library(pacman)
p_load(shiny, tidyverse, lubridate, NHSRdatasets)

ui <- fluidPage(
  checkboxGroupInput(
    "org",
    label = "Select an org",
    choices = c("RJ1", "RLN", "RXK")
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
  output$compare_orgs <- renderPlot()
}

shinyApp(ui, server)
