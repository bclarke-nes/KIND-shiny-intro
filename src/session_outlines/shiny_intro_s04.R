# ms 1 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(dashboardHeader(),
                    dashboardSidebar(),
                    dashboardBody()
                    )

server <- function(input, output, session) {}
shinyApp(ui, server)

# ms 2 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", 
                  titleWidth = 350),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output, session) {
}
shinyApp(ui, server)


# ms 3 ----

library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", 
                  titleWidth = 350),
  dashboardSidebar(width = 350, 
                   collapsed = F),
  dashboardBody()
)

server <- function(input, output, session) {
}
shinyApp(ui, server)

# ms 4 ----

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

# ms 5 ----

library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", 
                  titleWidth = 350),
  dashboardSidebar(width = 350, 
                   collapsed = F, 
                   sidebarMenu(menuItem("Introduction", tabName = "introduction", icon = icon("info-circle")))),
  dashboardBody(tabItems(
    # intro tab
    tabItem(tabName = "introduction",
            # need header
            fluidRow(box(h2("Delayed discharge dashboard"))))))
)

server <- function(input, output, session) {
}
shinyApp(ui, server)

# ms 6 ----

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

# ms 7 ----

# app.R

source(here::here("ui.R"), local = T)
source(here::here("server.R"), local = T)

shinyApp(
  ui = ui,
  server = server
)

# ms 8 ----

# server.R

server <- function(input, output, session) {
  
}

# ms 9 ----

# ui.R

ui <- dashboardPage( ... )


# ms 10 ----

# server.R

server <- function(input, output, session) {
  
  isolate(source(here("R", "s04.R"), local = TRUE))
  
  output$discharge_graph <- renderPlot(
    discharge_graph(input$board)
  )
  
}


# ms 11 ----

# ui.R

... 

tabItem(
  tabName = "by_board",
  h2("Delayed discharges by board"),
  fluidRow(plotOutput("discharge_graph"),),
  fluidRow(box(
    title = "Controls",
    selectInput("data", "Pick a board:", unique(boards$HBName))
  ))
),

...

