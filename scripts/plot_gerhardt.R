rm(list = ls(all = TRUE))

library(here)
getwd()

library(tidyverse)
library(readr)

#
# FUNCTIONS
#


#
# MAIN
#

if (!exists("df_sa")) {
  source("load_data_sa.R")
}

#
#
#

gerhardt <- c("GERHART","GERHARDT")

pm <- plot_me(df,gerhardt,"MALE") +
  labs(x="Birth Year",
       title="Baby Names For Oldies (Male)",
       subtitle="South Australia dataset",
       caption=""
  )

pm

