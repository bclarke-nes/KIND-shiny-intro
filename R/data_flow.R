library(pacman)
p_load(tidyverse, DiagrammeR, nomnoml)


nomnoml(
  "
#direction: down

  [text_sections|.md|Milestone locations; explanatory text | n files]

  [session_outlines|.R|m milestones per file | n files]

  [images | whatever]

  [data | whatever]

  [text_sections] -> [join_milestones()]
  [images] -> [join_milestones()]
  [data] -> [join_milestones()]
  [milestones] <-> [clean_lines() | trims any spare white space]
  [session_outlines] -> [make_milestones()]

  [make_milestones() | walks over doc_split() | args: path, output_path | [doc_split() | args: path, output_path, delim | splits by delim into sequentially numbered files in /milestones]] -> [milestones]

  [Slides | .qmd; rendered html | n files]
  [milestones | one .R per milestone]

[milestones] -> [build_quarto()]
[build_quarto() | args: input_path, output_path | [quarto_summary |  tibble | file, session, milestone, milestone_chunk | [make_chunk()]]] 

[build_quarto()] -> [Quarto skeletons]

[Quarto skeletons] -> [join_milestones()]
[Text sections] -> [join_milestones()]

[join_milestones()] -> [Slides]

")

