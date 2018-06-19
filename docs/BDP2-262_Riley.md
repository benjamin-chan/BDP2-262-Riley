---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-19"
author: Benjamin Chan (chanb@ohsu.edu)
output:
  html_document:
    toc: true
    theme: simplex
---







# Import Andrew's SPSS data



Map new names to variables.


|oldnames                        |newnames                       |
|:-------------------------------|:------------------------------|
|record_id                       |id                             |
|eng_span                        |languageSurvey                 |
|children_totv_1                 |totalChildren                  |
|oldest_middle_youngest          |birthOrder                     |
|child_sexv_1                    |childSex                       |
|child_age_years                 |childAge                       |
|child_ethnicity                 |childEthnicity                 |
|child_racev_1___1               |childRaceWhite                 |
|child_racev_1___2               |childRaceAsian                 |
|child_racev_1___3               |childRaceAfrAm                 |
|child_racev_1___4               |childRaceAIAN                  |
|child_racev_1___5               |childRaceNHPI                  |
|child_racev_1___6               |childRaceOther                 |
|child_racev_1___7               |childRaceNoResp                |
|related_child                   |childRelationship              |
|gender                          |parentGender                   |
|parent_sexv_1                   |parentSex                      |
|parent_agev_1                   |parentAge                      |
|parent_ethnicity                |parentEthnicity                |
|parent_race___1                 |parentRaceWhite                |
|parent_race___2                 |parentRaceAsian                |
|parent_race___3                 |parentRaceAfrAm                |
|parent_race___4                 |parentRaceAIAN                 |
|parent_race___5                 |parentRaceNHPI                 |
|parent_race___6                 |parentRaceOther                |
|parent_race___7                 |parentRaceNoResp               |
|marital_status                  |parentMaritalStatus            |
|parenting_situationv_1          |parentSituation                |
|number_parents                  |parentsNumber                  |
|parent_to_child_ratio           |parentChildRatio               |
|zipcode_classification_combined |zipcodeClass                   |
|zipcode                         |zipcode                        |
|community_type                  |community                      |
|distance                        |distance                       |
|parent_educationv_1             |parentEducation                |
|annual_income                   |income                         |
|internet                        |internet                       |
|ECBI_intensity_raw_score        |ECBI_intensity_raw_score       |
|ECBI_intensity_T_score          |ECBI_intensity_T_score         |
|ECBI_intensity_clinical_cutoff  |ECBI_intensity_clinical_cutoff |
|ECBI_problem_raw_score          |ECBI_problem_raw_score         |
|ECBI_problem_T_score            |ECBI_problem_T_score           |
|ECBI_problem_clinical_cutoff    |ECBI_problem_clinical_cutoff   |
|ECBI_Opp                        |ECBI_Opp                       |
|ECBI_Inatt                      |ECBI_Inatt                     |
|ECBI_Cond                       |ECBI_Cond                      |
|MAPS_PP                         |MAPS_PP                        |
|MAPS_PR                         |MAPS_PR                        |
|MAPS_WM                         |MAPS_WM                        |
|MAPS_SP                         |MAPS_SP                        |
|MAPS_HS                         |MAPS_HS                        |
|MAPS_LC                         |MAPS_LC                        |
|MAPS_PC                         |MAPS_PC                        |
|MAPS_POS                        |MAPS_POS                       |
|MAPS_NEG                        |MAPS_NEG                       |
|SEPTI_nurturance                |SEPTI_nurturance               |
|SEPTI_n_clinical_cutoff         |SEPTI_n_clinical_cutoff        |
|SEPTI_discipline                |SEPTI_discipline               |
|SEPTI_d_clinical_cutoff         |SEPTI_d_clinical_cutoff        |
|SEPTI_play                      |SEPTI_play                     |
|SEPTI_p_clinical_cutoff         |SEPTI_p_clinical_cutoff        |
|SEPTI_routine                   |SEPTI_routine                  |
|SEPTI_r_clinical_cutoff         |SEPTI_r_clinical_cutoff        |
|SEPTI_total                     |SEPTI_total                    |
|SEPTI_total_clin_cutoff         |SEPTI_total_clin_cutoff        |
|PCB1_Total                      |PCB1_Total                     |
|PCB1_CondEmot                   |PCB1_CondEmot                  |
|PCB1_DevHab                     |PCB1_DevHab                    |
|PCB2_Tot                        |PCB2_Tot                       |
|PCB3_Total                      |PCB3_Total                     |
|PBC3_PCPonly                    |PCB3_PCPonly                   |
|PCB3_Person                     |PCB3_Person                    |
|PCB3_Resource                   |PCB3_Resource                  |







