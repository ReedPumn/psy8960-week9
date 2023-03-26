## Script Settings and Resources

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(rvest)

## Data Import and Cleaning
# Imported on 03/26/2023 at 11:17am. This line imports the data in an html format to later be scraped.
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

#This series of pipes creates our post variable by defining an xpath. I found this xpath and the xpaths for the next two variables by right-clicking the desired element and then clicking "inspect" to see its xpath information.
post <- rstats_html %>%
  html_elements(xpath = "//a[@data-event-action = 'title']") %>%
  html_text()

#This series of pipes creates our upvotes variable by defining an xpath. I had to convert it into numeric so that it could be used in later analyses.
upvotes <- rstats_html %>%
  html_elements(xpath = "//div[@class = 'score unvoted']") %>%
  html_text() %>%
  as.numeric() %>%
  replace_na(0)

# This series of pipes creates our comments variable by defining an xpath. I had to remove the end of each element so that "9 comments" became "9" for later analyses. I added zeros for posts which had no comments by replacing NAs.
comments <- rstats_html %>%
  html_elements(xpath = "//a[@data-event-action = 'comments']") %>%
  html_text() %>%
  str_remove(pattern = "\\s.+") %>%
  as.numeric() %>%
  replace_na(0)

# This line combines our three previously created variables to create our tibble we will use in later analyses. Importantly, both upvotes and comments were stored as dbls to enable analysis.
rstats_tbl <- tibble(post, upvotes, comments)

## Visualization
# This series of pipes creates our ggplot visualizing the relationship between the number of upvotes with the number of comments. I saved the output to the figs folder to easily refer back to it later if needed.
(ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
    geom_point() +
    labs(x = "Upvotes", y = "Comments"))  %>%
  ggsave("../figs/fig2.png", ., width = 1920, height = 1080, units = "px")

## Analysis
# This line conducts a correlation test between the number of upvotes and the number of comments to see if they are significantly related.
cor.test(rstats_tbl$upvotes, rstats_tbl$comments)

# I chose to define the degrees of freedom, r-value, and p-value for the above statistical test to enable cleaner code in the Publications section. This line defines our degrees of freedom.
df_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[2]]

# This series of pipes defines our r-value produced by the above test. I had to round values and remove the leading zero to fit APA style.
r_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[4]] %>%
  round(2) %>%
  str_remove(pattern = "^(?-)0")

# This series of pipes defines our p-value produced by the above test. I had to round values and remove the leading zero to fit APA style.
p_value <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)[[3]] %>%
  round(2) %>%
  format(nsmall = 2) %>%
  str_remove(pattern = "^(?-)0")

## Publication
# "The correlation between upvotes and comments was r(23) = .34, p = .10. This test was not statistically significant."

# This line of text brings in our previously defined values to construct a dynamic sentence that interprets the correlation test. It uses two verbs in one line, but only for added readability.
paste0("The correlation between upvotes and comments was r(", df_value, ") = ", r_value, ", p = ", p_value, ". This test ", if (as.numeric(p_value) < .05) {"was"} else {"was not"}, " statistically significant.")