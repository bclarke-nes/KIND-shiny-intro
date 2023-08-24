# ms 1 ----

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

# ms 2 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(dashboardHeader(),
                    dashboardSidebar(),
                    dashboardBody()
                    )

server <- function(input, output, session) {}
shinyApp(ui, server)

# ms 3 ----
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



# ms 7 ----

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


# ms 7 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- dashboardPage(dashboardHeader(),
                    dashboardSidebar(),
                    dashboardBody(fluidRow(
                      valueBox(Sys.Date(), "Today's date", icon = icon("calendar-days")),
                      valueBoxOutput("monthalert")
                    ))
)

server <- function(input, output, session) {
  # figure out number of days remaining in the month and format a nice string
  days_left <-
    paste(as.numeric(difftime(
      lubridate::ceiling_date(Sys.Date(), "month"),
      Sys.Date(),
      units = "days"
    )), "days remaining")
  
  output$monthalert <- renderValueBox(
    
    valueBox(days_left, "Month end alert", color="fuchsia", icon = icon("fire"))
  )
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



# ms 99 ----

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
tabItem(
  tabName = "by_board",
  h2("Delayed discharges by board"),
  fluidRow(plotOutput("discharge_graph"),),
  fluidRow(box(
    title = "Controls",
    selectInput("data", "Pick a board:", unique(boards$HBName))
  ))
)