Build analysis data set.
Exclude if missing any dependent variable, `PCB1_Total`, `PCB2_Tot`, `PCB3_Total`.
Exclude rows if there are a high proportion of row-wise `NA`.


```
##    PCB1_Total       PCB2_Tot       PCB3_Total  
##  Min.   :18.00   Min.   : 6.00   Min.   :15.0  
##  1st Qu.:58.00   1st Qu.:22.00   1st Qu.:39.0  
##  Median :71.00   Median :25.00   Median :48.0  
##  Mean   :67.89   Mean   :24.54   Mean   :47.6  
##  3rd Qu.:81.00   3rd Qu.:28.00   3rd Qu.:57.0  
##  Max.   :90.00   Max.   :30.00   Max.   :75.0
```

![figures/flowChart.png](figures/flowChart.png)





# Preprocess data

Initial preprocesssing that needs to be done that is common to `PCB1_Total`, `PCB2_Tot`, and `PCB3_Total`.


```r
p <- 0.70
```

Split data set into 70:30 training:validation samples.


```r
inTrain <- createDataPartition(df$id, p = p)
dfTrain <- df[inTrain$Resample1, ]
dfValid <- df[-inTrain$Resample1, ]
```

Preprocess the training sample.

1. Exclude near-zero variance predictors
2. Impute missing values using k-nearest neighbor


```r
message(sprintf("Number of complete cases before imputation = %d",
                complete.cases(dfTrain) %>% sum()))
```

```
## Number of complete cases before imputation = 245
```

```r
nzv <- 
  dfTrain %>% 
  select(-c(id, 
            PCB1_Total, PCB1_CondEmot, PCB1_DevHab, 
            PCB2_Tot, 
            PCB3_Total, PCB3_PCPonly, PCB3_Person, PCB3_Resource)) %>% 
  nearZeroVar(names = TRUE, saveMetric = TRUE) %>%
  mutate(varname = row.names(.)) %>% 
  filter(nzv == TRUE) %>% 
  select(varname, freqRatio, percentUnique, zeroVar, nzv) 
nzv %>% kable()
```



|varname         | freqRatio| percentUnique|zeroVar |nzv  |
|:---------------|---------:|-------------:|:-------|:----|
|languageSurvey  |  67.25000|     0.7326007|FALSE   |TRUE |
|childRaceAfrAm  |  23.72727|     0.7326007|FALSE   |TRUE |
|childRaceAIAN   |  33.00000|     0.7326007|FALSE   |TRUE |
|childRaceNHPI   |  44.33333|     0.7326007|FALSE   |TRUE |
|parentRaceAfrAm |  37.85714|     0.7326007|FALSE   |TRUE |
|parentRaceAIAN  |  37.85714|     0.7326007|FALSE   |TRUE |
|parentRaceNHPI  |  44.33333|     0.7326007|FALSE   |TRUE |
|internet        |  44.33333|     0.7326007|FALSE   |TRUE |

```r
dfTrainPreProc1 <-
  dfTrain %>% 
  select(-one_of(nzv$varname))
dfOutcomes <- 
  dfTrainPreProc1 %>% 
  select(c(id,
           PCB1_Total, PCB1_CondEmot, PCB1_DevHab, 
           PCB2_Tot, 
           PCB3_Total, PCB3_PCPonly, PCB3_Person, PCB3_Resource))
dfTrainPreProc2 <- 
  dfTrainPreProc1 %>% 
  select(-c(id,
            PCB1_Total, PCB1_CondEmot, PCB1_DevHab, 
            PCB2_Tot, 
            PCB3_Total, PCB3_PCPonly, PCB3_Person, PCB3_Resource))
preProc <-
  dfTrainPreProc2 %>% 
  preProcess(method = c("nzv", "corr", "knnImpute"), verbose = TRUE)
```

```
##   2 highly correlated predictors were removed.
## Calculating 32 means for centering
## Calculating 32 standard deviations for scaling
```

