#!/bin/bash

# 定义输入文件名
predictions_file="predictions.csv"
submission_file="submission.csv"

# 定义权重比例
weight_predictions=0.3
weight_submission=0.7

# 创建临时文件来保存结果
output_file="output.csv"

# 将标题行复制到输出文件中
head -n 1 "$predictions_file" > "$output_file"

# 读取每一行数据，计算加权平均并将结果追加到输出文件中
tail -n +2 "$predictions_file" | \
  awk -F ',' -v w1="$weight_predictions" -v w2="$weight_submission" \
    '{ id = $1; value = $2; getline < "'$submission_file'"; weighted_average = (w1 * value) + (w2 * $2); printf "%s,%f\n", id, weighted_average }' \
    >> "$output_file"

echo "加权平均结果已保存到 $output_file"
