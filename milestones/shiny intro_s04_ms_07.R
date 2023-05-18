# app.R

source(here::here("ui.R"), local = T)
source(here::here("server.R"), local = T)

shinyApp(
  ui = ui,
  server = server
)
