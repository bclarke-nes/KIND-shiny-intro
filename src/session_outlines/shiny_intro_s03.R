# ms 1 ----
library(pacman)
p_load(shiny)

ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}


shinyApp(ui, server)

# ms 2 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody()
  )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# ms 3 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
      h2("A useful heading"),
      box("Some explanatory text")
    )
  )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# ms 4 ----
library(pacman)
p_load(tidyverse, lubridate, glue, ggrepel)

# data loading and processing ----
# this script will either read processed data from rds files, or create them using s03_data.R if they do not exist
# it then contains functions to produce the graphs used in the session 3 and session 4 dashboards

source_files <- c("data/data.rds", "data/boards.rds", "data/standardised_data.rds", "data/standardised_data_national.rds")

if(all(file.exists(source_files))){
  
  data <- read_rds("data/data.rds")
  boards <- read_rds("data/boards.rds")
  standardised_data <- read_rds("data/standardised_data.rds")
  standardised_data_national <- read_rds("data/standardised_data_national.rds")
  
} else {
  source("data/s03_data.R")
  data <- read_rds("data/data.rds")
  boards <- read_rds("data/boards.rds")
  standardised_data <- read_rds("data/standardised_data.rds")
  standardised_data_national <- read_rds("data/standardised_data_national.rds")
}

# ms 5 ----

data %>%
  filter(HBName == "NHS Borders") %>%
  ggplot() +
  geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup))

# ms 6 ----
discharge_graph <- function(board) {

}

# ms 7 ----
discharge_graph <- function(board) {
  data %>%
    filter(HBName == board) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup))
}

# ms 8 ----
discharge_graph <- function(board) {
  # single board values
  # note that we don't need to do any fancy data masking here to pass the arguments
  
  data %>%
    filter(HBName == board) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=AgeGroup)) +
    ggtitle(glue("{board} delayed discharge bed days")) +
    xlab("Month of delay") +
    ylab("Delayed discharge bed days") +
    scale_color_discrete(name = "Age group") +
    theme(plot.title = element_text(size=20),
          legend.title = element_text(size=20),
          legend.text = element_text(size=16))
  
}


# ms 9 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
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
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# ms 10 ----
library(pacman)
p_load(shiny, shinydashboard)

ui <- fluidPage(
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
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
  
)

server <- function(input, output, session) {
  isolate(source("R/s03.R", local = TRUE))
  
  output$graph <- renderPlot(
    discharge_graph(input$board)
  )
}

shinyApp(ui, server)

# ms 11 ----

compare_boards <- function(boards, age, date_range=c(dmy("01/07/2016"), dmy("01/01/2023"))) {
  
  start <- date_range[1]
  end <- date_range[2]
  
  data %>%
    filter(HBName %in% boards) %>%
    filter(AgeGroup == age) %>%
    ggplot() +
    geom_line(aes(x=MonthOfDelay, y=Total, color=HBName)) +
    ggtitle(glue("Delayed discharge bed days comparison for age group {age}")) +
    xlab("Month of delay") +
    ylab("Delayed discharge bed days") +
    scale_color_discrete(name = "Health boards")  +
    theme(plot.title = element_text(size=20),
          legend.title = element_text(size=20),
          legend.text = element_text(size=16)) +
    xlim(start, end)
  
}

# ms 12 ----

