#import data
train <- read.csv("train.csv")
test <- read.csv("test.csv")
songs <- read.csv("songs.csv")
members <- read.csv("members.csv")
song_extra_info <- read.csv("song_extra_info.csv")

#data shape
cat("Shape of train file is : ", dim(train), "\n")
cat("Shape of test file is : ", dim(test), "\n")
cat("Shape of songs file is : ", dim(songs), "\n")
cat("Shape of members file is : ", dim(members), "\n")
cat("Shape of song_extra_info file is : ", dim(song_extra_info), "\n")
#feature name
cat("Features of train : ", colnames(train), "\n")
cat("Features of test : ", colnames(test), "\n")
cat("Features of songs : ", colnames(songs), "\n")
cat("Features of members : ", colnames(members), "\n")
cat("Features of song_extra_info : ", colnames(song_extra_info), "\n")

#train analysis
summary(train)

library(ggplot2)

count_plot <- function(data, x, hue, type) {
  
  ggplot(data, aes(x = !!rlang::sym(x), fill = factor(!!rlang::sym(hue)))) +
    geom_bar(position = "dodge",width = 0.25) +
    scale_fill_discrete() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    xlab(x) +
    ylab("count") +
    ggtitle(paste0("Count plot for ", x, " in ", type, " data")) +
    theme(plot.title = element_text(size = 30),
          axis.title = element_text(size = 30),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          legend.position = "bottom") 
}

#target
count_plot(train, "target", "target", "train")# 0 1數量接近
label_1_percentage <- round((sum(train$target == 1) / nrow(train)) * 100, 4)
label_0_percentage <- round((sum(train$target == 0) / nrow(train)) * 100, 4)
cat("Data for label 1: ", label_1_percentage, "%\n")
cat("Data for label 0: ", label_0_percentage, "%\n")
#source_type
count_plot(train, 'source_type', 'target', 'train')
count_plot(train, 'source_type', 'source_type', 'train')
#source_system_tab
count_plot(train, 'source_system_tab', 'target', 'train')
count_plot(train, 'source_system_tab', 'source_system_tab', 'train')
#source_screen_name
count_plot(train, 'source_screen_name', 'target', 'train')
count_plot(train, 'source_screen_name', 'source_screen_name', 'train')


#member analysis
summary(members)


count_plot_function <- function(data, x) {
  
  ggplot(data, aes(x = !!rlang::sym(x), fill = factor(!!rlang::sym(x)))) +
    geom_bar() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          axis.title = element_text(size = 30),
          axis.text = element_text(size = 20),
          legend.title = element_blank(),
          legend.text = element_text(size = 20)) +
    xlab(x) +
    ylab("count") +
    ggtitle("Count plot") +
    theme(plot.title = element_text(size = 30)) 
}
#男女比例差不多，紅色為缺失值
count_plot_function(members, "gender")
#大部分的註冊是透過方法 '4'、'7' 和 '9' 進行的。
#有少數使用者使用了 '13' 和 '16' 方法進行註冊。
count_plot_function(members, 'registered_via')
#大部分喜歡聽歌的人來自於標記為 '1' 的城市。
#有些城市中喜歡使用這個音樂應用程式的人數很少。
count_plot_function(members, 'city')


