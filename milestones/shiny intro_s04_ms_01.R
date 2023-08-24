library(shiny)

ui <- fluidPage(
  
  titlePanel("Shiny is a grid"),
  
  fluidRow(
    column(2, plotOutput("A")),
    column(2, plotOutput("B")), 
    column(2, plotOutput("C")),
    column(2, plotOutput("D")),
    column(2, plotOutput("E")), 
    column(2, plotOutput("F"))
  ),
  hr(),
  fluidRow(
    column(12, plotOutput("G")),
  )
)

server <- function(input, output, session) {
  
  output$A <- renderPlot(plot(mtcars$hp, mtcars$wt))
  output$B <- renderPlot(plot(mtcars$cyl, mtcars$wt))
  output$C <- renderPlot(plot(mtcars$hp, mtcars$cyl))
  output$D <- renderPlot(plot(mtcars$qsec, mtcars$wt))
  output$E <- renderPlot(plot(mtcars$hp, mtcars$gear))
  output$F <- renderPlot(plot(mtcars$carb, mtcars$wt))
  output$G <- renderPlot(plot(mtcars$hp, mtcars$drat))
  
}

shinyApp(ui, server)
