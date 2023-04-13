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
    choices = sort(unique(ae_attendances$type)),
    selected = "1"
  ),
  plotOutput("compare_orgs")
)

server <- function(input, output, session) {
  benchmark <- reactive({
    ae_attendances %>%
      filter(type %in% input$type_select) %>%
      group_by(period) %>%
      summarise(attendances = mean(attendances))
  })
  
  output$compare_orgs <- renderPlot(
    ae_attendances %>%
      filter(org_code %in% input$org &
               type == input$type_select) %>%
      ggplot() +
      geom_line(aes(
        x = period, y = attendances, color = org_code
      )) +
      geom_line(
        data = benchmark(),
        aes(x = period, y = attendances),
        color = "darkblue"
      ) + # call the reactive using the assigned name followed by ()
      geom_label(
        data = benchmark(),
        aes(x = mean(period), y = mean(attendances)),
        color = "darkblue",
        label = "National benchmark"
      )
    
  )
}

shinyApp(ui, server)

