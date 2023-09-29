library(shiny)
library(tidyverse)
# library(reactlog)
# reactlog_enable()

ui <- fluidPage(
  
  radioButtons("cylz", "Which cyl?", c(4, 6, 8, 12), selected=12),
  
  plotOutput("carz")
)

server <- function(input, output, session) {
  
  output$carz <- renderPlot({
    
    car_dat <- mtcars |>
      filter(cyl == input$cylz) 
    
    # browser()
    
    car_dat |>
      ggplot() +
      geom_point(aes(x=wt, y=hp, color=factor(cyl)))
  })
}

shinyApp(ui, server)
