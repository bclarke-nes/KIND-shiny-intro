library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Boxes are great", 
                  titleWidth = 350),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(box(plotOutput("plotA"), title = "A boxed plot", solidHeader = T, status = "primary")),
    fluidRow(plotOutput("plotB")))
)

server <- function(input, output, session) {
  output$plotA <- renderPlot(plot(mtcars$hp, mtcars$wt))
  output$plotB <- renderPlot(plot(mtcars$carb, mtcars$wt))
}
shinyApp(ui, server)
