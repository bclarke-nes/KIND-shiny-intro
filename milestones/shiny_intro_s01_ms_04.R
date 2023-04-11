library(pacman)
p_load(shiny, tidyverse, NHSRdatasets)

ui <- fluidPage("The mean number of attendances is: ", textOutput("mean_att"))

server <- function(input, output, session) {
  output$mean_att <- renderText(ae_attendances %>%
                                  filter(org_code == "RF4") %>%
                                  pull(attendances) %>%
                                  mean())
}

shinyApp(ui, server)
