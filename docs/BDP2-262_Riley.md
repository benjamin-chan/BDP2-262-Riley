---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-22"
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
p <- 0.75
```

Split data set into 75:25 training:validation samples.


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
## Number of complete cases before imputation = 264
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
|languageSurvey  |  72.25000|     0.6825939|FALSE   |TRUE |
|childRaceAfrAm  |  19.85714|     0.6825939|FALSE   |TRUE |
|childRaceAIAN   |  35.50000|     0.6825939|FALSE   |TRUE |
|childRaceNHPI   |  47.66667|     0.6825939|FALSE   |TRUE |
|childRaceOther  |  21.46154|     0.6825939|FALSE   |TRUE |
|parentRaceAfrAm |  40.71429|     0.6825939|FALSE   |TRUE |
|parentRaceAIAN  |  35.50000|     0.6825939|FALSE   |TRUE |
|parentRaceNHPI  |  57.40000|     0.6825939|FALSE   |TRUE |
|parentRaceOther |  25.54545|     0.6825939|FALSE   |TRUE |
|internet        |  35.50000|     0.6825939|FALSE   |TRUE |

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
## Created from 264 samples and 54 variables
## 
## Pre-processing:
##   - centered (32)
##   - ignored (20)
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
## Number of complete cases after imputation = 291
```

```r
save(dfTrainPreProc, dfValid, dfTrain, nzv, preProc, df, file = "data/processed/dataframes.RData")
rm(dfTrainPreProc1, dfTrainPreProc2, dfTrainPreProc3)
```

Set the control parameters.


```r
ctrl <- trainControl(method = "repeatedcv",
                     number = 10,
                     repeats = 20,
                     savePredictions = TRUE,
                     allowParallel = TRUE,
                     search = "random")
cores <- 24
```

Set the model and tuning parameter grid.


```r
library(earth)
```

```
## Loading required package: plotmo
```

```
## Loading required package: plotrix
```

```
## Loading required package: TeachingDemos
```

```r
citation("earth")
```

```
## 
## To cite package 'earth' in publications use:
## 
##   Stephen Milborrow. Derived from mda:mars by Trevor Hastie and
##   Rob Tibshirani. Uses Alan Miller's Fortran utilities with Thomas
##   Lumley's leaps wrapper. (2018). earth: Multivariate Adaptive
##   Regression Splines. R package version 4.6.2.
##   https://CRAN.R-project.org/package=earth
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {earth: Multivariate Adaptive Regression Splines},
##     author = {Stephen Milborrow. Derived from mda:mars by Trevor Hastie and Rob Tibshirani. Uses Alan Miller's Fortran utilities with Thomas Lumley's leaps wrapper.},
##     year = {2018},
##     note = {R package version 4.6.2},
##     url = {https://CRAN.R-project.org/package=earth},
##   }
## 
## ATTENTION: This citation information has been auto-generated from
## the package DESCRIPTION file and may need manual editing, see
## 'help("citation")'.
```

```r
method <- "bagEarth"
modelLookup(method) %>% kable()
```



|model    |parameter |label          |forReg |forClass |probModel |
|:--------|:---------|:--------------|:------|:--------|:---------|
|bagEarth |nprune    |#Terms         |TRUE   |TRUE     |TRUE      |
|bagEarth |degree    |Product Degree |TRUE   |TRUE     |TRUE      |

```r
grid <- expand.grid(nprune = seq(10, 25, 5),
                    degree = seq(1, 3))
grid %>% kable()
```



| nprune| degree|
|------:|------:|
|     10|      1|
|     15|      1|
|     20|      1|
|     25|      1|
|     10|      2|
|     15|      2|
|     20|      2|
|     25|      2|
|     10|      3|
|     15|      3|
|     20|      3|
|     25|      3|



# Model PCB1


## PCB1 Total

Prediction model for `PCB1`.

Train model over the tuning parameters.


