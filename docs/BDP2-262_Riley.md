---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-27"
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
                     repeats = 10,
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
grid <- expand.grid(nprune = c(seq(2, 9, 1), seq(10, 20, 5)),
                    degree = 1)
grid %>% kable()
```



| nprune| degree|
|------:|------:|
|      2|      1|
|      3|      1|
|      4|      1|
|      5|      1|
|      6|      1|
|      7|      1|
|      8|      1|
|      9|      1|
|     10|      1|
|     15|      1|
|     20|      1|



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
## Resampling: Cross-Validated (10 fold, repeated 10 times) 
## Summary of sample sizes: 261, 263, 263, 261, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   nprune  RMSE      Rsquared    MAE     
##    2      15.74837  0.04075392  12.87834
##    3      15.67317  0.04823170  12.77305
##    4      15.66999  0.05079536  12.76927
##    5      15.62701  0.05904268  12.73300
##    6      15.67466  0.05568217  12.77803
##    7      15.66848  0.06020719  12.73589
##    8      15.73151  0.05595855  12.80302
##    9      15.72864  0.05860294  12.77428
##   10      15.73144  0.06245847  12.75535
##   15      15.85905  0.06046205  12.79040
##   20      15.92524  0.06566826  12.79684
## 
## Tuning parameter 'degree' was held constant at a value of 1
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 5 and degree = 1.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)

![plot of chunk PCB1_Total_Training-varImp](figures/PCB1_Total_Training-varImp-1.png)

|variable                     |    Overall|
|:----------------------------|----------:|
|childRaceWhite1              | 100.000000|
|MAPS_HS                      |  78.278812|
|MAPS_SP                      |  48.261261|
|zipcode97325                 |  26.312871|
|parentMaritalStatusSeparated |   6.953803|
|SEPTI_discipline             |   2.109540|
|SEPTI_total                  |   0.937654|




```
##       RMSE   Rsquared        MAE 
## 14.4209179  0.2551321 11.7697091
```

```
##            PCB1_Total      hat
## PCB1_Total   1.000000 0.505106
## hat          0.505106 1.000000
```

![plot of chunk PCB1_Total_Training-predict](figures/PCB1_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 17.9851222  0.1039878 13.8753277
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.3224714
## hat         0.3224714 1.0000000
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
## Resampling: Cross-Validated (10 fold, repeated 10 times) 
## Summary of sample sizes: 263, 261, 263, 262, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   nprune  RMSE      Rsquared    MAE     
##    2      4.319944  0.05273309  3.294298
##    3      4.314337  0.05819237  3.284545
##    4      4.305675  0.05651808  3.275975
##    5      4.305110  0.05401634  3.276022
##    6      4.305036  0.05800955  3.267395
##    7      4.311454  0.05720017  3.273882
##    8      4.313036  0.05651665  3.274898
##    9      4.315909  0.05702546  3.278187
##   10      4.312015  0.06007262  3.275315
##   15      4.365279  0.05661681  3.309819
##   20      4.405090  0.05862837  3.339554
## 
## Tuning parameter 'degree' was held constant at a value of 1
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 6 and degree = 1.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)

![plot of chunk PCB2_Total_Training-varImp](figures/PCB2_Total_Training-varImp-1.png)

|variable         |    Overall|
|:----------------|----------:|
|SEPTI_discipline | 100.000000|
|SEPTI_total      |  75.556611|
|zipcode97702     |  63.379081|
|zipcode97210     |  44.409026|
|MAPS_POS         |  17.512654|
|totalChildren    |   8.708317|




```
##      RMSE  Rsquared       MAE 
## 3.8654487 0.2714033 2.9648018
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.5209638
## hat      0.5209638 1.0000000
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 4.93520927 0.05291807 3.48080867
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2300393
## hat      0.2300393 1.0000000
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
## Resampling: Cross-Validated (10 fold, repeated 10 times) 
## Summary of sample sizes: 262, 262, 262, 263, 261, 261, ... 
## Resampling results across tuning parameters:
## 
##   nprune  RMSE      Rsquared    MAE     
##    2      11.53176  0.09508904  9.570356
##    3      11.46565  0.10178068  9.500293
##    4      11.41050  0.11083703  9.437381
##    5      11.41801  0.10699896  9.425560
##    6      11.42676  0.10372935  9.411713
##    7      11.43381  0.10551998  9.404470
##    8      11.44510  0.10373924  9.400230
##    9      11.49922  0.10271975  9.425596
##   10      11.48670  0.10735322  9.406348
##   15      11.63536  0.10202053  9.500001
##   20      11.79091  0.09035788  9.600144
## 
## Tuning parameter 'degree' was held constant at a value of 1
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 4 and degree = 1.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)

![plot of chunk PCB3_Total_Training-varImp](figures/PCB3_Total_Training-varImp-1.png)

|variable                |    Overall|
|:-----------------------|----------:|
|SEPTI_d_clinical_cutoff | 100.000000|
|SEPTI_nurturance        |  57.507706|
|zipcode97702            |  24.510919|
|totalChildren           |   5.975344|




```
##      RMSE  Rsquared       MAE 
## 10.804803  0.220301  8.957826
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.4693624
## hat         0.4693624 1.0000000
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.9969623  0.2258918  9.6100738
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.4752808
## hat         0.4752808 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



