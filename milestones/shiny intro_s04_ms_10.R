# server.R

server <- function(input, output, session) {
  
  isolate(source(here("R", "s04.R"), local = TRUE))
  
  output$discharge_graph <- renderPlot(
    discharge_graph(input$board)
  )
  
}
