## Script Settings and Resources

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

## Data Import and Cleaning
# Imported on 03/24/2023 at 1:43pm
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

post <- rstats_html %>%
  html_elements(xpath = "//a[@data-event-action = 'title']") %>%
  html_text()

upvotes <- rstats_html %>%
  html_elements(xpath = "//div[@class = 'score unvoted']") %>%
  html_text()

comments <- rstats_html %>%
  html_elements(xpath = "//a[@class = 'bylink comments may-blank']") %>%
  html_text() %>%
  str_remove(pattern = "\\s.+")

rstats_tbl <- tibble(post, upvotes, comments)
# Error here because there are only 22 comments, but 25 of each other variable.  
