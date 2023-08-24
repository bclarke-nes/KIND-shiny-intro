# ui.R
tabItem(
  tabName = "by_board",
  h2("Delayed discharges by board"),
  fluidRow(plotOutput("discharge_graph"),),
  fluidRow(box(
    title = "Controls",
    selectInput("data", "Pick a board:", unique(boards$HBName))
  ))
)
