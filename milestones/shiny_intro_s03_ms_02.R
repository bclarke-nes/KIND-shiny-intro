library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody()
  )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