library(scales)
pdf_plot <- function(data, column) {
  ggplot(data, aes(x = !!rlang::sym(column))) +
    geom_density(fill = "blue", alpha = 0.5) +
    theme_minimal() +
    theme(axis.title = element_text(size = 30),
          axis.text = element_text(size = 20),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab(column) +
    ylab("Density") +
    ggtitle(paste0("PDF for ", column)) +
    theme(plot.title = element_text(size = 30)) +
    scale_x_continuous(breaks = seq(min(data[[column]]), max(data[[column]]), length.out = 10))
}
#最初人們對於聽音樂並不感興趣，但在一段時間之後，人們開始聽音樂並註冊使用這個音樂應用程式
pdf_plot(members, "registration_init_time")
#到在一段時間之後，人們開始註冊使用這個音樂應用程式，他們的到期期限也在一段時間後開始增加。
pdf_plot <- function(data, column) {
  ggplot(data, aes(x = !!rlang::sym(column))) +
    geom_density(fill = "blue", alpha = 0.5) +
    theme_minimal() +
    theme(axis.title = element_text(size = 30),
          axis.text = element_text(size = 20),
          legend.title = element_blank(),
          legend.text = element_text(size = 20),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab(column) +
    ylab("Density") +
    ggtitle(paste0("PDF for ", column)) +
    theme(plot.title = element_text(size = 30)) +
    scale_x_continuous(breaks = seq(min(data[[column]]), max(data[[column]]), length.out = 5))
}
pdf_plot(members, "expiration_date")

# 轉換日期格式
members$registration_init_time <- as.Date(members$registration_init_time, origin = "1970-01-01")
members$expiration_date <- as.Date(members$expiration_date, origin = "1970-01-01")

# 計算時間到期
time_to_expiration <- (members$expiration_date - members$registration_init_time) / 24

# 檢視統計摘要
summary(time_to_expiration)

# 過濾非負值
x <- time_to_expiration[time_to_expiration >= 0]

# 繪製分佈圖
p <- ggplot(data.frame(x = x), aes(x = x)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(x = "Time to Expiration", y = "Density") +
  ggtitle("Distribution of Time of Expiration") +
  theme_minimal()

print(p)




unique(members$bd)
plot_pdf_cdf <- function(x, flag) {
  if (flag) {
    p <- ggplot(data.frame(x = x), aes(x = x)) +
      geom_density(fill = "blue", alpha = 0.5) +
      geom_line(stat = "ecdf", color = "red", lwd = 2, alpha = 0.5) +
      labs(x = "Age", y = "Probability") +
      ggtitle("PDF and CDF for Age") +
      theme_minimal()
  } else {
    p <- ggplot(data.frame(x = x), aes(x = x)) +
      geom_density(fill = "blue", alpha = 0.5) +
      labs(x = "Age", y = "Density") +
      ggtitle("PDF for Age") +
      theme_minimal()
  }
  
  print(p)
}
x <- members$bd
plot_pdf_cdf(x, FALSE)

plot_pdf_cdf(x, TRUE)

quantile(members$bd, 0.98)

#98th percentile的使用者年齡為47歲。
#這表示大多數使用者的年齡都在50歲以下。
#從上面的累積分布函數(CDF)也可以觀察到，幾乎99%的數值都在50歲以下。
#然而，也有一些離群值，例如1030、-38、-43、1051等。由於年齡不應該是負值或超過1000的數值，這些數值可能是錯誤的。

#song data analysis
songs_all_info <- merge(songs, song_extra_info, by = "song_id")

isrc_to_year <- function(isrc) {
  if (!is.na(isrc) && is.character(isrc) && nchar(isrc) >= 7) {
    if (as.integer(substr(isrc, 6, 7), na.rm = TRUE) > 17) {
      return(1900 + as.integer(substr(isrc, 6, 7), na.rm = TRUE))
    } else {
      return(2000 + as.integer(substr(isrc, 6, 7), na.rm = TRUE))
    }
  } else {
    return(NA)
  }
}

songs_all_info$song_year <- sapply(songs_all_info$isrc, isrc_to_year)

unique(songs_all_info$language)
count_plot_function(songs_all_info, 'language')
#使用者更喜歡以'52'和'-1'語言聆聽歌曲。

#check missing value
check_missing_values <- function(df) {
  missing_counts <- colSums(is.na(df) | df == "")
  total <- nrow(df)
  percentages <- missing_counts / total * 100
  missing_df <- data.frame(Column = names(missing_counts), Missing_Count = missing_counts, Percentage = percentages)
  print(missing_df)
}



cat("Missing values analysis for train data\n")
check_missing_values(train)

cat("Missing values analysis for members data\n")
check_missing_values(members)

cat("Missing values analysis for songs data\n")
check_missing_values(songs)

cat("Missing values analysis for songs_all_info data\n")
check_missing_values(songs_all_info)

#我們可以看到，train資料中的總體缺失值不超過6%。
#在members資料中，'gender'特徵缺失值佔57.85%。
#songs資料中的'composer'和'lyricist'特徵分別缺失值佔47%和85%。



