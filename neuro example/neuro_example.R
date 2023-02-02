#app.R

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(pacman)
p_load(shiny, tidyverse, readxl, writexl, hrbrthemes, forcats, gghighlight, glue, geojsonio, broom, viridis, mapproj, sf, PostcodesioR, stringr, openxlsx)

# Define UI for application that draws a histogram

hscp_rates<- readRDS("data/hscp_rates.RDS")
# calculates the rates by count * 10000 / population
Scot_LAD_hscp <- readRDS("data/Scot_LAD_hscp.RDS")

ordered <- hscp_rates %>%
  group_by(Condition) %>%
  summarise(mean = mean(Rate, na.rm=T)) %>%
  arrange(desc(mean)) %>%
  pull(Condition)

hscps <- hscp_rates %>%
  distinct(HSCP) %>%
  pull()

# conditions <- c("Migraine", "Acquired brain injury (Trauma)", "Peripheral Neuropathy (Mechanical causes)", "Acquired brain injury (Vascular)", "Epilepsy", "Peripheral Neuropathy (Other)", "Acquired brain injury (Infection)")

ui <- fluidPage(
  
  # Application title
  titlePanel("Scottish prevelence neurology"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width=2,
           selectInput("flavour",
                  "Condition:",
                  choices=ordered,
                  selected = "Migraine"),
           selectInput("locale",
                   "Highlight location:",
                   choices=hscps,
                   selected = "Angus")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(width=10, 
      # splitLayout(
                  #plotOutput("distPlot"), 
                  plotOutput("distPlot2")
      # )

    )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$distPlot <- renderPlot({
    
   filter <- input$flavour
   locale <- input$locale
    
   neuro_plot <- function(col) {
     
     # this is for the highlighted graph for Dundee  / whole of Scotland
     
       hscp_rates %>%
         filter(Condition == {{col}}) %>%
         ggplot(aes(y = fct_reorder(HSCP, -Rate), x=Rate)) +
         geom_segment(aes(yend = HSCP, xend = 0), color = "brown", size=3) +
         geom_point(size = 3, color = "brown") +
          theme_minimal() +
         ylab("HSCP") +
         xlab("Rate per 10,000 registered patients") +
         labs(title = glue("{col} prevalance rate"))  +
         # theme(plot.title = element_text(hjust = 0.5)) +
         gghighlight(HSCP == {{locale}} | HSCP == "Whole of Scotland", unhighlighted_params = list(color="#69b3a2"))
     
   }
    neuro_plot(filter)})
  
  
  output$distPlot2 <- renderPlot({
    
    filter <- input$flavour
    
    neuro_plot_map <- function(col) {
      
     values_data <- hscp_rates %>%
        filter(Condition == {{col}}) %>%
        rename(HIAName = HSCP) 
      
      Scot_LAD_hscp %>%
          left_join(values_data, on=HIAName, keep=F) %>%
          ggplot() +
          scale_fill_viridis(na.value="#dddddd") +
          geom_polygon(aes( x = long, y = lat, group=group, fill=Rate)) +
          theme_void() +
          coord_sf(default_crs = sf::st_crs(4326)) +
          theme(legend.position = "bottom") +
          labs(fill="")
      
      
    }
    
    neuro_plot_map(filter)}, height = 800)
  
}

shinyApp(ui, server)



