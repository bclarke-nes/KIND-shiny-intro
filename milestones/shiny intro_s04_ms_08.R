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
