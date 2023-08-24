library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, glue)

ui <- fluidPage(
  selectInput("input", "Pick a number", c(1, 2, "3")),
  p("Your number is ", textOutput("text1", inline=T))
)

server <- function(input, output, session) {
  
  output$text1 <- renderText(
    glue("value: {input$input}, class: {class(input$input)}")
    #   if(input$input %% 2 == 0) {
    #   "even"
    # } else {
    #   "odd"
    # }
  )
}

shinyApp(ui, server)
