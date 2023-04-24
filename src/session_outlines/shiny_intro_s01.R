## ms 1 ----

install.packages(setdiff("pacman", rownames(installed.packages())))
library(pacman)
p_load(shiny, shinydashboard, tidyverse, plotly, glue, NHSRdatasets, diffr, ggrepel, here) # loading all install.packages(setdiff("pacman", rownames(installed.packages())))
i_am("milestones/shiny intro_s01_ms_01.R")

source_files <- c(here("data", "data.rds"),
                  here("data", "boards.rds"),
                  here("data", "standardised_data.rds"),
                  here("data", "standardised_data_national.rds"))

source(here("R", "s03.R"))

ui <- dashboardPage(
  dashboardHeader(title = "Delayed discharge dashboard", titleWidth = 350),
  dashboardSidebar(width = 350, 
                   collapsed = F,
                   sidebarMenu(
                     menuItem("Comparing delayed discharge rate between boards", tabName = "rates", icon = icon("clinic-medical")))),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "rates",
              h2("Comparing delayed discharge rate between boards"),
              fluidRow(box(p("This graph plots the number of delayed discharge by board."))),
              fluidRow(
                plotOutput("rates"),
              ) ,
              fluidRow(
                box(
                  title = "Board",
                  radioButtons("rate_select", "Pick a board:", unique(boards$HBName)[1:14], selected="NHS Ayrshire and Arran")
                )
              )  
      )
    )
  ),
  skin = "green"
)

server <- function(input, output, session) {
  output$rates <- renderPlot(
    data %>%
      filter(HBName == input$rate_select) %>%
      ggplot() +
      geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup)) +
      ggtitle(glue("{input$rate_select} delayed discharge bed days")) +
      xlab("Month of delay") +
      ylab("Delayed discharge bed days") +
      scale_color_discrete(name = "Age group") +
      theme(plot.title = element_text(size=20),
            legend.title = element_text(size=20),
            legend.text = element_text(size=16))
  )
}

shinyApp(ui, server)

# ms 2 ----
library(shiny)

ui <- fluidPage()

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# ms 3 ----
library(shiny)

ui <- fluidPage("Hello world", textOutput("message"))

server <- function(input, output, session) {
  output$message <- renderText("This is a Shiny thing")
}

shinyApp(ui, server)

# ms 4 ----
library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage("The mean number of attendances per period is: ", textOutput("mean_att"))

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == "RF4") %>%
                                  pull(attendances) %>%
                                  mean())
}

shinyApp(ui, server)

# ms 5 ----
library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage(
  "The mean number of attendances per period is: ",
  textOutput("mean_att"),
  plotOutput("att_period")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == "RF4") %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == "RF4") %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() 
  )
}

shinyApp(ui, server)

# ms 6 ----
library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)

ui <- fluidPage(
  "The mean number of attendances per period is: ",
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == "RF4") %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == "RF4") %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line()
  )
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == "RF4") %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)

# ms 7 ----
library(pacman)
p_load(shiny, tidyverse, NHSRdatasets, lubridate)
orgs <- c("RF4", "R1H", "RQM") 

ui <- fluidPage(
  radioButtons("org_code", "Pick an org", choices=orgs, selected=orgs[1]),
  "The mean number of attendances per period is: ",
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == input$org_code) %>%
                                  pull(attendances) %>%
                                  mean())
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      filter(org_code == input$org_code) %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line()
  )
  
  output$att_months <- renderDataTable(ae_attendances %>%
                                         filter(org_code == input$org_code) %>%
                                         group_by(year = year(period)) %>%
                                         summarise(attendances = sum(attendances)))
}

shinyApp(ui, server)