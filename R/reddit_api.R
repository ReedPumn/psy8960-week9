## Script Settings and Resources

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

## Data Import and Cleaning

# JSON downloaded on 03/23/2023 at 7pm.
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
rstats_original_tbl <- as_tibble(rstats_list$data$children)

rstats_tbl <- rstats_original_tbl %>%
  mutate(post = data.title,
         upvotes = data.ups,
         comments = data.num_comments) %>%
  select(post:comments)

## Visualization
(ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  labs(x = "Upvotes", y = "Comments"))  %>%
  ggsave("../figs/fig1.png", ., width = 1920, height = 1080, units = "px")

## Analysis
cor.test(rstats_tbl$upvotes, rstats_tbl$comments)
df_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[2]] 
r_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[4]] %>%
  round(2) %>%
  str_remove(pattern = "^(?-)0")
p_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[3]] %>%
  round(2) %>%
  format(nsmall = 2) %>%
  str_remove(pattern = "^(?-)0")

## Publication
paste0("The correlation between upvotes and comments was r(", df_value, ") = ", r_value, ", p = ", p_value, ". This value was not statistically significant.")

# What I generally need to do:
# 4) Make a ggplot based on that tibble and make a correlation
# 5) Identify what parts of reddit are important
# 6) Scrape reddit
# 7) Read those parts of reddit into a tibble
# 8) Make a ggplot based on that tibble and make a correlation
# 9) Add descriptions explaining each of my steps in each document
# 10) Check work in each document