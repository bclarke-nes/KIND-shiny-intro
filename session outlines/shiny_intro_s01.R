# ms 1 ----
library(shiny)

ui <- fluidPage()

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# ms 2 ----
library(shiny)

ui <- fluidPage("Hello world", textOutput("message"))

server <- function(input, output, session) {
  output$message <- renderText("This is a Shiny thing")
}

shinyApp(ui, server)

# ms 3 ----
library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage("The mean number of attendances is: ", textOutput("mean_att"))

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  pull(attendances) %>%
                                  mean())
}

shinyApp(ui, server)

# ms 4 ----
library(pacman)
p_load(shiny, tidyverse)

ui <- fluidPage(
  "The mean number of attendances is: ",
  textOutput("mean_att"),
  plotOutput("att_period")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() +
      geom_smooth()
  )
}

shinyApp(ui, server)

# ms 5 ----
library(pacman)
p_load(shiny, tidyverse, lubridate)

ui <- fluidPage(
  "The mean number of attendances is: ",
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() +
      geom_smooth()
  )
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)