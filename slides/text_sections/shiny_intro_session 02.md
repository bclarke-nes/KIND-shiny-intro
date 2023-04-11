## This session goal: make the dashboard more useful

## Session learning outcomes

+ consolidate session one work on Shiny structure
+ build fluency while working across `ui()` and `server()` 
+ reminder about function pairs (`render*()` and `output*()`)
+ additional input selections
+ more powerful reactivity
+ more ambitious R code in `server()`

## adding more interactivity

Let's start again with an empty Shiny app. We'll build this into a dashboard that:

+ uses `ae_attendances`
+ allows us to compare time trends of attendances between orgs
+ with a national average benchmark
+ and has some other interactive features

(MILESTONE 01)

## Plotting attendance by org

Here's a code snippet to allow us to produce a `ggplot()` based on different orgs and attendance types:

```{!r}
ae_attendances %>%
  filter(org_code %in% c("RJ1", "RLN", "RXK") & type == "1") %>%
  ggplot() +
  geom_line(aes(x = period, y = attendances, color = org_code))
```
+ `%in%` - very useful for filtering on several values

Let's add some appropriate elements to our `ui()` for this graph:

+ radioButtons() to allow us to select an org

(MILESTONE 02)

What do we need to add to our `server()` to be able to include a static version of the graph?

(MILESTONE 03)
Note this is not interactive - we've just put the static R code into the `server()`

(MILESTONE 04)
Adding interactivity:

+ `input$org` rather than `c("RJ1", "RLN", "RXK")`
  + setting a default value of "RJ1" using `selected = "RJ1"`
+ `type == input$type_select`

## Getting values into the UI
+ We can include simple snippets of R code directly inside UI elements

+ How to get the possible values of `type` directly from `ae_attendances`?

(MILESTONE 05)

We could do something similar for the orgs too, which we'll do later. For now though, let's add a benchmark:

(MILESTONE 06)
Lots going on here!

## `reactive()`

+ use `reactive()` to make a reactive `benchmark()` object summarising the national data
  + inside `server()`
  + gets updated when `type` changes
+ then use that `benchmark()` in the `ggplot`
  + special way of calling reactive objects, similar to a function
  + `data = benchmark()` etc

## Additional tweaks

+ set-up a vector of key orgs where data is available for all the months and add to UI using checkboxGroupInput

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

+ conditional execution for our benchmark

(MILESTONE 08)

## Next time...
+ outsourcing more complicated R code to a script
+ thinking about UI design





