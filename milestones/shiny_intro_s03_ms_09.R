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
  
}

shinyApp(ui, server)
