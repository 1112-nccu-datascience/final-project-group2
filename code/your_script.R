library(xgboost)
library(caret)
library(optparse)

set.seed(111753220)

# 定义命令行参数
option_list <- list(
  make_option(c("--train"), type = "character", default = "data/train.csv",
              help = "Path to the training data CSV file."),
  make_option(c("--test"), type = "character", default = "data/test.csv",
              help = "Path to the test data CSV file."),
  make_option(c("--output"), type = "character", default = "results/performance",
              help = "Path to save the prediction results as a CSV file.")
)

# 解析命令行参数
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# 载入训练数据和测试数据
train_data <- read.csv(opt$train)
test_data <- read.csv(opt$test)

# 迭代处理每个列
for (col in names(train_data)) {
  # 检查列是否存在缺失值
  has_missing <- sum(is.na(train_data[[col]])) > 0
  
  if (has_missing) {
    # 使用均值填充缺失值
    mean_value <- mean(train_data[[col]], na.rm = TRUE)
    train_data[[col]][is.na(train_data[[col]])] <- mean_value
  }
}

for (col in names(test_data)) {
  has_missing <- sum(is.na(test_data[[col]])) > 0
  
  if (has_missing) {
    mean_value <- mean(test_data[[col]], na.rm = TRUE)
    test_data[[col]][is.na(test_data[[col]])] <- mean_value
  }
}

# 添加统计特征
train_data$mean_value <- apply(train_data[, -(1:2)], 1, mean)
train_data$sd_value <- apply(train_data[, -(1:2)], 1, sd)
train_data$max_value <- apply(train_data[, -(1:2)], 1, max)
train_data$min_value <- apply(train_data[, -(1:2)], 1, min)

test_data$mean_value <- apply(test_data[, -(1:1)], 1, mean)
test_data$sd_value <- apply(test_data[, -(1:1)], 1, sd)
test_data$max_value <- apply(test_data[, -(1:1)], 1, max)
test_data$min_value <- apply(test_data[, -(1:1)], 1, min)

# 将训练数据集转换为矩阵
#train_matrix <- as.matrix(train_data[, -(1:2)])

# 将测试数据集转换为矩阵
#test_matrix <- as.matrix(test_data[, -(1:1)])

# 计算欧氏距离
#dist_matrix <- dist(rbind(train_matrix, test_matrix))

# 将距离转换为相似度分数
#similarity_scores <- 1 / (1 + as.numeric(dist_matrix))

# 将相似度分数添加到测试数据集中
#test_data$similarity_score <- similarity_scores[(nrow(train_matrix) + 1):nrow(dist_matrix)]
#train_data$similarity_score <- similarity_scores[(nrow(train_matrix) + 1):nrow(dist_matrix)]

# 将标签变量映射为0和1
train_data$label <- ifelse(train_data$target == -1, 0, train_data$target)

# 将非数值型变量转换为数值型
train_data <- data.frame(lapply(train_data, as.numeric))

# 将数据转换为DMatrix格式
dtrain <- xgb.DMatrix(data = as.matrix(train_data[, -(1:2)]), label = train_data$target)
dtest <- xgb.DMatrix(data = as.matrix(test_data[, -(1:1)]))

# 设置XGBoost参数
xgb_params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  max_depth = 9,
  eta = 0.01,
  subsample = 0.8,
  colsample_bytree = 0.9
)

# 数据预处理
train_data$target <- as.factor(train_data$target)

# 训练XGBoost模型
xgb_model <- xgb.train(params = xgb_params, data = dtrain, nrounds = 100)

# 预测测试数据集
predictions <- predict(xgb_model, newdata = dtest)

# 保存预测结果为CSV文件
result <- data.frame(Id = test_data$id, label = predictions)
#result$label <- ifelse(result$label < 0.5, -1, 1)
write.csv(result, file = opt$output, row.names = FALSE)