```r
preProc
```

```
## Created from 245 samples and 56 variables
## 
## Pre-processing:
##   - centered (32)
##   - ignored (22)
##   - 5 nearest neighbor imputation (32)
##   - removed (2)
##   - scaled (32)
```

```r
dfTrainPreProc3 <- predict(preProc, dfTrainPreProc2)
dfTrainPreProc <- bind_cols(dfOutcomes, dfTrainPreProc3)
message(sprintf("Number of complete cases after imputation = %d",
                complete.cases(dfTrainPreProc) %>% sum()))
```

```
## Number of complete cases after imputation = 271
```

```r
save(dfTrainPreProc, dfValid, dfTrain, df, file = "data/processed/dataframes.RData")
rm(dfTrainPreProc1, dfTrainPreProc2, dfTrainPreProc3)
```

Set the control parameters.


```r
ctrl <- trainControl(method = "LOOCV",
                     savePredictions = TRUE,
                     allowParallel = TRUE,
                     search = "random")
cores <- 24
```

Set the model and tuning parameter grid.


```r
library(randomForest)
```

```
## randomForest 4.6-14
```

```
## Type rfNews() to see new features/changes/bug fixes.
```

```
## 
## Attaching package: 'randomForest'
```

```
## The following object is masked from 'package:dplyr':
## 
##     combine
```

```
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

```r
citation("randomForest")
```

```
## 
## To cite randomForest in publications use:
## 
##   A. Liaw and M. Wiener (2002). Classification and Regression by
##   randomForest. R News 2(3), 18--22.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Article{,
##     title = {Classification and Regression by randomForest},
##     author = {Andy Liaw and Matthew Wiener},
##     journal = {R News},
##     year = {2002},
##     volume = {2},
##     number = {3},
##     pages = {18-22},
##     url = {https://CRAN.R-project.org/doc/Rnews/},
##   }
```

```r
method <- "rf"
modelLookup(method) %>% kable()
```



|model |parameter |label                         |forReg |forClass |probModel |
|:-----|:---------|:-----------------------------|:------|:--------|:---------|
|rf    |mtry      |#Randomly Selected Predictors |TRUE   |TRUE     |TRUE      |

```r
grid <- expand.grid(mtry = seq(5, 15, 2))
grid %>% kable()
```



| mtry|
|----:|
|    5|
|    7|
|    9|
|   11|
|   13|
|   15|



# Model PCB1


## PCB1 Total

Prediction model for `PCB1`.

Train model over the tuning parameters.


```
## Random Forest 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   mtry  RMSE      Rsquared    MAE     
##    5    16.15901  0.07054889  13.30601
##    7    16.05818  0.08241417  13.12735
##    9    16.18145  0.06535911  13.24155
##   11    16.10151  0.07452178  13.14029
##   13    16.15882  0.06747671  13.23191
##   15    16.14275  0.06965381  13.17837
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was mtry = 7.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)


```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: regression
##                      Number of trees: 500
## No. of variables tried at each split: 7
## 
##           Mean of squared residuals: 261.3064
##                     % Var explained: 6.63
```

```
##                 Length Class      Mode     
## call              4    -none-     call     
## type              1    -none-     character
## predicted       271    -none-     numeric  
## mse             500    -none-     numeric  
## rsq             500    -none-     numeric  
## oob.times       271    -none-     numeric  
## importance      161    -none-     numeric  
## importanceSD      0    -none-     NULL     
## localImportance   0    -none-     NULL     
## proximity         0    -none-     NULL     
## ntree             1    -none-     numeric  
## mtry              1    -none-     numeric  
## forest           11    -none-     list     
## coefs             0    -none-     NULL     
## y               271    -none-     numeric  
## test              0    -none-     NULL     
## inbag             0    -none-     NULL     
## xNames          161    -none-     character
## problemType       1    -none-     character
## tuneValue         1    data.frame list     
## obsLevels         1    -none-     logical  
## param             0    -none-     list
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-1.png)

```
## Error in varImp[, "%IncMSE"]: subscript out of bounds
```


```
## Error in mutate_impl(.data, dots): Evaluation error: missing values in newdata.
```

```
## Error in postResample(pred = dfTrainPred$hat, obs = dfTrainPred$PCB1_Total): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 15.2506115  0.1120237 12.2322599
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.3346994
## hat         0.3346994 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Random Forest 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   mtry  RMSE      Rsquared    MAE     
##    5    4.698441  0.01078057  3.572597
##    7    4.673339  0.02019423  3.553683
##    9    4.698969  0.01261012  3.574914
##   11    4.709972  0.01043493  3.569801
##   13    4.693166  0.01558426  3.579519
##   15    4.687922  0.01766719  3.560848
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was mtry = 7.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)


