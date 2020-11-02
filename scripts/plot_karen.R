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
