library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage(
  selectInput("input", "Pick a number", c(1, 2, "3")),
  p("Your number is ", textOutput("text1", inline=T))
)

server <- function(input, output, session) {
  browser()
    output$text1 <- renderText(
    if(input$input %% 2 == 0) {
      "even"
    } else {
      "odd"
    }
  )
}
