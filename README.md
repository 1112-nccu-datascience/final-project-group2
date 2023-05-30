# [第二組] KKBox's Music Recommendation Challenge
In this task, you will be asked to predict the chances of a user listening to a song repetitively after the first observable listening event within a time window was triggered. If there are recurring listening event(s) triggered within a month after the user’s very first observable listening event, its target is marked 1, and 0 otherwise in the training set. The same rule applies to the testing set.

KKBOX provides a training data set consists of information of the first observable listening event for each unique user-song pair within a specific time duration. Metadata of each unique user and song pair is also provided. The use of public data to increase the level of accuracy of your prediction is encouraged.

The train and the test data are selected from users listening history in a given time period. Note that this time period is chosen to be before the WSDM-KKBox Churn Prediction time period. The train and test sets are split based on time, and the split of public/private are based on unique user/song pairs.

## Contributors
|組員|系級|學號|工作分配|
|-|-|-|-|
|李峻安|資科碩一|111753222|團隊中的吉祥物🐇| 
|林尚儀|資科碩一|111753220||
|鄭竣鴻|統計碩一|111354009||
|陳劭晏|統計碩二|110354012||
|凃于珊|統計碩二|110354011||

## Quick start
example commend  to reproduce your analysis,
following R script
```R
Rscript code/your_script.R --input data/train --output results/performance.tsv
```

## Folder organization and its related description
WSDM - KKBox's Music Recommendation Challenge (2018) 
[LINK.](https://www.kaggle.com/competitions/kkbox-music-recommendation-challenge) 
### docs
* Your presentation, 1112_DS-FP_groupID.ppt/pptx/pdf (i.e.,1112_DS-FP_group1.ppt), by **06.08**
* Any related document for the project
  * i.e., software user guide

### data
* Input
  * Source
  * Format
  * Size 
* Output

### code
* Analysis steps
* Which method or package do you use? 
  * original packages in the paper
  * additional packages you found

### results
* What is a null model for comparison?
* How do your perform evaluation?
  * Cross-validation, or extra separated data

## References
* Packages you use
* Related publications
