#資料合併
library(dplyr)

train<-read.csv("data/train.csv")
test<-read.csv("data/test.csv")
songs <- read.csv("data/songs.csv")
members <- read.csv("data/members.csv") 
song_extra <- read.csv("data/song_extra_info.csv")
sample_submission <- read.csv("data/sample_submission.csv")
print('Data preprocessing...')
song_cols <- c('song_id', 'artist_name', 'genre_ids', 'song_length', 'language')
train <- left_join(train,songs[song_cols],by='song_id')
test <- left_join(test,songs[song_cols],by='song_id')

members$registration_year <- as.integer(substr(members$registration_init_time, 1, 4))
members$registration_month <- as.integer(substr(members$registration_init_time, 5, 6))
members$registration_date <- as.integer(substr(members$registration_init_time, 7, 8))

members$expiration_year <- as.integer(substr(members$expiration_date, 1, 4))
members$expiration_month <- as.integer(substr(members$expiration_date, 5, 6))
members$expiration_date <- as.integer(substr(members$expiration_date, 7, 8))
members <- subset(members, select = -c(registration_init_time))

isrc_to_year <- function(isrc) {
  if (is.character(isrc)) {
    if (isrc!="" & as.integer(substr(isrc, 6, 7)) > 17) {
      return(1900 + as.integer(substr(isrc, 6, 7)))
    } else if (isrc!=""){
      return(2000 + as.integer(substr(isrc, 6, 7)))
    }
  }
  return(NA)
}

song_extra$song_year <- sapply(song_extra$isrc, isrc_to_year)
song_extra <- subset(song_extra, select = -c(isrc, name))

train = left_join(train,members,by='msno')
test = left_join(test,members,by='msno')

train = left_join(train,song_extra,by='song_id')
test = left_join(test,song_extra,by='song_id')

write.csv(train,'data/merged_train.csv', row.names = F)
write.csv(test,'data/merged_test.csv', row.names = F)
#-------------------------------------------------------------------
#整理輸入模型的資料&清空暫存記憶體
##刪除 members 和 songs 物件
print('Training LGBM model...')
#rm(members,songs)
#gc()
train<-read.csv("data/merged_train.csv")
test<-read.csv("data/merged_test.csv")
# 對於 train 資料框的每一個欄位
for (col in names(train)) {
  # 如果欄位的數據類型為 "character" 或 "factor"
  if (is.character(train[[col]]) || is.factor(train[[col]])) {
    # 將欄位轉換為 "factor" 類型
    train[[col]] <- as.factor(train[[col]])
    test[[col]] <- as.factor(test[[col]])
  }
}

X <- train %>% select(-target)
y <- train$target
X_test <- test %>% select(-id)
ids <- test$id
##刪除 train 和 test 物件
rm(train, test)
#跑模型
#install.packages("lightgbm", repos = "https://cran.r-project.org")
library(lightgbm)

dtrain <- lgb.Dataset(as.matrix(X), label = as.numeric(y))
watchlist <- list(train = dtrain)

# 設置模型參數
params <- list(
  learning_rate = 0.2,
  max_depth = 8,
  num_leaves = 256,
  verbosity = 0,
  metric = "auc",
  objective = "binary"
)

model <- lgb.train(params, data = dtrain, nrounds = 50, valids = watchlist, verbose_eval = 5)
print('Making predictions and saving them...')
p_test <- predict(model, as.matrix(X_test))

subm <- data.frame(id = ids, target = p_test)
# 保存结果为 CSV 文件
write.csv(subm, file = 'submission.csv', row.names = FALSE, quote = FALSE)
print('Done!')