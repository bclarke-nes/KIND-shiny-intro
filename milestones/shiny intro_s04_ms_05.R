library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", 
                  titleWidth = 350),
  dashboardSidebar(width = 350, 
                   collapsed = F, 
                   sidebarMenu(menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")))),
  dashboardBody()
)

server <- function(input, output, session) {
}
shinyApp(ui, server)
