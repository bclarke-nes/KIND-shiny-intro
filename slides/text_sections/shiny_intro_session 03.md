## Session learning outcomes

+ outsourcing more complicated R code to a script
+ thinking about UI design using `shinydashboard`

## Let's start with a blank(ish) script again
  
(MILESTONE 1)

## Basic UI infrastucture

+ `shinydashboard`

(MILESTONE 2)

## `Shinydashboard`

+ much nicer default appearance
+ `dashboardHeader()`
+ `dashboardSidebar()`
+ `dashboardBody()`

We're going to work within the `dashboardBody()` today, and leave the header and sidebar for next time.

(MILESTONE 3)

## Data sources

With that UI framework in place, we can start thinking about building a dashboard to use real data: 

+ [PHS delayed discharge bed days by health board](https://www.opendata.nhs.scot/dataset/52591cba-fd71-48b2-bac3-e71ac108dfee/resource/fd354e4b-6211-48ba-8e4f-8356a5ed4215/)
+ [PHS health board names and geography codes](https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc)
+ [PHS population estimates](https://www.opendata.nhs.scot/dataset/7f010430-6ce1-4813-b25c-f7f335bdc4dc/resource/27a72cc8-d6d8-430c-8b4f-3109a9ceadb1)

Let's look at the DD data now to see what we're likely to need

## Architecture

+ HBT
+ AgeGroup
+ Number

![](..//images//dd_structure.png)

## Getting the data

+ stand-alone data-processing script in `/data/s03_data.R` that downloads and tidies the data for us. You're very welcome to dissect that script - it's not very interesting, but the upshot is that it makes four .rds data files from the open data:

+ data/data.rds - the main delayed discharge data
+ data/boards.rds - a tibble of board names and codes
+ data/standardised_data.rds - delayed discharges per capita for the territorial NHS boards
+ data/standardised_data_national.rds - delayed discharges per capita, national

## Producing outputs

+ the aim is to do most of the processing in an R script, and just call the relevant parts from `server()`
+ we'll need a new R script: please create `R/s03.R` and add the following...

(MILESTONE 04)

## Building a graph function

Now we'll need to build some `ggplot` to:

+ filter `data` for one health board
+ plot the `Total` against `MonthOfDelay`

(MILESTONE 05)

Now we can wrap that code in a function to allow us to supply a board name, and return the appropriate graph. The first step is to create an empty function called `discharge_graph` that takes a single argument...

(MILESTONE 06)

Once we've got that set-up, we can insert the `ggplot` code, and adapt as appropriate. 

+ No need to {{embrace}} the argument

(MILESTONE 07)

Once we've got this in place (and tested) we can do a bit of beautifying:

(MILESTONE 08)

`glue()` is very helpful for making appropriate labels.


(MILESTONE 08)

We can now put the appropriate elements into the UI

(MILESTONE 09)

Two things to add to `server()`:

+ `isolate`, which is a way of safely `source()`-ing scripts inside `server()`
+ the single function call to `delayed_discharge()` 

## Developing the script

With the eventual aim of developing the full dashboard, we'll now add three more functions to s03.R:

+ `compare_boards()` - to compare DD counts between boards
  + three arguments: boards, age, date_range
+ `stand_compare_boards()` - to compare DD rates between boards
  + three arguments: boards, age, scot
+ `comp_map()` - to map DD rates relative to national average
  + three arguments: month_r, age, comp

(MILESTONE 10)

(MILESTONE 10)

(MILESTONE 10)

(MILESTONE 10)

## thing