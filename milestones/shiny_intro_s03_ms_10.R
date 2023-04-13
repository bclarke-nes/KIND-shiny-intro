library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(h2("Comparing delayed discharge rate between boards"),
                  
                  fluidRow(plotOutput("graph"),) ,
                  fluidRow(
                    box(
                      title = "Controls",
                      selectInput("board", "Pick a board:", unique(boards$HBName))
                    )
                  )
    )
  )
  
)

server <- function(input, output, session) {
  isolate(source("R/s03.R", local = TRUE))
  
  output$graph <- renderPlot(
    discharge_graph(input$board)
  )
}

shinyApp(ui, server)

