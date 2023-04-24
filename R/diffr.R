# diffr
library(pacman)
p_load(diffr, tidyverse, shiny)

milestone_files = list.files("..//milestones", full.names = T, pattern = "*.R")

ui <- fluidPage(
  fluidRow(column(
    12,
    HTML("<div style='height: 125px;'>"),
    imageOutput("header"),
    HTML("</div>")
  )),
  
  h1("KIND Introductory Shiny - milestone diffr"),
  
  checkboxInput("wordWrap", "Word Wrap", value = TRUE),
  
  fluidRow(column(
    6, selectInput("file1", "File 1", choices = basename(milestone_files))
  ),
  column(
    6, selectInput("file2", "File 2", choices = basename(milestone_files))
  )),
  fluidRow(column(12, diffrOutput("exdiff", width = '100%')))
)
server <- function(input, output, session) {
  output$header <- renderImage({
    list(src = "../src/images/KLN_banner_v05_125.png", contentType = 'image/png', height = '125px')},       deleteFile = FALSE)
  
  
  output$exdiff <- renderDiffr({
    diffr(
      paste0("..//milestones//", input$file1),
      paste0("..//milestones//", input$file2),
      wordWrap = input$wordWrap,
      before = input$file1,
      after = input$file2,
      width = "100%"
    )
  })
}

shinyApp(ui, server)
