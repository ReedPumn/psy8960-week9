# Script Settings and Resources

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

# Data Import and Cleaning

# JSON downloaded on 03/23/2023 at 7pm.
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
rstats_original_tbl <- as_tibble(rstats_list$data$children)

rstats_tbl <- rstats_original_tbl %>%
  mutate(post = data.title,
         upvotes = data.ups,
         comments = data.num_comments) %>%
  select(post:comments)

# Visualization
# ggplot here


# Analysis
# r-value calculation here


# Publication
# r-value interpretation here 


# What I generally need to do:
# 1) Import the JSON
# 2) Identify what pieces of the JSON to read
# 3) Read those parts of the JSON to assign them to a tibble
# 4) Make a ggplot based on that tibble and make a correlation
# 5) Identify what parts of reddit are important
# 6) Scrape reddit
# 7) Read those parts of reddit into a tibble
# 8) Make a ggplot based on that tibble and make a correlation
# 9) Add descriptions explaining each of my steps in each document
# 10) Check work in each document