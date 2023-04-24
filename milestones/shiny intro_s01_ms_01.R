install.packages(setdiff("pacman", rownames(installed.packages())))
library(pacman)
p_load(shiny, shinydashboard, tidyverse, plotly, glue, NHSRdatasets) # loading all packages needed for training course

source_files <- c("../data/data.rds", "../data/boards.rds")

if(!all(file.exists(source_files))){
  source("..//R//s03_data.R", local = TRUE)
}
data <- read_rds(source_files[1])
boards <- read_rds(source_files[2])

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
