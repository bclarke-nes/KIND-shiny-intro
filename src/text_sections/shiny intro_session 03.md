## Session learning outcomes

Today is all about project architecture

+ splitting Shiny projects into UI/server/app
+ outsourcing more complicated R code to a script
+ outsourcing helpers
  + `glue()`
  + `here()`
+ writing functions in Shiny
  + `browser()`
+ adding functions to your dashboard

## Rationale

+ Shiny gets complicated!
+ this session shows how to manage that complexity
  + we can split shiny scripts into separate UI, server, and app files
  + we can move chunks of R code into separate scripts
  + we can turn repetitious code into functions

## Let's start with a blank(ish) script again
  
(MILESTONE 1)

## Splitting shiny scripts

+ this tiny shiny has three sections - UI/server/app
+ we can split those up into three different files:
  + app.R
  + server.R
  + ui.R

## app.R

+ this `sources()` the server and ui from their files
+ then starts the shiny server

(MILESTONE 2)

## server.R

+ this contains our `server()` code
+ we can also e.g. `source()` external scripts

(MILESTONE 3)

## ui.R

+ this contains our `ui()` code
+ again, can bring in external code here too
+ **important:** it probably makes most sense to do package loading here too

(MILESTONE 4)

## Outsourcing complicated code

+ we can bring in R scripts into our Shiny using `source()`
+ this is a great way to manage complexity
+ also brilliant for converting existing R scripts into Shiny
+ simple: dump all the scripts that you want into the `R/` directory

## Controlling what goes in in `R/`

+ Shiny automatically sources files in `R/`
+ I'd recommend turning this off and `source()`-ing scripts by hand
    + tends to generate package loading problems
    + in more complex projects, knowing what's in your R directory is a serious pain
+ Place a file named _disable_autoload.R in the R/ directory
+ Set `options(shiny.autoload.r = FALSE)` inside `shinyApp()`
  + this one gets messy though - harder to understand exactly what gets affected
  + see discussion [in the Shiny docs](https://shiny.posit.co/r/articles/build/app-formats/)

## Getting at script outputs

+ if you assign something to the global environment in your script, you'll have that thing wherever you `source()` that script
+ if you define functions, they'll be available wherever you `source()`
+ there are ways of controlling how scripts respond to inputs using `isolate()`
    + useful explanation from [the Shiny manual](https://shiny.rstudio.com/articles/isolation.html)


## Two vital helpers for using scripts

+ `glue()`
+ `here()`

## `glue::glue()`

+ try it!

. . .

```{r}
#| echo: true
#| eval: true

library(glue)
name <- "Janine"
glue("Hi {name}")
```

## `here::here()`

+ a way of avoiding messing around with file paths
+ e.g. you're going to have scripts in R/ that *think* they're in the project root because of `source()`
    + that can cause standard methods of describing paths to fail
    + this is a pain to debug


## `here::here()`

+ more folders = more file location specification needed
+ `here` - a way of solving complicated file location problems
+ subfolders are portable - so if you move the project folder to another location, everything will still work
+ easy to use - [great vignette](https://cran.r-project.org/web/packages/here/vignettes/here.html)

## how `here()`?
+ step 1: set a starting location for `here` to work from:

. . . 

```{r}
#| echo: true
here::i_am("app.R")
library(here)

```
+ note non-standard order - load `i_am` via namespacing, then load the package itself
+ do this once per project at the start of the first script that's going to run - probably in app.R?

## how `here()`?
+ step 2: replace paths with relative paths inside `here`
+ `here` will convert the path into a proper absolute path

## how `here()`?

::: {.panel-tabset}

### relative path from project

```{r}
#| results: asis
#| echo: true
read_csv("data/subfolder/subsubfolder/hidden_data.csv") 
```

### here from hierarchy of folders

```{r}
#| results: asis
#| echo: true
read_csv(here("data", "subfolder", "subsubfolder", "hidden_data.csv"))
```

### here from a relative path
```{r}
#| results: asis
#| echo: true
read_csv(here("data/subfolder/subsubfolder/hidden_data.csv"))
```

### here from a partial path and file name
```{r}
#| results: asis
#| echo: true
data_path <- "data/subfolder/subsubfolder"

read_csv(here(data_path, "hidden_data.csv"))
```


### here from a partial path fragments and file name
```{r}
#| results: asis
#| echo: true
data_path_frags <- c("data", "subfolder", "subsubfolder", "useless_subsubfolder")

file_name <- "hidden_data.csv"

read_csv(here(paste(data_path_frags[1:3], collapse="/"), file_name))
```
:::

## writing functions in Shiny

```{r}

function_name <- function(argument){
  # some code here using the argument
}

```

+ we'll practice with a minimal function...

## writing functions in Shiny

```{r}
#| echo: true
#| eval: true

library(tidyverse)
library(NHSRdatasets)

ae_attendances |>
  filter(type == "1") |>
  group_by(org_code) |>
  summarize(across(where(is.numeric), sum)) |>
  ggplot(aes(x=admissions, y=breaches, size=attendances)) +
  geom_point(color="steelblue4", alpha=1/3) +
  geom_smooth(color="steelblue4", se=F) +
  theme_minimal() +
  theme(legend.position="none")

```

## writing functions in Shiny

+ turning this code into a function means we can more easily re-use it
+ all we need to do is:
    + decide on a name for our function
    + wrap the code in `function()`

. . .

```{r}
#| echo: true
#| eval: true

att_graph <- function(){
  ae_attendances |>
    filter(type == "1") |>
    group_by(org_code) |>
    summarize(across(where(is.numeric), sum)) |>
    ggplot(aes(x=admissions, y=breaches, size=attendances)) +
    geom_point(color="steelblue4", alpha=1/3) +
    geom_smooth(color="steelblue4", se=F) +
    theme_minimal() +
    theme(legend.position="none")
  }

```

## writing functions in Shiny

+ to use the function, we just call it like any other function:

. . .

```{r}
#| echo: true
#| eval: true

att_graph()

```

## writing functions in Shiny

+ most of the time, we'll want to add arguments to our function
+ these will usually come from our UI input

## writing functions in Shiny practice

+ start in a new project
+ create an empty Shiny in app.R
+ create an R/ folder
+ create an empty R script in the R/ folder

## `browser()` demo

## Next time...
+ 'putting it all together' - taking the elements from these sessions, and starting to build a proper dashboard
+ shinydashboard will help!

<!-- secret sauce -->
