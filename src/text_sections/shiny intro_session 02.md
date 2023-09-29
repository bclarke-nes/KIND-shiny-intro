
## Session learning outcomes

+ consolidate session one
  + Shiny structure
  + function pairs (`render🤷()` and `🤷Output()`)
  + input options
+ extend those skills across `ui()` and `server()` 
  + additional input selections
  + more powerful reactivity
  + more ambitious R code in `server()`

## adding more interactivity

Let's start again with an empty Shiny app. During this session, we'll build this into a mini-dashboard that:

+ uses `ae_attendances`
+ allows us to plot time trends of attendances between organisations
+ includes a national average benchmark
+ and uses several kinds of interactivity

## about ae_attendances

```{r}
#| echo: false
#| eval: true
library(pacman)
p_load(NHSRdatasets, tidyverse)
ae_attendances |>
  slice(1:5) |>
  knitr::kable()

```

## about ae_attendances

```{r}
#| echo: false
#| eval: true

ae_attendances |>
  filter(org_code == "RF4") |>
  ggplot(aes(x=period, y=attendances, color=type)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ type, nrow=1, scales="free") +
  theme_minimal() +
  theme(legend.position = "bottom")
  
```

(MILESTONE 01)

## Input options

Time for the [Shiny Cheatsheet](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf)

. . .

+ `checkboxGroupInput()`
+ `radioButtons()`

. . .

Arguments:

+ inputId
+ label
+ choices
+ selected

## Adding to the UI

Let's add some appropriate elements to our `ui()` for this graph:

+ `checkboxGroupInput()` to allow us to select an org
  + let's start with a simple vector of orgs `c("RJ1", "RLN", "RXK")`
+ `radioButtons()` to select the type

(MILESTONE 02)

## Plotting attendance by org

Here's a code snippet to allow us to produce a `ggplot()` based on different orgs and attendance types:

```{!r}
ae_attendances %>%
  filter(org_code %in% c("RJ1", "RLN", "RXK") & type == "1") %>%
  ggplot() +
  geom_line(aes(x = period, y = attendances, color = org_code))
```
+ `%in%` - very useful for filtering on several values

+ Let's try that code now to check the output

(MILESTONE 02)


What do we need to add to include a static version of the graph in our dashboard?

+ in `ui()`?
+ in `server()`?

(MILESTONE 03)

Just put the static R code into the `server()`

## Adding interactivity

We need to connect our inputs with the `server()`:

+ `input$org` rather than `c("RJ1", "RLN", "RXK")`
  + setting a default value of "RJ1" using `selected = "RJ1"`
+ `type == input$type_select`

(MILESTONE 04)

## A trap: hard-coded values

Typing values for users to select from is tedious. Can we cheat to get R to do the work for us?

+ We can include simple snippets of R code directly inside UI elements

+ (R question): how to get the possible values of `type` directly from `ae_attendances`?
+ (Shiny question): how to include those in our `radioButtons()`?

(MILESTONE 05)

We could do something similar for the orgs too, which we'll do later.

## Digression - development cycle in Shiny

+ get some R code working in a script
+ add that code to `server()` to run statically
+ add `ui()` options and link to `server()` to add interactivity
+ test
+ repeat

## Debugging

(see [*Mastering Shiny* chapter 5](https://mastering-shiny.org/action-workflow.html#debugging), or the [Debugging Shiny](https://shiny.posit.co/r/articles/improve/debugging/) page)

+ error messages in your output
+ call stack
+ print debugging
+ `browser()`, breakpoints, and `reactlog()`

(MILESTONE 06)

## Error messages

![](../src/images/error_msg.png)


## Call stack / traceback

![](../src/images/call_stack.png)


(MILESTONE 07)


## Print debugging
![](../src/images/print_debugging.png)


## `browser()`

(MILESTONE 08)

## Adding a national benchmark

+ we'll need to write some R code to:
    + take our data
    + filter for type == 1
    + calculate mean attendances for each month

(MILESTONE 09)

## Adding the benchmark code to `server()`

+ We only want the benchmark to update when we switch type
+ to do that, we'll use `reactive()`

. . .

To make a `reactive()`:

```{!r}
benchmark <- reactive({
<<code>>
})
```

. . .

To use a `reactive()`:

+ special way of calling reactive objects, similar to a function
+ `data = benchmark()` etc

(MILESTONE 06)

Lots going on here!

## `reactive()`

+ `reactive()` makes a reactive `benchmark()` object summarising the national data
  + inside `server()`
  + gets updated only when `type` changes
+ then use that `benchmark()` in the `ggplot`
  + special way of calling reactive objects, similar to a function
  + `data = benchmark()` etc

## Additional tweaks

+ set-up a vector of key orgs where data is available for all the months and add to UI using checkboxGroupInput

. . .

```{r}
key_orgs <- ae_attendances %>%
  group_by(period, org_code) %>%
  add_tally(name = "type_tally") %>%
  filter(type_tally == 3) %>%
  ungroup() %>%
  group_by(org_code, type) %>%
  add_count(name = "months") %>%
  filter(months == 36) %>%
  pull(org_code) %>%
  unique()
```
+ `ggplotly()`, `renderPlotly()`, and `plotlyOutput()`

(MILESTONE 07)

## Finishing touches

Conditional execution for our benchmark might be a nice touch?

  + add `checkboxInput()` to `ui()`
  + add a new `reactive()` object from that input
  + use that new `reactive()` in an `if`/`else`
    + in the `TRUE` arm of that `if`/`else`, add the benchmarked `ggplot`
    + in the `FALSE` arm of that `if`/`else`, add the non-benchmarked `ggplot`

(MILESTONE 08)

## Next time...
+ project architecture and managing complexity in Shiny

<!-- secret sauce -->
