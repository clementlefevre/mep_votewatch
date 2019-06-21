###################
# global.R
#
# Anything you want shared between your ui and server, define here.
###################

library(tidyr)
library(dplyr)

library(stringr)
set.seed(122)
df <- data.frame(n = rnorm(500),
                 m = rnorm(100))



df.members <- read.csv('data/MEP_lists.csv')
df.members$name <- str_replace(df.members$name,"This person became MEP later than the general start of the term.","")

all.countries <- as.character(sort(unique(df.members$country)))

all.groups <- as.character(sort(unique(df.members$group)))
print(all.countries)
df.session.votes <- read.csv('data/MEP_votes_per_session.csv')
sessions <- NULL
sessions$dates <- unique(df.session.votes$week.date.vote)
sessions$x.dates.axis.breaks <-
  sessions$dates[seq(1, length(sessions$dates), 6)]

df.ranking <- df.session.votes %>% group_by(member_id,status) %>% summarise(votes.count=n()) %>% mutate(presence.ratio = votes.count/sum(votes.count)*100) %>% filter(status=='Present') %>% merge(.,df.members,by.x='member_id',by.y='id') %>% arrange(desc(presence.ratio))


df.pca <- read.csv('data/MEP_pca_all_domains.csv')

min.pc1<-min(df.pca$PC1)
max.pc1<-max(df.pca$PC1)

min.pc2<-min(df.pca$PC2)
max.pc2<-max(df.pca$PC2)

df.colors <- read.csv('data/MEP_group_colors.csv')
df.pca <- merge(df.pca,df.colors,by='group')
df.pca.party <- df.pca %>% group_by(party,euro_domeniu_nume) %>% summarise(PC1 =mean(PC1),PC2=mean(PC2),size=n(),group=first(group))

cols <- (setNames( as.character(df.colors$color),as.character(df.colors$group)))
