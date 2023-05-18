## Session learning outcomes

+ working towards the final app
  + `shinydashboard` menu and sections
  + thinking about project architecture
  + adding s3 functions to dashboard sections
  + tweaks, tidying up, and story-telling

  
## `shinydashboard` menu and sections
  
+ Let's start with a minimal shinydashboard `ui()`

(MILESTONE 1)

## `shinydashboard` `ui()`

We'll add some elements to the page to allow us to show off the other graphs we drew last time.

+ `dashboardHeader()` first
  + add a `title = "whatever you like"`
  + optional `titleWidth` argument to preserve long titles
  + run app and check output

(MILESTONE 2)

## `shinydashboard` `ui()`

+ lots of extra options too - drop-down menu example from `?dashboardHeader`

![](../src/images/menu.png){fig-align="center"}

## `dashboardSidebar()`

This is a bit more complicated than the header, because we need to add some navigation options here.

+ prep work
  + set a `width =`, ideally corresponding with the `titleWidth` value from `dashboardHeader`
  + `collapsed` TRUE/FALSE *au choix*
+ then add `sidebarMenu()`

(MILESTONE 3)

## `menuItem()`

We then need to add a `menuItem()` inside the `sidebarMenu()` which will contain:
  + a tab title, for display in the menu
  + `tabName = ` - corresponding to one of the pages that we'll set up next
  + `icon = icon("icon name")` (try `info-circle`)

(MILESTONE 4)

## Icons...
+ really useful for dashboards, but poorly documented
+ simple cases (like this one), supply a fontawesome icon name inside `icon()`
  + e.g. `icon("info-circle")` becomes 
  
```{r}
#| echo: false
#| eval: true
shiny::icon("info-circle")
```
see src/shiny_icons.qmd

## `dashboardBody()`

Now we need to add some content for our introduction tab.

+ `dashboardBody()` containing
  + `tabItems()` containing
    + `tabItem()` containing
      + `tabName = "something"`
      + our page content

(MILESTONE 5)

(MILESTONE 6)

## Architecture

This is all getting very long, even without any actual content in our pages.

+ Let's split the files up:
  + app.R
  + server.R
  + ui.R

## app.R

+ this `sources()` the server and ui from their files
+ then starts the shiny server

(MILESTONE 7)

## server.R

+ this contains our `server()` code
+ we can also e.g. `source()` external scripts

(MILESTONE 8)

## ui.R

+ this contains our `ui()` code
+ again, can bring in external code if we don't need it to be reactive

(MILESTONE 9)

## Please add your UI

...then test your app (from app.R)

## adding our functions to the dashboard

+ we should now be able to add code to server.R from last session

+ R/s04.R = updated version of the scripts we were working on last time
+ let's test `discharge_graph`. We'll need to add to server.R:

(MILESTONE 10)

...and we'll need to add to ui.R...

(MILESTONE 11)

## Building out the board

+ 3 more functions to add in the same way
  + `compare_boards` to compare DD counts by board
  + `stand_compare_boards` to compare standardised DD rates by board
  + `comp_map` to plot a simple map of standardised rates
  
That brings us fairly close to the finished article...

<!-- something here to fill -->












