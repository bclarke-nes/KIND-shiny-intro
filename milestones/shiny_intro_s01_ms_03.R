library(shiny)

ui <- fluidPage("Hello world", textOutput("message"))

server <- function(input, output, session) {
  output$message <- renderText("This is a Shiny thing")
}

shinyApp(ui, server)
