# ms 1 ----

library(pacman)
p_load(shiny, shinydashboard, tidyverse, plotly)
source("s04.R", local = TRUE)

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
  
  # icons are the free fontawesome set at https://fontawesome.com/search?m=free&o=r
  # personally icons are an under-documented pain. Other libraries are available too, but never seem to work properly.
  
  dashboardBody(tabItems(
    # intro tab
    tabItem(tabName = "introduction",
            # need header
            fluidRow(box(
              h2("Delayed discharge dashboard"),
              
              p(
                "This is an example dashboard that uses an R script to produce three interactive plots. Each show the total number of delayed discharge bed days by health board. The dashboard uses three data sources:"
              ),
              
              tags$div(tags$ul(
                tags$li(
                  tags$a(href = "https://www.opendata.nhs.scot/dataset/52591cba-fd71-48b2-bac3-e71ac108dfee/resource/fd354e4b-6211-48ba-8e4f-8356a5ed4215/", "PHS delayed discharge bed days by health board"),
                ),
                tags$li(
                  tags$a(href = "https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc", "PHS health board names and geography codes"),
                ),
                tags$li(
                  tags$a(href = "https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1", "PHS population estimates")
                )
              ))
              
              
            )),),
    
    # by board tab
    tabItem(
      tabName = "by_board",
      h2("Delayed discharges by board"),
      fluidRow(plotOutput("graph"),),
      fluidRow(box(
        title = "Controls",
        selectInput("data", "Pick a board:", unique(boards$HBName))
      ))
    ),
    
    # between board
    tabItem(
      tabName = "between_boards",
      h2("Comparing delayed discharges between boards"),
      fluidRow(plotOutput("between"),) ,
      fluidRow(
        box(
          title = "Board",
          checkboxGroupInput(
            "rate_board_select",
            "Pick a board:",
            unique(boards$HBName)[1:15],
            selected = "NHS Ayrshire and Arran"
          )
        ),
        box(
          title = "Age group",
          radioButtons(
            "rate_age_select",
            "Pick an age group:",
            unique(standardised_data$AgeGroup),
            selected = "18 plus"
          )
        ),
        box(
          title = "Date range",
          dateRangeInput(
            "date_range",
            "Pick a date range",
            start = min(data$MonthOfDelay),
            end = max(data$MonthOfDelay),
            min = min(data$MonthOfDelay),
            max = max(data$MonthOfDelay),
            startview = "decade",
            format = "MM yyyy"
          )
        )
      )
    ),
    
    # Rate tab content
    tabItem(
      tabName = "rates",
      h2("Comparing delayed discharge rate between boards"),
      fluidRow(box(
        p(
          "This graph plots the rate of delayed discharge by board. It uses board-level population data to calculate a rate per 100 000 that takes account of the differing demographics between different health boards. This allows better comparison of delayed discharge rates between boards. Note though that population data is only available until end-2021, and more recent data is not shown."
        )
      )),
      fluidRow(plotOutput("rates"),) ,
      fluidRow(
        box(
          title = "Board",
          checkboxGroupInput(
            "rate_select",
            "Pick a board:",
            unique(boards$HBName)[1:14],
            selected = "NHS Ayrshire and Arran"
          )
        ),
        box(
          title = "Age group",
          radioButtons(
            "age_select",
            "Pick an age group:",
            unique(standardised_data$AgeGroup),
            selected = "18 plus"
          )
        ),
        box(
          title = "Benchmark",
          checkboxInput("scot_nat_comp", "Scottish national data")
        )
      )
    ),
    
    tabItem(
      tabName = "map",
      h2("Mapping delayed discharge rates"),
      
      column(width = 9,
             box(plotlyOutput("map"), width = "100%"),),
      
      column(width = 3,
             fluidRow(
               box(
                 "This graph plots the rate of delayed discharge by board relative to the national mean for that month. It uses board-level population data to calculate a rate per 100 000 that takes account of the differing demographics between different health boards. This allows better comparison of delayed discharge rates between boards. Note though that population data is only available until end-2021, and more recent data is not shown. Green = less than national average, red = more than national average.",
                 width = 12
               )
               
             ), #fr
             fluidRow(
               box(
                 title = "Age group",
                 radioButtons(
                   "map_age_select",
                   "Pick an age group:",
                   unique(standardised_data$AgeGroup),
                   selected = "18 plus"
                 )
               ),
               
               box(
                 title = "Month",
                 dateInput(
                   "map_date",
                   "Pick a month:",
                   value = dmy("01/01/2019"),
                   format = "MM yyyy",
                   startview = "year"
                 )
               )
               
             ))
    )
    
  )),
  skin = "green"
  
)

server <- function(input, output, session) {

  isolate(source("s04.R", local=T))
  
  output$graph <- renderPlot(discharge_graph(input$data))
  
  output$between <- renderPlot(
    compare_boards(
      input$rate_board_select,
      input$rate_age_select,
      input$date_range
    )
  )
  
  output$rates <- renderPlot(
    stand_compare_boards(input$rate_select, input$age_select, scot = input$scot_nat_comp)
  )
  
  output$map <- renderPlotly({
    comp_map(input$map_date, input$map_age_select)
  })
  
}

shinyApp(ui, server)

# ms 2 ----
#little bit of test something