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

# karen plot
df_sa %>%
  filter(Name=="KAREN",Gender=="FEMALE") %>%
  ggplot(aes(x=Year,y=Count)) +
  geom_point() + 
  geom_smooth(method="loess",span=0.2) +
  geom_ribbon(aes(
    x = ifelse(Year>1965 & Year< 1985 , Year, NA),
    ymin = 0,
    ymax = predict(loess(Count ~ Year,span=0.2)),
    alpha = 0.3,
    fill = 'green'
  )) +
  scale_alpha(guide="none") + 
  scale_fill_discrete(guide="none") +
  labs(x="Birth Year",
       title="Baby Names: KAREN",
       subtitle="South Australia dataset (Age as at 2020)",
       caption=""
  ) +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(hjust=1,face="italic")) +
  annotate("text", x = 1968, y = 40, hjust=0, label = "Current age\n(35-55 yo)")

ggsave("karen.png")

#
#
#

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

#
#
#

qld_file <- paste0(here("qld-baby-names"),"/20180718_bdm_top-100-baby-names-1960-to-2005.csv")
dq <- read_csv(qld_file)
dq <- remove_attr_spec(dq)

# 
old_col_names <- colnames(dq)
new_col_names <-  c("Name", "Gender", "Year", "Count")

dq <- set_col_names(dq,old_col_names,new_col_names)
dq <- change_col_types(dq)


