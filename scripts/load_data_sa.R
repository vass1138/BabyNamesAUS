library(here)
getwd()

library(tidyverse)
library(readr)

#
# FUNCTIONS
#

source(paste0(here(),"/scripts/util.R"))

# read csv file, default to char to avoid parse errors
# append year and gender extracted from filename
read_plus <- function(flnm) {
  
  mygender <- ifelse(str_detect(flnm,"female"),"FEMALE","MALE")
  myyear <- str_match(flnm,"_cy(\\d{4})_")[1,2]
  
  read_csv(flnm,col_types = cols(.default = "c")) %>% 
    mutate(filename = flnm) %>%
    mutate(Gender=mygender) %>%
    mutate(Year=myyear) %>%
    mutate(Position=str_replace(Position,"=",""))
}

#
# MAIN
#

# read all csv files using custom function
df <-
  list.files(
    path = paste0(here(),"/data/sa-baby-names-1944-2013"),
    pattern = "*.csv", 
    full.names = T) %>% 
  map_df(~read_plus(.))

df <- remove_attr_spec(df)

old_col_names <- colnames(df)
new_col_names <-  c("Name", "Count", "Position", "Filename", "Gender", "Year")

df <- set_col_names(df,all_of(old_col_names),new_col_names)
df <- select(df,"Name","Gender","Year","Count")

df <- change_col_types(df)

df <- df %>% 
  group_by(Name,Year,Gender) %>% 
  arrange(Name,Year,Gender) %>% 
  mutate(Count=sum(Count)) %>%
  ungroup()

df$State <- "SA"

df_sa <- df