```
## Bagged MARS 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 261, 263, 263, 261, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE          Rsquared    MAE         
##   1       10      1.574837e+01  0.05540989  1.277689e+01
##   1       15      1.582314e+01  0.06192035  1.274687e+01
##   1       20      1.595397e+01  0.06159687  1.277567e+01
##   1       25      1.606208e+01  0.06689421  1.281447e+01
##   2       10      1.601275e+01  0.04520621  1.297763e+01
##   2       15      1.600149e+01  0.05416004  1.292555e+01
##   2       20      1.616206e+01  0.05657127  1.300913e+01
##   2       25      1.929541e+11  0.05203315  3.522843e+10
##   3       10      7.499448e+11  0.04540263  1.936349e+11
##   3       15      1.616257e+01  0.05010961  1.308101e+01
##   3       20      1.817331e+01  0.04919533  1.354397e+01
##   3       25      1.657542e+01  0.04905873  1.324094e+01
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 10 and degree = 1.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)

![plot of chunk PCB1_Total_Training-varImp](figures/PCB1_Total_Training-varImp-1.png)

|variable                       |     Overall|
|:------------------------------|-----------:|
|zipcode97702                   | 100.0000000|
|ECBI_Opp                       |  81.0025383|
|MAPS_WM                        |  66.2294309|
|MAPS_HS                        |  57.6780858|
|MAPS_POS                       |  48.6745282|
|ECBI_intensity_clinical_cutoff |  33.1093798|
|MAPS_LC                        |  27.3342886|
|parentAge                      |  15.7049687|
|parentRaceWhite1               |   8.6255846|
|totalChildren                  |   4.1695164|
|birthOrderOldest               |   2.6075872|
|birthOrderMiddle               |   1.1134081|
|birthOrderYoungest             |   0.8267947|




```
##       RMSE   Rsquared        MAE 
## 13.5539683  0.3783157 11.0601165
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.6150737
## hat         0.6150737 1.0000000
```

![plot of chunk PCB1_Total_Training-predict](figures/PCB1_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 17.9171796  0.1064851 13.7003319
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.3263205
## hat         0.3263205 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Bagged MARS 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 261, 262, 263, 262, 263, 262, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE          Rsquared    MAE         
##   1       10      4.314444e+00  0.06145722  3.275995e+00
##   1       15      4.357480e+00  0.06227722  3.301836e+00
##   1       20      4.403159e+00  0.06321870  3.336516e+00
##   1       25      4.450431e+00  0.06555312  3.368793e+00
##   2       10      1.276642e+13  0.04261745  2.330818e+12
##   2       15      4.408622e+00  0.05147890  3.375237e+00
##   2       20      1.744382e+11  0.04323992  3.133002e+10
##   2       25      2.566624e+11  0.04606110  4.831126e+10
##   3       10      9.577125e+10  0.04666273  1.748536e+10
##   3       15      8.086093e+12  0.04827366  1.546580e+12
##   3       20      1.212802e+13  0.05141696  2.243370e+12
##   3       25      1.424427e+13  0.04407816  2.645094e+12
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 10 and degree = 1.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)

![plot of chunk PCB2_Total_Training-varImp](figures/PCB2_Total_Training-varImp-1.png)

|variable           |    Overall|
|:------------------|----------:|
|zipcode97210       | 100.000000|
|ECBI_Cond          |  85.661391|
|communityRural     |  74.217498|
|SEPTI_nurturance   |  61.788831|
|MAPS_POS           |  49.209089|
|SEPTI_total        |  33.451459|
|totalChildren      |  22.707848|
|birthOrderOldest   |  13.048498|
|birthOrderMiddle   |   5.538213|
|birthOrderYoungest |   1.621724|




```
##      RMSE  Rsquared       MAE 
## 3.7050576 0.3599573 2.8418667
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.5999645
## hat      0.5999645 1.0000000
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##      RMSE  Rsquared       MAE 
## 4.9412675 0.0480414 3.5182813
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2191835
## hat      0.2191835 1.0000000
```

![plot of chunk PCB2_Tot_Validation-predict](figures/PCB2_Tot_Validation-predict-1.png)



# Model PCB3


## Total PCB3

Prediction model for `PCB3_Total`.

Train model over the tuning parameters.


```
## Bagged MARS 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 263, 262, 261, 263, 263, 261, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE          Rsquared    MAE         
##   1       10      1.150010e+01  0.10240232  9.417835e+00
##   1       15      1.162266e+01  0.09831686  9.467367e+00
##   1       20      1.178623e+01  0.09134015  9.564054e+00
##   1       25      1.191416e+01  0.08962617  9.657502e+00
##   2       10      1.153440e+01  0.09899232  9.428406e+00
##   2       15      1.172502e+01  0.08887191  9.537490e+00
##   2       20      1.024595e+13  0.08785431  1.870646e+12
##   2       25      1.204480e+01  0.08155880  9.717507e+00
##   3       10      1.159758e+01  0.09474052  9.469746e+00
##   3       15      3.787058e+12  0.08801546  7.045800e+11
##   3       20      2.225477e+12  0.08324888  5.132930e+11
##   3       25      1.295005e+13  0.07760038  2.447330e+12
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 10 and degree = 1.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)

![plot of chunk PCB3_Total_Training-varImp](figures/PCB3_Total_Training-varImp-1.png)

|variable                |     Overall|
|:-----------------------|-----------:|
|MAPS_LC                 | 100.0000000|
|zipcode97702            |  80.0381388|
|SEPTI_nurturance        |  68.1961196|
|parentAge               |  53.3490979|
|SEPTI_total_clin_cutoff |  44.1289882|
|ECBI_Opp                |  36.7076313|
|totalChildren           |  18.3447327|
|birthOrderOldest        |  13.5358150|
|birthOrderMiddle        |   5.8617013|
|birthOrderYoungest      |   4.3517408|
|childSexMale            |   0.9039616|




```
##      RMSE  Rsquared       MAE 
## 9.8301596 0.3697493 8.1257636
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.6080701
## hat         0.6080701 1.0000000
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##      RMSE  Rsquared       MAE 
## 11.845462  0.188794  9.549438
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.4345043
## hat         0.4345043 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



