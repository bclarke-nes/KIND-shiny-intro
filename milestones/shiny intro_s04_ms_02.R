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
