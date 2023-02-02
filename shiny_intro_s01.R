# like R - general syntax, packages
# unlike R - reactive, interactive, UI

# this session aims: familiarisation, terminology, R vs Shiny
# milestones, app.R, hello world, displaying some R output, bring data into Shiny, adding interactivity, first reactivity
# reading: https://mastering-shiny.org/basic-app.html mastering shiny chapter 1, https://shiny.rstudio.com/images/shiny-cheatsheet.pdf

# welcome and troubleshooting ----

# app.R ----
#create a new file and add shiny boilerplate from snippet. Anatomy - ui, server, shinyApp

library(shiny)

ui <- fluidPage(

)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# hello world - introduce input$x output$x ----

library(shiny)

ui <- fluidPage(
  "Hello world", textOutput("message")
)

server <- function(input, output, session) {
  output$message <- renderText("This is a Shiny thing")
}

shinyApp(ui, server)

# add some (static) R part 1 ----

library(pacman)
p_load(shiny, tidyverse,NHSRdatasets)

ui <- fluidPage(
  "The mean number of attendances is: ", textOutput("mean_att")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(
    ae_attendances %>%
      pull(attendances) %>%
      mean()
    )
}

shinyApp(ui, server)

# add some (static) R part 2 ----

library(pacman)
p_load(shiny, tidyverse)

ui <- fluidPage(
  "The mean number of attendances is: ", 
  textOutput("mean_att"),
  plotOutput("att_period")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(
    ae_attendances %>%
      pull(attendances) %>%
      mean()
  )
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x=period, y=attendances)) +
      geom_line() +
      geom_smooth()
  )
}

shinyApp(ui, server)

# add some (static) R part 3 ----

library(pacman)
p_load(shiny, tidyverse, lubridate)

ui <- fluidPage(
  "The mean number of attendances is: ", 
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(
    ae_attendances %>%
      pull(attendances) %>%
      mean()
  )
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x=period, y=attendances)) +
      geom_line() +
      geom_smooth()
  )
  
  output$att_months <- renderDataTable(
    ae_attendances %>%
      group_by(year = year(period)) %>%
      summarise(attendances=sum(attendances))
  )
}

shinyApp(ui, server)

# add interactivity 1----
# add column selection to UI

library(pacman)
p_load(shiny, tidyverse, lubridate)

col_names <- ae_attendances %>%
  select(where(is.numeric)) %>%
  names()

ui <- fluidPage(
  radioButtons("cols", label="Select a column", choices=col_names), 
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(
    ae_attendances %>%
      pull(attendances) %>%
      mean()
  )
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x=period, y=attendances)) +
      geom_line() +
      geom_smooth()
  )
  
  output$att_months <- renderDataTable(
    ae_attendances %>%
      group_by(year = year(period)) %>%
      summarise(attendances=sum(attendances))
  )
}

shinyApp(ui, server)

# add interactivity 2----
# do something with that column

library(pacman)
p_load(shiny, tidyverse, lubridate)

col_names <- ae_attendances %>%
  select(where(is.numeric)) %>%
  names()

ui <- fluidPage(
  radioButtons("cols", label="Select a column", choices=col_names), 
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  output$mean_att <- renderText(
    ae_attendances %>%
      pull(input$cols) %>%
      mean()
  )
  
  output$att_period <- renderPlot(
    ae_attendances %>%
      group_by(period) %>%
      summarise(!!input$cols := sum(.data[[input$cols]])) %>%
      ggplot(aes(x=period, y=.data[[input$cols]])) +
      geom_line() +
      geom_smooth()
  )
  
  output$att_months <- renderDataTable(
    ae_attendances %>%
      group_by(year = year(period)) %>%
      summarise(!!input$cols:=sum(.data[[input$cols]]))
  )
}

shinyApp(ui, server)

# reactivity ----
# all three outputs depend on the same data. We can speed things up by just evaluating the selected column once, and then using that in each of the three outputs. This is called reactivity.
library(pacman)
p_load(shiny, tidyverse, lubridate)

col_names <- ae_attendances %>%
  select(where(is.numeric)) %>%
  names()

ui <- fluidPage(
  radioButtons("cols", label="Select a column", choices=col_names), 
  textOutput("mean_att"),
  plotOutput("att_period"),
  dataTableOutput("att_months")
)

server <- function(input, output, session) {
  
  at_att_data <- reactive({
    ae_attendances %>%
      select(period, .data[[input$cols]])}
  )
  
  output$mean_att <- renderText(
    at_att_data() %>%
      pull(input$cols) %>%
      mean()
  )
  
  output$att_period <- renderPlot(
    at_att_data() %>%
      group_by(period) %>%
      summarise(!!input$cols := sum(.data[[input$cols]])) %>%
      ggplot(aes(x=period, y=.data[[input$cols]])) +
      geom_line() +
      geom_smooth()
  )

  output$att_months <- renderDataTable(
    at_att_data() %>%
      group_by(year = year(period)) %>%
      summarise(!!input$cols:=sum(.data[[input$cols]]))
  )
}

shinyApp(ui, server)


# end-session code ----

ui <- fluidPage(
  # can access stuff from R here
  selectInput("dataset", label = "Dataset", choices = ls("package:NHSRdatasets")),
  numericInput("rows", label = "How many rows?", value = 5),
  verbatimTextOutput("summary"),
  tableOutput("table"),
  plotOutput("histogram")
  
)

server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:NHSRdatasets")
    summary(dataset)
    })
  
output$table <- renderTable({
  dataset <- get(input$dataset, "package:NHSRdatasets")
  slice(dataset, 1:input$rows)
})

output$histogram <- renderPlot({
  get(input$dataset, "package:NHSRdatasets") %>%
    select(where(is.numeric)) %>%
    pivot_longer(everything()) %>%
    group_by(name) %>%
    ggplot() +
    geom_histogram(aes(x=value, fill=name)) +
    facet_wrap(~name, nrow=1, scales="free") +
    theme(legend.position = "none")
})
}

shinyApp(ui, server)
