library(tidyverse)
library(rvest)  # for web scraping 
library(janitor) # for data cleaning 
library(lubridate) #to work with date


rm(list=ls()) 


url <- "https://en.wikipedia.org/wiki/World_Happiness_Report#2021_report"

url %>% read_html() %>% 
  html_element("table.wikitable") %>%  
  html_table() %>% head(5)


url %>%
  read_html() %>% 
  html_nodes("table") %>%  
  html_table() %>% .[[13]] %>% head(5)

#Assigning and renaming 
table <- url %>%
  read_html() %>% 
  html_nodes("table") %>%  
  html_table() %>% .[[13]]

names(table) <- c("rank", "country","score", "GDPP","social_support","LEXP","Freedom","Generosity","Pcorruption")

head(table,5)


# Some plot using the data
# plot only upper 20 happiest country 
table %>% head(20) %>% 
  ggplot(aes(x= score, y=fct_reorder(country, score))) +
  geom_point()+ xlab("Happiness score") + ylab("country") + ggtitle('Top 20 happiest country')