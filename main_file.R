library(pacman)
p_load(tidyverse, KINDR)
source("src/R/settings.R")

walk(1:4, render=T, make_qmd)
make_qmd(4, render=T)
