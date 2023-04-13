#milestone maker
library(tidyverse)

## settings ----
milestone_output_path <- "milestones"
milestone_delim <- "^#.*ms[ 0-9]*[ -]+"
milestone_delim_text <- "\\(MILESTONE "
milestone_delim_quarto <- "## Milestone "
slide_output_path <- "slides"
course_name_computer <- "shiny_intro_"
course_name_human <- "Introductory Shiny"
author <- "Brendan Clarke"
logo <- "../images/KLN_banner_v04_700.png"
outline_input_path <- "src\\session outlines"
text_input_path <- "src\\text_sections"

# functions ----
file_finder <- function(session_n, path, pattern){
  # find file based on session number, path, and pattern
  fn <- list.files(path, pattern=paste0("*.", pattern), full.names=T)
  fn[grepl(session_n, fn)]
}

paths_from_session <- function(session_n) {
  # take a session # and return paths to relevant files
  list(
    outline = file_finder(session_n, outline_input_path, "R"),
    text = file_finder(session_n, text_input_path, "md"),
    milestones = file_finder(paste0("s", formatC(session_n, width = 2,flag = 0)), "milestones", "R"),
    slides = paste0(slide_output_path, "\\KIND_", course_name_computer, "s", formatC(session_n, width = 2,flag = 0), ".qmd")
  )
}

clean_lines <- function(file) {
 # cleans out empty lines at head and foot of files
   input <- read_lines(file)
  
  if (length(input > 1)) {
    if (input[1] == "") {
      while (input[1] == "")
        input <- input[-1]
      write_lines(input, file)
    }
    if (input[length(input)] == "") {
      while (input[length(input)] == "")
        input <- input[-length(input)]
      write_lines(input, file)
    }
  }
}

milestone_split <- function(session_n) {
  # given a filename, this function splits the script into sequentially-numbered milestone files. The aim is to allow all the code for a session to be written in one script, and then split using this function into free-standing scripts, allowing trainees to see what the end-game is at each stage of the training
  input <- read_lines(paths_from_session(session_n)[[1]])
  segs <- which(str_detect(input, milestone_delim))
  
  if(!file.exists(milestone_output_path)) {
    dir.create(milestone_output_path)
  }

  if (length(segs) > 1) {
    for (i in 1:length(segs)) {
      if (i != length(segs)) {
        output <- input[(segs[i] + 1):(segs[i + 1] - 1)]
        write_lines(
          output,
          paste0(
            milestone_output_path,
            "\\",
            course_name_computer,
            "s",
            formatC(session_n, width = 2, flag = 0),
            "_ms_",
            formatC(i, width = 2, flag = 0),
            ".R"
          )
        )
      } else {
        output <- input[(segs[i] + 1):length(input)]
        write_lines(
          output,
          paste0(
            milestone_output_path,
            "\\",
            course_name_computer,
            "s",
            formatC(session_n, width = 2, flag = 0),
            "_ms_",
            formatC(i, width = 2, flag = 0),
            ".R"
          )
        )
      }
    }
  }
}

make_chunk <- function(milestone_number) {
  #provided a milestone number, generates a quarto chunk for that milestone
  c(
    paste0(
      milestone_delim_quarto, 
      str_extract(basename(milestone_number), "[0-9]+(?=.R$)")
    ),
    "```{r}",
    "#| echo: true",
    "#| eval: false",
    paste0("#| file: ../", milestone_number),
    "```"
  )
}

build_quarto <- function(session_n) {
  # provided a session number, generates a quarto header and then one chunk for each milestone sharing the same session number
  milestone_input_fns <- paths_from_session(session_n)[[3]]
  slide_output_fn <- paths_from_session(session_n)[[4]]

  if(!file.exists(slide_output_fn)) file.create(slide_output_fn)
  
  quarto_summary <- tibble(
    file = milestone_input_fns,
    session = paste0("session ", formatC(
      session_n, width = 2, flag = 0
    )),
    milestone =  map_chr(
      milestone_input_fns,
      ~ str_extract(basename(.x), "[0-9]+(?=.R$)")
    ),
    milestone_chunk = map(milestone_input_fns, make_chunk)
  )
  
    title <- paste0('title: "KIND ', course_name_human, '"')
    subtitle <- paste0('subtitle: "session ', session_n, '"')
    auth <- paste0('author: "', author, '"')
    
    header <-
      c(
        "---",
        title,
        subtitle,
        auth,
        "format: ",
        "    revealjs:",
        paste0('        logo: "', logo, '"'),
        '        css: "../images/logo.css"',
        'scrollable: true',
        'smaller: true',
        'execute: ',
        '    echo: true',
        '    eval: false',
        '---'
      )
  
    write_lines(header, slide_output_fn)
    
    #now make the chunks
    chunks <- quarto_summary %>%
      filter(session == paste0("session ", formatC(session_n, width = 2,flag = 0))) %>%
      pull(file)
    
    if(length(chunks) > 0) {
    for (j in 1:length(chunks)) {
      write_lines(make_chunk(chunks[j]),
                  slide_output_fn,
                  append = T)
      
    }
  }
}

join_milestones <- function(session_n) {
  # joins the milestones to their appropriate chunk in the quarto

  quarto_input <- c(read_lines(paths_from_session(session_n)[[4]]), "")
  text_input <- read_lines(paths_from_session(session_n)[[2]])
  
  text_sections <-
    c(0,  which(str_detect(text_input, milestone_delim_text)), length(text_input))
  quarto_sections <-
    c(0, which(str_detect(quarto_input, milestone_delim_quarto)), length(quarto_input))
  
  if (length(text_sections) > length(quarto_sections)) {
    # cut text_sections down to size
    warning <-
      paste0(
        "  \n <!-- CAUTION: ",
        length(text_sections) - length(quarto_sections),
        " milestone(s) omitted -->"
      )
    
    text_sections <- text_sections[1:length(quarto_sections)]
    
  } else {
    warning <- paste0("  \n <!-- all milestones included -->")
  }

  map(1:(length(text_sections) - 1), ~ list(quarto_input[(quarto_sections[.x]):(quarto_sections[.x + 1] - 1)],
                                            text_input[(text_sections[.x] + 1):(text_sections[.x + 1] -
                                                                                 1)])) %>%
    unlist() %>%
    c(., warning) %>%
    write_lines(., paths_from_session(session_n)[[4]])
  
  }
join_milestones(1)
# use ----

make_qmd <- function(session_n, render = FALSE) {
  # given a session number, builds and opens a qmd from a text section file and a milestones file
  milestone_split(session_n)
  
  walk(paths_from_session(1)[[3]], clean_lines)
  
  build_quarto(session_n)
  
  join_milestones(session_n)
  
  if (render == TRUE) {
    quarto::quarto_render(paths_from_session(session_n)[[4]])
    rstudioapi::viewer(paste0(
      tools::file_path_sans_ext(paths_from_session(session_n)[[4]]),
      ".html"
    ))
  }
}
walk(1:4, make_qmd)
