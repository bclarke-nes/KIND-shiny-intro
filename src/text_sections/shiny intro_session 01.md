## Before we start

+ [pre-session evaluation](https://forms.office.com/e/zm56W304SH)
+ this is the start of a journey, not a destination

## About this course

::: {.incremental}
- an accessible introduction to Shiny
- it assumes basic familiarity with R and Posit/Rstudio
- aimed at users in health, social care, and housing
- it's social, so we'll all learn together
  - it's not just going to be me talking
- it's practical, so we'll all work through the material together
  - we don't record the sessions - they're meant to be taken live
- please be ready to share your problems or mistakes 
  - they're the most effective way to learn
  - we'll solve problems together
:::

## About this course

:::: callout-important
+ please keep your camera on as much as you can
+ please interrupt, ask questions, etc
+ please try the tasks
+ please share your mistakes
::::

## Session 1 outline
1. getting started with Posit
2. 5 minute introduction to Shiny
3. dashboard demo 
4. R vs Shiny
5. `app.R` / "hello world"
6. `input$x` / `output$x` syntax
7. graphs and data tables
8. interactivity

## Session milestones
1. dashboard demo
2. app.R
3. hello world
4. `input$x` / `output$x` syntax
5. add a graph
6. add a data table
7. first interactivity

## Helpful resources
+ [Posit Cheatsheet](https://posit.co/wp-content/uploads/2022/10/rstudio-ide-1.pdf)
+ [Shiny Cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)
+ [Mastering Shiny](https://mastering-shiny.org/index.html)

## Set-up
1. Log-in to Posit Cloud
2. Create a new project from this URL: [https://github.com/bclarke-nes/KIND-shiny-intro](https://github.com/bclarke-nes/KIND-shiny-intro)

## What's Shiny

+ R package for interactive, web-based, app development
+ Example applications:
  + real-time dashboards
  + interactive tools
  + self-service data portal
  + data-driven web apps (e.g. allowing users to upload and process data)

+ Health and social care examples
  + [PHS ScotPHO](https://scotland.shinyapps.io/ScotPHO_profiles_tool/)
  + [NTI dashboard](https://scotland.shinyapps.io/nhs-prescribing-nti/)
  
## Deploying Shiny
+ Run dashboards locally 
+ Share code for local use
+ Share code more widely (e.g. [revtools](https://revtools.net/) package)
* Publish apps:
  * via open SaaS platforms, like [shinyapps.io](https://www.shinyapps.io/)
  * Dedicated platforms via Shiny server, SPACe Analytical Workbench...

. . .

::: {.callout-tip}

Great primer on deploying Shiny: [Rstudio Shiny tutorial](https://shiny.rstudio.com/tutorial/written-tutorial/lesson7/)

:::

  
## Dashboard demo

![](../src/images/dd_preview.png){fig-align="center"}

(MILESTONE 01)

## A word of warning

+ Shiny code looks much more complicated than most R code
+ That means that we'll work with simplified examples in these sessions
+ That's something to be wary about, because there might be a gap between the simplified version, and what you encounter when you build your own products
  + We'll explore a more true-to-life example in the final session
  + Please consider joining the follow-up development groups
  
## R vs Shiny

::: {.callout-warning}

While Shiny's syntax looks very similar to R, the programming approach is totally different.

:::

. . .

+ R is usually **imperative** - "do the following things in this order..."
+ Shiny is **declarative** - "here are our goals and constraints..." 

. . .

> With imperative code you say “Make me a sandwich”. With declarative code you say “Ensure there is a sandwich in the refrigerator whenever I look inside of it”. Imperative code is assertive; declarative code is passive-aggressive.

[Mastering Shiny ch. 3](https://mastering-shiny.org/basic-reactivity.html#imperative-vs-declarative-programming)

## First steps

1. Create a new (empty) file called `app.R`
2. click in the source pane, and start typing `Shiny`...

. . .

![](..//src//images//image-2077227059.png){fig-align="center"}


(MILESTONE 02)

(MILESTONE 03)

. . .

+ Note the `output$message` - this is how we pass the body of the message to the `textOutput` part of the UI

. . .

::: {.callout-tip}

`ctrl`+`shift`+`enter` to run your app

:::


## `diffr`

![](../src/images/diffr.png){fig-align="center"}

## Anatomy of a Shiny app

We need at least three elements for a Shiny app:

1. UI - containing the code for the front-end user interface
2. Server - containing the code for the back-end (e.g. plotting graphs etc)
3. Call to `shinyApp` - that launches the app

. . .

These can be split into separate files, or contained in one `app.R` script. We'll start with the single file for now, but will start to split things up as our scripts grow.

## Function pairs

Reactivity uses pairs of functions to pass things (user input, graphs, text) between server and UI

+ `input$x` and `output$x` syntax


(MILESTONE 04)

+ `renderText` to pass the output of the standard R code lines 7-10 to `output$mean_att`
+ `textOutput("mean_att")` to insert that output in the UI. 
+ `inline=T` keeps text inline

## Add a graph

Let's try adding a different element

+ delete everything inside `fluidPage()`
+ add `plotOutput()` to the UI
+ add `"att_period"` inside `plotOutput()`
+ delete everything inside `server()`'s curly brackets
+ add `renderPlot()` to the server, assigned to `output$att_period`
+ add some code inside `renderPlot()` - suggestion ahoy
. . .

## Code snippet inside the `renderPlot()`

```{r}
ae_attendances %>%
      group_by(period) %>%
      summarise(attendances = sum(attendances)) %>%
      ggplot(aes(x = period, y = attendances)) +
      geom_line() +
      geom_smooth()
```

(MILESTONE 05)

## Add a data table

Let's follow the same process again to try adding a data table:

+ scrub out the `fluidPage()` and `server()`
+ add `dataTableOutput()` and `renderDataTable()` to the right places
+ add some code generating a table of data (again, suggestion ahead)

## Code snippet inside `renderDataTable()`

```{r}
ae_attendances %>%
     filter(org_code == "RF4") %>%
     group_by(year = year(period)) %>%
     summarise(attendances = sum(attendances))
```

(MILESTONE 06)



## Exercise

1. Please start a new Shiny (use the snippet!)
2. using mtcars or whatever data you fancy, please make:
    1. a numeric summary of something
    2. a graphical summary of something
    3. a tabular summary of something
3. see if you can recall how to add these to your shiny
    1. `🤷Output()` in the UI
    2. `render🤷()` in the server

## User input

+ this is all very static. Let's try to add some interactivity...
+ there are many ways to collect user input in Shiny
+ let's allow users to choose an org
+ we'll need to add three things:

. . .

+ a vector of orgs for the user to choose from
+ `radioButtons()` function in the `ui()`
+ an update to the `server()` to capture the chosen org

## orgs
Add the vector in the head of your `app.R`: 

```{r}
orgs <- c("RF4", "R1H", "RQM")
```

## `radioButtons()` UI

Here's (part) of the man page for `radioButtons()`

```{r}
radioButtons(
  inputId,
  label,
  choices = NULL,
  selected = NULL)
```

We'll need to add:

+ `inputId` = what our app will call the input. Use `org_code`
+ `label` = what our user will see as the input name. Use whatever you like!
+ `choices` = the choices available. Use `orgs`
+ `selected` = the default selection. Use `orgs[1]` to default select the first item.

## `radioButtons()` server

We need to make the same change three times in `server()`. Each of our three `renderSomething()` functions currently have a line filtering the data for RF4:

```{r}
filter(org_code == "RF4") %>%
```

We need to change that to filter on `input$org_code`

```{r}
filter(org_code == input$org_code)
```

::: {.callout-note}
Don't forget to run your app
:::

(MILESTONE 07)

## Next time!

+ adding extra user input elements
+ doing more interesting things with our R code
+ building out some dashboard-like examples

<!-- secret sauce -->
