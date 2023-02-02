# UI session

library(pacman)
p_load(shiny, ggplot2, lubridate, glue)

datasets <- c("economics", "faithfuld", "seals")
animals <- c("Grant's gazelle", "Greavy's Zebra", "Chapman's Zebra", "Rothschild's giraffe")
ui <- fluidPage(
  h1("Bunch of input"),
  radioButtons("rb", "Choose one:",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  ), 
  textInput("name", "Your name", value=""),
  sliderInput("date", "This date", min=ymd("2000-01-01"), max=ymd("2050-12-31"), value=dmy("02/02/2023")),
  selectInput("state", "Choose a state:",
              list(`East Coast` = list("NY", "NJ", "CT"),
                   `West Coast` = list("WA", "OR", "CA"),
                   `Midwest` = list("MN", "WI", "IA"))
  ),
  checkboxGroupInput("animal", "What animals do you like?", animals),
  h1("Bunch of output"),
  textOutput("message"),
  textOutput("name"),
  textOutput("day")
)

server <- function(input, output, session) {
  output$message <- renderText({
    paste("Your mood is ", input$rb)})
  
  output$name <- renderText(glue("Your name is {input$name}, which contains {nchar(input$name)} characters."))
  
  output$day <- renderText(glue("You picked {input$date} which was a {wday(input$date, label=T, abbr=F)}"))
}

shinyApp(ui, server)
?sliderInput

