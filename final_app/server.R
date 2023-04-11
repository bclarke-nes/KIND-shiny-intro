library(pacman)
p_load(shiny, shinydashboard, plotly, tidyverse, lubridate,  glue, ggrepel)

server <- function(input, output, session) {
  
  output$graph <- renderPlot(discharge_graph(input$data))
  
  output$between <- renderPlot(
    compare_boards(
      input$rate_board_select,
      input$rate_age_select,
      input$date_range
    )
  )
  
  output$rates <- renderPlot(
    stand_compare_boards(input$rate_select, input$age_select, scot = input$scot_nat_comp)
  )
  
  output$map <- renderPlotly({
    comp_map(input$map_date, input$map_age_select)
  })
  
}