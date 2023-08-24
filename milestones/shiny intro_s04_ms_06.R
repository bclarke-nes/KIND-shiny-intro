library(pacman)
p_load(shiny, shinydashboard)

ui <-
  dashboardPage(
    dashboardHeader(title = "Delayed discharge dashboard",
                    titleWidth = 350),
    dashboardSidebar(
      width = 350,
      collapsed = F,
      sidebarMenu(menuItem(
        "Introduction",
        tabName = "introduction",
        icon = icon("info-circle")
      ))
    ),
    dashboardBody(tabItems(tabItem(
      tabName = "introduction",
      h2("Hello world")
    )))
  )
server <- function(input, output, session) {
  
}
shinyApp(ui, server)
