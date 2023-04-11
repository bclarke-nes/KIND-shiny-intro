#milestone maker

#read a file
# search for delims, count, and split into n labelled output files
# then forms a skeleton qmd with the milestones

# functions ----

library(pacman)
p_load(diffr, tidyverse)

doc_split <- function(fn, output_path="milestones", delim="^#.*ms[ 0-9]*[ -]+") {
  
  # given a filename, this function splits the script into sequentially-numbered milestone files. The aim is to allow all the code for a session to be written in one script, and then split using this function into free-standing scripts, allowing trainees to see what the end-game is at each stage of the training
  input <- read_lines(fn)
  
  segs <- which(str_detect(input, delim))
  
  if (length(segs) > 1) {
    for (i in 1:length(segs)) {
      if (i != length(segs)) {
        output <- input[(segs[i]+1):(segs[i+1]-1)]
        write_lines(output,
                    paste0(
                      output_path,
                      "\\",
                      tools::file_path_sans_ext(basename(fn)),
                      "_ms_",
                      formatC(i, width = 2,flag = 0),
                      ".R"
                    ))
      } else {
        output <- input[(segs[i]+1):length(input)]
        write_lines(output,
                    paste0(
                      output_path,
                      "\\",
                      tools::file_path_sans_ext(basename(fn)),
                      "_ms_",
                      formatC(i, width = 2,flag = 0),
                      ".R"
                    ))
      }
    }
  }
}


make_milestones <- function(path="session outlines", output_path="milestones") {
  
  if(!file.exists(output_path)) {
    dir.create(output_path)
  }
  
  walk(list.files(path, full.names = T, pattern="*.R"), doc_split)
}

make_chunk <- function(mst) {
  out <- vector("character", 6)
  out[1] <-
    paste0("## Milestone ", str_extract(basename(mst), "[0-9]+(?=.R$)"))
  out[2] <- "```{r}"
  out[3] <- "#| echo: true"
  out[4] <- "#| eval: false"
  out[5] <- paste0("#| file: ../", mst)
  out[6] <- "```"
  
  out
}

build_quarto <- function(input_path = "milestones", output_path="slides") {
milestones <- list.files(input_path, full.names = T)

quarto_summary <- tibble(
  file = milestones,
  session = map_chr(milestones, ~ str_replace(str_extract(basename(.x), "s[0-9]+"), "s", "session ")),
  milestone =  map_chr(milestones, ~ str_extract(basename(.x), "[0-9]+(?=.R$)")),
  milestone_chunk = map(milestones, make_chunk)
)

for (i in unique(quarto_summary$session)) {
  header <- vector("character", 14)
  header[1] <- "---"
  header[2] <- paste0('title: "KIND Shiny intro - ', i, '"')
  header[3] <- 'author: "Brendan Clarke"'
  header[4] <- "format: "
  header[5] <- "    revealjs:"
  header[6] <- '        logo: "KLN_banner_v04_700.png"'
  header[7] <- '        css: logo.css'
  header[8] <- 'scrollable: true'
  header[9] <- 'smaller: true'
  header[10] <- 'execute: '
  header[11] <- '    echo: true'
  header[12] <- '    eval: false'
  header[13] <- '---'
  
  write_lines(header, paste0(output_path, "//shiny_intro_", i, ".qmd"))
  
  #now make the chunks
  chunks <- quarto_summary %>%
    filter(session == i) %>%
    pull(file)
  
  for (j in 1:length(chunks)) {
    write_lines(make_chunk(chunks[j]),
                paste0(output_path, "//shiny_intro_", i, ".qmd"),
                append = T)
    
  }
}
}

join_milestones <- function(text_path = "slides\\text_sections", ms_path = "session outlines", out_path="slides\\shiny_intro"){
# supply two paths: first for the dir containing .md with the session text with appropriate # of milestones indicated in each. Second path is to the milestones dir
# returns joined text section with optional output path
  
text_files <- list.files(text_path, pattern = "*.md", full.names = T)
ms_files <- list.files(ms_path, pattern = "*.R", full.names = T)

ms_index <- str_extract_all(ms_files, "[0-9]+") %>% unlist() %>% sort()
text_index <- str_extract_all(text_files, "[0-9]+") %>% unlist() %>% sort()

for (i in 1:9) {
  index <- paste0("0", i)
  
  if(index %in% ms_index & index %in% text_index) {
    
    text_fn <- paste0("slides/text_sections/shiny_intro_session 0", i, ".md")
    text_input <- read_lines(text_fn)
    text_sections <- which(str_detect(text_input, "\\(MILESTONE "))
    text_sections <- c(0, text_sections, length(text_input))
    
    # milestones from the quarto
    ms_fn <- paste0("slides/shiny_intro_session 0", i, ".qmd")
    ms_input <- c(read_lines(ms_fn), "")
    ms_sections <- which(str_detect(ms_input, "\\#\\# Milestone "))
    ms_sections <- c(1, ms_sections, length(ms_input))
    
    if(length(text_sections) > length(ms_sections)) {
      # cut text_sections down to size
      warning <- paste0("  \n <!-- CAUTION: ", length(text_sections) - length(ms_sections), " milestone(s) omitted -->") 
      
      text_sections <- text_sections[1:length(ms_sections)]
      
      } else {
        
        warning <- paste0("  \n <!-- all milestones included -->")
    }
    
    # that's now decided to join, and set up the relevant data. Now to join:
    match_maker <- function(j) {
      list(ms_input[(ms_sections[j]):(ms_sections[j + 1] - 1)],
           text_input[(text_sections[j] + 1):(text_sections[j + 1] -
                                                1)])
    }
    
    map(1:(length(text_sections) - 1), match_maker) %>% 
      unlist() %>%
      c(., warning) %>%
      write_lines(., paste0(out_path, "_session 0", i, ".qmd"))
    }
  }
}

clean_lines <- function(file) {
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

# use ----

makeqmd <- function(path){
# step 1: take your session outlines (with each sub-script ending with a call to shinyApp) and generate milestones
make_milestones()

#optional step 1b: remove any stray blank lines at heads and tails
walk(list.files("milestones", full.names=T, pattern="*.R"), clean_lines)

# step 2: take those milestones, and make matching (empty) quarto files containing linked chunks to each milestone - 1 per session
build_quarto()

# step 3: weave in the text parts of the session
join_milestones()

quarto::quarto_render(path)

rstudioapi::viewer(paste0(tools::file_path_sans_ext(path), ".html"))
}


