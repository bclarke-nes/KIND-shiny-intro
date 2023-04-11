## About this course
+ An accessible introduction to Shiny
+ Interactive
  + Cameras on as much as possible, please
+ Collaborative, particularly for troubleshooting
+ Assumes basic familiarity with R and Posit/Rstudio

## Set-up
Please make a new empty project in Posit

### Helpful resources
+ [Shiny Cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
+ [Mastering Shiny](https://mastering-shiny.org/index.html)

## This session
+ basic functions
+ R vs Shiny
+ reactive programming
+ milestones
  + app.R
  + hello world
  + displaying R output
  + adding interactivity
  + first reactivity
  
## What's Shiny?

* R package for interactive, web-based, app development

* Health and social care examples
  + [PHS ScotPHO](https://scotland.shinyapps.io/ScotPHO_profiles_tool/)
  + [NTI dashboard](https://scotland.shinyapps.io/nhs-prescribing-nti/)
  
* Quick demo: `shiny_intro_s01_demo.R`

(MILESTONE 01)

## Shiny vs R (1)

::: {.callout-warning}

The syntax used in Shiny is very similar to R. But the programming approach is totally different.

:::

R is usually **imperative** - "do the following things in this order..."

Shiny is **declarative** - "here are our goals and constraints..." 

> With imperative code you say “Make me a sandwich”. With declarative code you say “Ensure there is a sandwich in the refrigerator whenever I look inside of it”. Imperative code is assertive; declarative code is passive-aggressive.

[Mastering Shiny ch. 3](https://mastering-shiny.org/basic-reactivity.html#imperative-vs-declarative-programming)

## What can you do with Shiny?
* Share code for local use
* Publish apps:
  * Open SaaS platform: https://www.shinyapps.io/
  * Dedicated platforms via Shiny server, SPACe Analytical Workbench...

::: {.callout-tip}

### An excellent primer on deploying Shiny

[Rstudio Shiny tutorial](https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/)

:::

(MILESTONE 02)

![](..//images//image-2077227059.png){fig-align="center"}

(MILESTONE 03)

Note the `output$message` - this is how we pass the body of the message to the `textOutput` part of the UI

## Anatomy of a Shiny app

1. UI
2. Server
3. Call to `shinyApp`

One file or several?

## Shiny vs R (2)
+ reactive
+ interactive
+ UI and server parts
  + `input$x` and `output$x` syntax
  + pairs of functions to pass things (graphs, text) between server and UI 

(MILESTONE 04)

+ `renderText` to pass the output of the standard R code lines 10-12 to `output$mean_att`
+ `textOutput("mean_att")` to insert that output in the UI. `container=span` keeps text inline

(MILESTONE 05)

+ `renderPlot` to pass the graph to `plotOutput`

(MILESTONE 06)

something else here


