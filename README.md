
# [第二組] KKBox's Music Recommendation Challenge
In this task, you will be asked to predict the chances of a user listening to a song repetitively after the first observable listening event within a time window was triggered. If there are recurring listening event(s) triggered within a month after the user’s very first observable listening event, its target is marked 1, and 0 otherwise in the training set. The same rule applies to the testing set.

KKBOX provides a training data set consists of information of the first observable listening event for each unique user-song pair within a specific time duration. Metadata of each unique user and song pair is also provided. The use of public data to increase the level of accuracy of your prediction is encouraged.

The train and the test data are selected from users listening history in a given time period. Note that this time period is chosen to be before the WSDM-KKBox Churn Prediction time period. The train and test sets are split based on time, and the split of public/private are based on unique user/song pairs.

## Contributors
|組員|系級|學號|工作分配|
|-|-|-|-|
|李峻安|資科碩一|111753222|團隊中的吉祥物🐇| 
|林尚儀|資科碩一|111753220|海報與去達賢報告|
|鄭竣鴻|統計碩一|111354009|EDA|
|陳劭晏|統計碩二|110354012|特徵工程與模型訓練|
|凃于珊|統計碩二|110354011|特徵工程|

## Quick start

!! We do not recommend you to run the R file directly, since the memory requirement of it is really high.!!
Instead, you can open the .ipynb(Python version) file to demo the project with lower computation cost.
If you have any technical problem, feel free to contact us.

## Folder organization and its related description
WSDM - KKBox's Music Recommendation Challenge (2018) 
[LINK.](https://www.kaggle.com/competitions/kkbox-music-recommendation-challenge) 
### docs
* [Group2_finalProject.pptx](https://docs.google.com/presentation/d/1QfXssuLYQeZ_qJUhWUgE4wiKqZbs8TMKPWbL8S95_AU/edit#slide=id.g24f5f7f2113_0_10) 

### data
* Input
  * Source: [Dataset Description](https://www.kaggle.com/competitions/kkbox-music-recommendation-challenge/data)
  * Format:5個CSV檔案，包含訓練集、測試集、使用者資訊、歌曲資訊以及歌曲額外資訊。訓練資料含有Target目標欄位。
  * Size:訓練集資料七百多萬筆，測試集資料兩百多萬筆。
* Output
  * Format:CSV file, 2欄位(ID, target)

### code
* Preprocess
  * 極端值clipping處理
  * 用戶特徵提取
  * 歌曲特徵提取
  * 歌曲相關特徵提取
  * 透過SVD針對user-item matrix消除噪音並擷取91個新特徵
* Methods
  * XGBoost
  * LightGBM
  *(使用5-folds Cross Validation選取最佳參數)

### results
* 原始模型成績800多名(AUC 0.58)經過特徵工程之後晉升300名(AUC 0.68)

## References
* Packages you use
* Related publications
