library(data.table)
library(readxl)
library(tidyverse)
library(gganimate)
library(av)

data_path <- "../data/vic-baby-names"

# combine excel files
files <- list.files(path=data_path,pattern="*.xlsx",full.names=TRUE)
result <- rbindlist(lapply(files,read_excel),idcol='origin')

# index (origin) data by source filename
result[, origin := factor(origin, labels = basename(files))]

# extract year from filename and update index
library(stringr)
result$origin <- as.integer(str_extract(result$origin,"\\d{4}") )

# final column names
my_col_names <- c("year",
                  "male.position",
                  "male.name",
                  "male.count",
                  "dummy",
                  "female.position",
                  "female.name",
                  "female.count")

colnames(result) <- my_col_names

# cleanup empty column
result <- result %>%
  select(-dummy)

# cleanup header rows imported from each file
result <- result %>%
  filter(!male.position %in% c("Position","Male") )

# numeric columns
cols.num <- c("male.position",
              "male.count",
              "female.position",
              "female.count")

result <- result %>%
  mutate_at(cols.num,as.numeric)

# top 10 names, mean across all years
result %>%
  group_by(male.name) %>%
  summarise(MeanCount = mean(male.count)) %>%
  slice_max(MeanCount,n=10) %>%
  arrange(MeanCount) %>%
  mutate(name=factor(male.name, levels=male.name)) %>%
  ggplot(aes(name,MeanCount)) +
    geom_col() +
    coord_flip()


# need to ensure we have the same names each year
unique.male.names <- as.data.frame(unique(result$male.name))
colnames(unique.male.names) <- c("male.name")

result.full <- data.frame()

for(this_year in unique(result$year)) {
  tmp <- result %>%
    filter(year==this_year) %>%
    right_join(unique.male.names,by="male.name",suffix=c("",".y")) %>%
    mutate(year = replace_na(year, this_year))
  
  result.full <- rbind(tmp,result.full)
}

# explore lag with previous year popularity
baby_names <- result.full %>%
  mutate(grouping=sprintf("%s-%04d",male.name,year)) %>%
  mutate(male.prev = lag(male.count, order_by=grouping)) %>%
  mutate(male.prev = ifelse(is.na(male.prev),0,male.prev)) %>%
  mutate(male.gain = male.count-male.prev) %>%
  mutate(male.gain.percent = (male.gain/male.count)*100) %>%
           select(-grouping, -starts_with('female'))

baby_names %>%
  summary()

# grand final winners per year
# see AFL scripts

# names per winning team 
gf_players <- read_csv("../data/afl/grand_final_players.csv")

# remove drawn grand final
# generate labels for facet_wrap
# consolidate multiple rows per name
# labels, titles
gf_players <- gf_players %>%
  filter(!Playing.for=="St Kilda") %>%
  mutate(id=paste0(Year,"-",First.name)) %>%
  group_by(id) %>%
  mutate(Surname.string = toString(Surname)) %>%
  mutate(xlabel = paste0(First.name," (",Surname.string,")")) %>%
  mutate(facet.title=paste0(Year,' ',Playing.for)) %>%
  slice(1) %>%
  ungroup()

# examine correlation of names one year after grand final
# double counting ??
data <- baby_names %>%
  right_join(gf_players,by=c("year"="Year","male.name"="First.name")) %>%
  select(id,year,male.position,male.name,Surname,male.count,male.gain.percent,facet.title,xlabel) %>%
  filter(!is.na(male.count))

# select top 5 per year
top5 <- data %>%
  group_by(year) %>%
  mutate(Rank=rank(-male.gain.percent)) %>%
  slice_min(Rank,n=5) %>%
  ungroup()

mytheme <- theme(plot.title=element_text(size=18, hjust=0.5, face="bold", colour="grey", vjust=-1),
                plot.subtitle=element_text(size=12, hjust=0.5, face="italic", color="grey"),
                plot.caption =element_text(size=10, hjust=1, face="italic", color="grey"))

top5$xlabel <- factor(top5$xlabel)
top5$facet.title <- factor(top5$facet.title)

#install.packages("tidytext")
library(tidytext)
top5 <- top5 %>%
  mutate(xname=reorder_within(xlabel,-Rank,facet.title))

# show most 9 most recent teams 2011-2019
static_plot <- top5 %>%
  filter(!year %in% c(2009,2010,2020)) %>%
  # group_by(facet.title) %>%
  ggplot(aes(xname,male.gain.percent)) +
  geom_col() + 
  coord_flip() +
  scale_x_reordered() +
  scale_y_continuous(labels = scales::comma,limits=c(-50,50),oob=scales::squish) +
  facet_wrap(~ facet.title, scales="free") +
  labs(x="Baby Name (Premiership Player)",
       y="Name Popularity Gain Compared to Previous Year (Percentage)",
       title="AFL Premiership Player Name Popularity",
       subtitle="Baby Names in Victoria, Australia, by Birth Year and Previous Year's Premiership Team",
       caption=""
       #caption="www.linkedin.com/in/evassiliadis/\ngithub.com/vass1138/covid19"
  ) +
  mytheme

ggsave("vic_afl_baby_names.png")  

