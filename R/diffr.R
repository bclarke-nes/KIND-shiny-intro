# diffr
library(pacman)
p_load(diffr, tidyverse, shiny)

filez = list.files("..//milestones", full.names=T, pattern="*.R")

ui <- fluidPage(
  h1("KIND Shiny intro - diffr"),
  tags$img(src='./images/diffr.png'),
  
  checkboxInput("wordWrap", "Word Wrap",
                value = TRUE),
  selectInput("file1", "File 1", choices=basename(filez)),
  selectInput("file2", "File 2", choices=basename(filez)),
  diffrOutput("exdiff",  width = "100%")
)
server <- function(input, output, session) {
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

