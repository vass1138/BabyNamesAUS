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

targets <- c(
  "DUSTY",
  "DUSTIN"
)

pf <- plot_me(df,targets,"FEMALE") +
  labs(x="Birth Year",
       title="Baby Names For Young'uns (Female)",
       subtitle="South Australia dataset",
       caption=""
  )

pf

# ggsave("cousins_f.png",pf)

pm <- plot_me(df,targets,"MALE") +
  labs(x="Birth Year",
       title="Baby Names For Young'uns (Male)",
       subtitle="South Australia dataset",
       caption=""
  )

pm

# ggsave("cousins_m.png",pm)

# install.packages("cowplot")
library(cowplot)
#pall <- plot_grid(pf,pm,nrow=2,ncol=1)
#ggsave("cousins_all.png",pall)


#pall <- plot_grid(pf,pm,nrow=2,ncol=1)
#ggsave("oldies_all.png",pall)


