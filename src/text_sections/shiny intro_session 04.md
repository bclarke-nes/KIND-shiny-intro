## Session learning outcomes

+ `shinydashboard` menu and sections
+ adding those new functions as pages in our dashboard
+ tweaks, tidying up, and story-telling
+ thinking about project architecture

## `shinydashboard` menu and sections
  
+ Let's look again at the `ui()` that we had at the end of the last session

(MILESTONE 1)

## `shinydashboard` `ui()`
+ we'll add some elements to the page to allow us to show off the other graphs we drew last time. First, add some content to `dashboardHeader()`
  + add a `title = "whatever you like"`
  + optional `titleWidth` argument to preserve long titles

## `dashboardSidebar()`
+ set a `width =`, ideally corresponding with the `titleWidth` value from `dashboardHeader`
+ `collapsed` TRUE/FALSE *au choix*
+ `sidebarMenu()`
  + 5 x `menuItem()`s, each containing:
    + a tab title, for display
    + `tabName = ` tab name
    + `icon = icon("icon name")`
    
## Icons...
+ really useful for dashboards, but poorly documented
+ simple cases (like this one), supply a fontawesome icon name inside `icon()`
  + e.g. `icon("info-circle")` becomes 

```{r}
#| echo: false
#| eval: true
shiny::icon("info-circle")
```



(MILESTONE 2)

(MILESTONE 3)

(MILESTONE 4)

<!-- something here to stop the qmd from NAing -->