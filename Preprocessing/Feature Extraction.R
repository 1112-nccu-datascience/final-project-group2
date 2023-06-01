## Import Packages
library(tidyverse)
library(caret)
## Read Data
data <- read.csv('../data/merged_data.csv') # here is the data with all variables
# Check NA and ''
colSums(is.na(data))
colSums(data == '')
## Preprocessing
# Choose Top genre_ids
ids <- data['genre_ids'] %>% separate(genre_ids,paste('id',c(0:7)),"\\|")
ids_freq <- table(unlist(ids))
# barplot(c(sort(ids_freq, decreasing = T)[1:2],
#           sum(sort(ids_freq, decreasing = T)[3:167])))
# sum(ids_freq > 100000)
# Maybe keep Top 10 genres or set 465 vs.others or 465, 458, others
# I decide to set the variables into {465: A, 458: B, others: O}
set_id <- function(x){
  x <- na.omit(x)
  if ('465' %in% x){
    return('A')
  }else if ('458' %in% x){
    return('B')
  }else{
    return('O')
  }
}
new_id <- apply(ids, 1,set_id)
data$genre_ids <- new_id
## Drop variables with a large amount of N/A or meaningless(Optional)
# data <- subset(data, select = -gender)
# data <- subset(data, select = -msno)
data <- data %>% replace_na(list(name = 'other', isrc = 'other',
                         language = -1, song_length = -1))
data[data$gender == '', 'gender'] <- 'other'
data[data$gender == '', 'source_system_tab'] <- 'other'
data[data$gender == '', 'source_screen_name'] <- 'other'
data[data$gender == '', 'isrc'] <- 'other'
write.csv(data, '../data/Features_ver1.csv', row.names = F)

