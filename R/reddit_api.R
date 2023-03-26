## Script Settings and Resources

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

## Data Import and Cleaning

# JSON last downloaded on 03/26/2023 at 11:17am. This downloads the JSON file so that we can later extract information from it.
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)

# This line turns the extracted JSON into a legible tibble for easy analyses. I specified the path data to children because, using the JSON viewer Chrome extension, I could see that the information we want were nested under this path sequence.
rstats_original_tbl <- as_tibble(rstats_list$data$children)

# This series of pipes creates the three columns relevant for our analyses. I ended the pipe by selecting only the relevant columns. The previous tibble had over 100 columns, which is visually unweildy, so this simple tibble works well.
rstats_tbl <- rstats_original_tbl %>%
  mutate(post = data.title,
         upvotes = data.ups,
         comments = data.num_comments) %>%
  select(post:comments)

## Visualization
# This series of pipes creates our ggplot visualizing the scatterplot of the number of upvotes to the number of comments. I first thought I would jitter, but no points are really overlapping, so jittering would only add confusion. I saved the figure to the figs folder so that it could be easily viewed on Github.
(ggplot(rstats_tbl, aes(x = upvotes, y = comments)) +
  geom_point() +
  labs(x = "Upvotes", y = "Comments"))  %>%
  ggsave("../figs/fig1.png", ., width = 1920, height = 1080, units = "px")

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