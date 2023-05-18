ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", titleWidth = 350),
  dashboardSidebar(
    width = 350,
    collapsed = F,
    sidebarMenu(
      menuItem(
        "Introduction",
        tabName = "introduction",
        icon = icon("info-circle")
      ),
      menuItem(
        "Delayed discharges by board",
        tabName = "by_board",
        icon = icon("briefcase-medical")
      ),
      menuItem(
        "Comparing delayed discharges between boards",
        tabName = "between_boards",
        icon = icon("handshake")
      ),
      menuItem(
        "Comparing delayed discharge rate between boards",
        tabName = "rates",
        icon = icon("clinic-medical")
      ),
      menuItem(
        "Mapping delayed discharge rates",
        tabName = "map",
        icon = icon("globe")
      )
    )
  ),
  dashboardBody(tabItems(# intro tab
    tabItem(tabName = "introduction",
            # need header
            fluidRow(
              h2("Delayed discharge dashboard")
            )),
    tabItem(tabName = "by_board",
            # need header
            fluidRow(
              h2("Delayed discharges by board")
            )),
    tabItem(tabName = "between_boards",
            # need header
            fluidRow(
              h2("Delayed discharge between boards")
            )),
    tabItem(tabName = "rates",
            # need header
            fluidRow(
              h2("Delayed discharge rates")
            )),
    tabItem(tabName = "map",
            # need header
            fluidRow(
              h2("Delayed discharge map")
            ))))
)

server <- function(input, output, session) {
}
shinyApp(ui, server)
