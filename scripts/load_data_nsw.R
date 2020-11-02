## ---------------------------
##
## Script name: nsw_pdf_parser.R
##
## Purpose of script:
##  Parse PDF files for yearly tables
##
## Author: Dr. Emanuel Vassiliadis
##
## Date Created: 2020-09-12
##
## LinkedIn: https://www.linkedin.com/in/evassiliadis/
##
## ---------------------------
##
## Notes:
##   Need to check for NAs
##
## ---------------------------

rm(list = ls(all = TRUE))

library(tidyverse)
library(tabulizer)
library(here)
getwd()

heading_left <- c(
  "rank1",
  "name.b1",
  "count.b1",
  "name.g1",
  "count.g1"
)

heading_right <- c(
  "rank2",
  "name.b2",
  "count.b2",
  "name.g2",
  "count.g2"
)

#
# FUNCTIONS
#

read_pdf_file <- function(myfilename) {
  
  # returns a list for each page
  tablelist <- extract_tables(
    myfilename,
    guess = FALSE
  )
  
  da <- NULL
  
  for (this_table in tablelist) {
    
    # testing code on first element in list
    dt <- as_tibble(this_table)
    
    # extract the year from the title and append new column                
    title <- dt[1,]
    this_year <- str_extract(title$V1,"\\d{4}")
    dt <- dt[-1,]
    
    # assign("CURRENT_YEAR", this_year, envir = .GlobalEnv)
    dt$year <- this_year
    
    # table heading row
    heading <- dt[1,]
    dt<- dt[-1,]
    
    # remove page counter at bottom
    dt<- head(dt,-1)
    
    # append result
    da <- rbind(da,dt)
  
  }
  
  invisible(da)
}

set_col_names <- function(df) {
  colnames(df) <- c("rank","name","count","year","gender")
  invisible(df)
}

get_boy_table <- function(df) {

  df1 <- df %>%
    select(rank1,name.b1,count.b1,year)
  this_names <- colnames(df1)
  
  df2 <- df %>%
    select(rank2,name.b2,count.b2,year)
  colnames(df2) <- this_names
  
  db <- rbind(df1,df2)
  
  db$Gender <- "MALE"

  db <- set_col_names(db)
  
  invisible(db)
}

get_girl_table <- function(df) {
  
  df1 <- df %>%
    select(rank1,name.g1,count.g1,year)
  this_names <- colnames(df1)
  
  df2 <- df %>%
    select(rank2,name.g2,count.g2,year)
  colnames(df2) <- this_names
  
  db <- rbind(df1,df2)
  
  db$Gender <- "FEMALE"
  
  db <- set_col_names(db)
  
  invisible(db)
}

get_long_table <- function(df) {
  this_heading <- append(heading_left,heading_right)
  
  dh <- df %>%
    separate(V1,this_heading)
  
  dh$year <- df$year
  
  db <- get_boy_table(dh)
  dg <- get_girl_table(dh)
  
  dz <- rbind(db,dg)
  
  invisible(dz)
}

#
# MAIN
#

csv_file_list <-list.files(
    path = paste0(here("data"),"/nsw-baby-names"),
    pattern = "*.pdf", 
    full.names = T
)

da <- NULL

for (file_name in csv_file_list) {
  
  dt <- read_pdf_file(file_name)
  
  dt <- get_long_table(dt)

  da <- rbind(da,dt)
}

# drop rank
da <- da[,-1]

da <- set_col_names(da)

# need to check for NAs
da$rank <- as.integer(da$rank)
da$count <- as.integer(da$count)
da$year <- as.integer(da$year)
da$gender <- as.factor(da$gender)

da$state <- "NSW"

df_nsw <- da

# da %>% 
#   filter(name=="Natalie",gender=="FEMALE") %>%
#   ggplot(aes(year,count)) +
#     geom_point()
