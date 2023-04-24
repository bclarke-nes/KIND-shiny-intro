library(pacman)
p_load(shiny, tidyverse, lubridate, NHSRdatasets, plotly)

key_orgs <- ae_attendances %>%
  group_by(period, org_code) %>%
  add_tally(name = "type_tally") %>%
  filter(type_tally == 3) %>%
  ungroup() %>%
  group_by(org_code, type) %>%
  add_count(name = "months") %>%
  filter(months == 36) %>%
  pull(org_code) %>%
  unique()

ui <- fluidPage(
  checkboxGroupInput(
    "org",
    label = "Select an org",
    choices = key_orgs,
    selected = key_orgs[1]
  ),
  radioButtons(
    "type_select",
    label = "Pick a type:",
    choices = sort(unique(ae_attendances$type)),
    selected = "1"
  ),
  checkboxInput("bench", label = "National benchmark?"),
  plotlyOutput("compare_orgs")
)

server <- function(input, output, session) {
  benchmark <- reactive({
    ae_attendances %>%
      filter(type %in% input$type_select) %>%
      group_by(period) %>%
      summarise(attendances = mean(attendances))
  })
  
  bench <- reactive(input$bench)
  
  graph <- reactive(if (bench() == FALSE) {
    
    ae_attendances %>%
      filter(org_code %in% input$org &
               type == input$type_select) %>%
      ggplot() +
      geom_line(aes(
        x = period, y = attendances, color = org_code
      ), alpha = 0.5)
  } else {
    
    ae_attendances %>%
      filter(org_code %in% input$org &
               type == input$type_select) %>%
      ggplot() +
      geom_line(aes(
        x = period, y = attendances, color = org_code
      ), alpha = 0.5) + 
      geom_line(
        data = benchmark(),
        aes(x = period, y = attendances),
        color = "darkblue"
      ) +
      geom_text(
        data = benchmark(),
        aes(x = mean(period), y = mean(attendances) + 1000),
        color = "darkblue",
        label = "National benchmark"
      )
    
  }
  )
  
  output$compare_orgs <- renderPlotly(
    ggplotly(graph())
  )
}

shinyApp(ui, server)
