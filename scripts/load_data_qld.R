library(here)
getwd()

library(tidyverse)
library(readr)

source("util.R")

qld_file <- paste0(here("data/qld-baby-names"),"/20180718_bdm_top-100-baby-names-1960-to-2005.csv")
dq <- read_csv(qld_file)
dq <- remove_attr_spec(dq)

# # reorder columns
# dq <- dq %>%
#   select(Name,Sex,Year,Count)

# 
old_col_names <- colnames(dq)
new_col_names <-  c("Name", "Gender", "Year", "Count")

dq <- set_col_names(dq,old_col_names,new_col_names)
dq <- change_col_types(dq)

dq$State <- "QLD"

df_qld <- dq