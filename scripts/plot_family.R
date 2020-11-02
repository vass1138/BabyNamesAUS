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

cousins_f <- c(
  "JOSEPHINE",
  "LOLA",
  "RUBY",
  "TRINITY",
  "ALETHEA",
  "MADELEINE"
)

cousins_m <- c(
  "THOMAS",
  "COLTON",
  "ANTHONY",
  "ANGUS"
)

oldies_f <- c(
  "NATALIE",
  "JANE",
  "BRONWYN",
  "DANIELLE"
)

oldies_m <- c(
  "EMANUEL",
  "STEVEN",
  "JAMES",
  "PAUL"
)

pf <- plot_me(df,cousins_f,"FEMALE") +
  labs(x="Birth Year",
       title="Baby Names For Young'uns (Female)",
       subtitle="South Australia dataset",
       caption=""
  )

ggsave("cousins_f.png",pf)

pm <- plot_me(df,cousins_m,"MALE") +
  labs(x="Birth Year",
       title="Baby Names For Young'uns (Male)",
       subtitle="South Australia dataset",
       caption=""
  )

ggsave("cousins_m.png",pm)

# install.packages("cowplot")
library(cowplot)
pall <- plot_grid(pf,pm,nrow=2,ncol=1)
ggsave("cousins_all.png",pall)

#
pf <- plot_me(df,oldies_f,"FEMALE") +
  labs(x="Birth Year",
       title="Baby Names For Oldies (Female)",
       subtitle="South Australia dataset",
       caption=""
  )

ggsave("oldies_f.png",pf)

pm <- plot_me(df,oldies_m,"MALE") +
  labs(x="Birth Year",
       title="Baby Names For Oldies (Male)",
       subtitle="South Australia dataset",
       caption=""
  )

ggsave("oldies_m.png",pm)

pall <- plot_grid(pf,pm,nrow=2,ncol=1)
ggsave("oldies_all.png",pall)