```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: regression
##                      Number of trees: 500
## No. of variables tried at each split: 7
## 
##           Mean of squared residuals: 22.00806
##                     % Var explained: 1.19
```

```
##                 Length Class      Mode     
## call              4    -none-     call     
## type              1    -none-     character
## predicted       271    -none-     numeric  
## mse             500    -none-     numeric  
## rsq             500    -none-     numeric  
## oob.times       271    -none-     numeric  
## importance      161    -none-     numeric  
## importanceSD      0    -none-     NULL     
## localImportance   0    -none-     NULL     
## proximity         0    -none-     NULL     
## ntree             1    -none-     numeric  
## mtry              1    -none-     numeric  
## forest           11    -none-     list     
## coefs             0    -none-     NULL     
## y               271    -none-     numeric  
## test              0    -none-     NULL     
## inbag             0    -none-     NULL     
## xNames          161    -none-     character
## problemType       1    -none-     character
## tuneValue         1    data.frame list     
## obsLevels         1    -none-     logical  
## param             0    -none-     list
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-1.png)

```
## Error in varImp[, "%IncMSE"]: subscript out of bounds
```


```
## Error in mutate_impl(.data, dots): Evaluation error: missing values in newdata.
```

```
## Error in postResample(pred = dfTrainPred$hat, obs = dfTrainPred$PCB2_Tot): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 3.90534894 0.04934492 3.07049685
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2221372
## hat      0.2221372 1.0000000
```

![plot of chunk PCB2_Tot_Validation-predict](figures/PCB2_Tot_Validation-predict-1.png)



# Model PCB3


## Total PCB3

Prediction model for `PCB3_Total`.

Train model over the tuning parameters.


```
## Random Forest 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   mtry  RMSE      Rsquared    MAE     
##    5    11.33422  0.09093365  9.265299
##    7    11.25375  0.10295364  9.180394
##    9    11.28796  0.09450027  9.180969
##   11    11.26741  0.09807645  9.184166
##   13    11.26728  0.09772585  9.143949
##   15    11.28745  0.09351930  9.201777
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was mtry = 7.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)


```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: regression
##                      Number of trees: 500
## No. of variables tried at each split: 7
## 
##           Mean of squared residuals: 125.2771
##                     % Var explained: 10.78
```

```
##                 Length Class      Mode     
## call              4    -none-     call     
## type              1    -none-     character
## predicted       271    -none-     numeric  
## mse             500    -none-     numeric  
## rsq             500    -none-     numeric  
## oob.times       271    -none-     numeric  
## importance      161    -none-     numeric  
## importanceSD      0    -none-     NULL     
## localImportance   0    -none-     NULL     
## proximity         0    -none-     NULL     
## ntree             1    -none-     numeric  
## mtry              1    -none-     numeric  
## forest           11    -none-     list     
## coefs             0    -none-     NULL     
## y               271    -none-     numeric  
## test              0    -none-     NULL     
## inbag             0    -none-     NULL     
## xNames          161    -none-     character
## problemType       1    -none-     character
## tuneValue         1    data.frame list     
## obsLevels         1    -none-     logical  
## param             0    -none-     list
```

![plot of chunk PCB3_Total_Training-finalModel](figures/PCB3_Total_Training-finalModel-1.png)

```
## Error in varImp[, "%IncMSE"]: subscript out of bounds
```


```
## Error in mutate_impl(.data, dots): Evaluation error: missing values in newdata.
```

```
## Error in postResample(pred = dfTrainPred$hat, obs = dfTrainPred$PCB3_Total): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

```
## Error in eval(lhs, parent, parent): object 'dfTrainPred' not found
```

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.6739895  0.1451037  9.5551908
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.3809247
## hat         0.3809247 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



