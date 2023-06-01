### Import Packages
library(tidyverse)
library(caret)
### Read Data
## Songs
data <- read.csv('../data/train.csv')
songs <- read.csv('../data/songs.csv')
# length(unique(data$song_id)) # 359966
songs <- songs[,-c(4:6)] # not going to use features like artist name
df <- merge(x = data, y = songs, by = 'song_id', all.x = T)

# language, song_length and genre_ids have N/A in original songs data
## Members
members <- read.csv('../data/members.csv')
df2 <- merge(x = df, y = members, by = 'msno', all.x = T)
# There is no N/A in members
## extra info
extra <- read.csv('../data/song_extra_info.csv')
df3 <- merge(x = df2, y = extra, by = 'song_id', all.x = T)
# There are a lot of N/A in song's names and ISRC
### Write CSV
write.csv(df3,'../data/merged_data.csv', row.names = F)