library(here)
getwd()

library(tidyverse)

if (!exists("df_qld")) {
  source("load_data_qld.R")
}

if (!exists("df_sa")) {
  source("load_data_sa.R")
}

if (!exists("df_nsw")) {
  source("load_data_nsw.R")
}