stand_compare_boards <- function(boards, age, scot=FALSE) {
  
  comparison <- standardised_data_national %>%
    filter(AgeGroup == age) %>%
    filter(!is.na(rate))
  
  #damn labels (board data)
  labels <- standardised_data %>%
    filter(AgeGroup == age)  %>%
    filter(HBName %in% boards) %>%
    filter(!is.na(rate)) %>%
    group_by(HBName)%>%
    summarise(month = mean(MonthOfDelay), rate=mean(rate))
  
  #damn damn labels (board data)
  nat_label_height <- comparison %>%
    pull(rate)
  
  nat_label_height <- mean(nat_label_height, na.rm=T)
  
  if(scot==FALSE) {
    
    standardised_data %>%
      filter(HBName %in% boards) %>%
      filter(AgeGroup == age) %>%
      filter(!is.na(rate)) %>%
      ggplot() +
      geom_line(aes(x=MonthOfDelay, y=rate, color=HBName), alpha=0.9) +
      geom_label_repel(data = labels, aes(x=month, y=rate, color=HBName, label=HBName), alpha=0.9) +
      ggtitle(glue("Delayed discharge bed days, standardised per capita")) +
      theme(legend.position = "none", 
            plot.title = element_text(size=20)) +
      xlab("Month of delay") +
      ylab("Standardised delayed discharge rate, bed days per 100,000 population") 
    
  } else {
    standardised_data %>%
      filter(HBName %in% boards) %>%
      filter(AgeGroup == age) %>%
      filter(!is.na(rate)) %>%
      ggplot() +
      geom_line(
        data = comparison,
        aes(x = MonthOfDelay, y = rate),
        color = "dimgray",
        linewidth = 1,
        show.legend = "National average"
      ) +
      geom_label(data = comparison, aes(
        x = dmy("01-09-2021"),
        y = nat_label_height,
        label = HBName
      )) +
      geom_line(aes(x=MonthOfDelay, y=rate, color=HBName), alpha=0.9) +
      geom_label_repel(data = labels, aes(x=month, y=rate, color=HBName, label=HBName), alpha=0.9) +
      ggtitle(glue("Delayed discharge bed days, standardised per capita")) +
      theme(legend.position = "none", 
            plot.title = element_text(size=20)) +
      xlab("Month of delay") +
      ylab("Standardised delayed discharge rate, bed days per 100,000 population") 
    
  }
}

# ms 13 ----
comp_map <- function(month_r, age = "18 plus", comp = "National") {
  
  month <- floor_date(month_r, unit = "month")
  comp_str <- paste0(comp)
  
  if (length(comp) == 1 && comp == "National") {
    comparator <- standardised_data_national %>%
      ungroup() %>%
      filter(AgeGroup == age) %>%
      filter(MonthOfDelay == month) %>%
      filter(!is.na(rate)) %>%
      select(MonthOfDelay, comp_rate = rate)
  } else {
    comparator <- standardised_data %>%
      filter(HBName %in% comp) %>%
      ungroup() %>%
      filter(AgeGroup == age) %>%
      filter(MonthOfDelay == month) %>%
      filter(!is.na(rate)) %>%
      group_by(MonthOfDelay) %>%
      mutate(
        ddtotal = sum(Total),
        ddpopn = sum(Popn),
        comp_rate = 10e4 * ddtotal / ddpopn
      ) %>%
      select(MonthOfDelay, comp_rate) %>%
      distinct()
  }
  
  df <- standardised_data %>%
    filter(HBName != "National") %>%
    filter(MonthOfDelay == month) %>%
    filter(AgeGroup == age) %>%
    filter(!is.na(rate)) %>%
    left_join(comparator) %>%
    mutate(comparative_rate = rate / comp_rate)
  
  Scot_HB <- read_rds("data/Scot_HB.RDS")
  
  ggplotly(Scot_HB %>%
             left_join(df, by = c("id_json" = "HB")) %>%
             ggplot() +
             geom_polygon(aes(
               x = long,
               y = lat,
               group = group,
               fill = comparative_rate
             )) +
             theme_void() +
             coord_sf(default_crs = sf::st_crs(4326)) +
             labs(fill = "") +
             scale_fill_gradientn(colours = c("green", "lightgrey", "red")) +
             theme(legend.position = "bottom",
                   panel.background = element_rect(fill='transparent'), # to set transparent background
                   plot.background = element_rect(fill='transparent', color=NA),
                   legend.background = element_rect(fill='transparent'),
                   legend.box.background = element_rect(fill='transparent')) +
             
             labs(title = glue("Relative delayed discharge, {month}, for the {age} age group"),
                  subtitle = glue("Compared to {comp_str} data")))
  
}



