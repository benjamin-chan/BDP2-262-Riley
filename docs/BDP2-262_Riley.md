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
grid <- expand.grid(nprune = c(seq(2, 9, 1), seq(10, 25, 5)),
                    degree = seq(1, 2))
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
|     25|      1|
|      2|      2|
|      3|      2|
|      4|      2|
|      5|      2|
|      6|      2|
|      7|      2|
|      8|      2|
|      9|      2|
|     10|      2|
|     15|      2|
|     20|      2|
|     25|      2|



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
##   degree  nprune  RMSE          Rsquared    MAE         
##   1        2      1.573251e+01  0.04178090  1.286935e+01
##   1        3      1.566115e+01  0.05077941  1.278021e+01
##   1        4      1.568218e+01  0.05445881  1.278222e+01
##   1        5      1.564898e+01  0.06023598  1.276616e+01
##   1        6      1.569336e+01  0.05748855  1.276867e+01
##   1        7      1.566166e+01  0.05925569  1.274424e+01
##   1        8      1.570418e+01  0.05811987  1.276808e+01
##   1        9      1.567499e+01  0.06173532  1.272622e+01
##   1       10      1.571189e+01  0.06711082  1.273297e+01
##   1       15      1.579341e+01  0.06528185  1.272427e+01
##   1       20      1.598098e+01  0.06474146  1.280696e+01
##   1       25      1.604640e+01  0.07004435  1.279120e+01
##   2        2      1.576508e+01  0.03932520  1.290383e+01
##   2        3      1.576818e+01  0.04729379  1.289574e+01
##   2        4      1.588229e+01  0.04278789  1.295967e+01
##   2        5      1.584262e+01  0.04731023  1.292127e+01
##   2        6      1.589999e+01  0.05186708  1.292754e+01
##   2        7      1.587526e+01  0.04611525  1.296406e+01
##   2        8      2.872595e+11  0.04424915  5.244616e+10
##   2        9      1.591365e+01  0.04659289  1.297582e+01
##   2       10      1.593309e+01  0.04763817  1.296760e+01
##   2       15      1.601536e+01  0.05435705  1.297413e+01
##   2       20      1.950433e+12  0.05158615  5.260772e+11
##   2       25      1.636903e+01  0.05742700  1.312067e+01
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 5 and degree = 1.
```

```
## Warning: Removed 2 rows containing missing values (geom_point).
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)

![plot of chunk PCB1_Total_Training-varImp](figures/PCB1_Total_Training-varImp-1.png)

|variable                       |    Overall|
|:------------------------------|----------:|
|zipcode97210                   | 100.000000|
|SEPTI_discipline               |  70.948436|
|SEPTI_total                    |  50.381256|
|ECBI_intensity_clinical_cutoff |  18.347194|
|MAPS_PR                        |   6.258510|
|MAPS_POS                       |   1.880474|




```
##       RMSE   Rsquared        MAE 
## 14.4398692  0.2587313 11.7833250
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.5086564
## hat         0.5086564 1.0000000
```

![plot of chunk PCB1_Total_Training-predict](figures/PCB1_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 17.7350253  0.1525722 13.7206811
```

```
##            PCB1_Total      hat
## PCB1_Total   1.000000 0.390605
## hat          0.390605 1.000000
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
## Summary of sample sizes: 262, 261, 262, 262, 262, 264, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE          Rsquared    MAE         
##   1        2      4.316921e+00  0.04000880  3.295651e+00
##   1        3      4.308281e+00  0.05995362  3.283823e+00
##   1        4      4.303222e+00  0.05831514  3.273712e+00
##   1        5      4.299292e+00  0.06238214  3.269456e+00
##   1        6      4.296155e+00  0.06321067  3.266320e+00
##   1        7      4.295574e+00  0.06716339  3.265791e+00
##   1        8      4.308358e+00  0.06555953  3.269270e+00
##   1        9      4.318388e+00  0.06312943  3.280786e+00
##   1       10      4.314612e+00  0.06621458  3.277206e+00
##   1       15      4.356758e+00  0.06892043  3.305675e+00
##   1       20      4.401141e+00  0.07172239  3.342538e+00
##   1       25      4.462524e+00  0.06598628  3.384834e+00
##   2        2      4.320844e+00  0.03710026  3.310705e+00
##   2        3      4.334469e+00  0.04694285  3.317133e+00
##   2        4      5.049593e+11  0.04342782  9.219254e+10
##   2        5      4.349524e+00  0.05087915  3.337321e+00
##   2        6      4.356170e+00  0.05113881  3.332915e+00
##   2        7      4.376469e+00  0.05155475  3.362577e+00
##   2        8      9.714862e+12  0.04979487  1.773683e+12
##   2        9      4.380872e+00  0.04953488  3.358250e+00
##   2       10      9.487166e+11  0.05489104  2.194333e+11
##   2       15      5.477084e+11  0.05373916  1.017069e+11
##   2       20      4.489570e+00  0.05497746  3.435572e+00
##   2       25      4.538570e+00  0.05728584  3.482786e+00
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 7 and degree = 1.
```

```
## Warning: Removed 4 rows containing missing values (geom_point).
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)

![plot of chunk PCB2_Total_Training-varImp](figures/PCB2_Total_Training-varImp-1.png)

|variable         |     Overall|
|:----------------|-----------:|
|zipcode97123     | 100.0000000|
|MAPS_PR          |  84.0973305|
|SEPTI_discipline |  70.7897318|
|zipcode97702     |  49.6491419|
|MAPS_NEG         |  31.5770362|
|ECBI_Cond        |  14.7587225|
|totalChildren    |   4.7461292|
|birthOrderOldest |   0.7214382|




```
##      RMSE  Rsquared       MAE 
## 3.8130494 0.3222671 2.9341590
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.5676857
## hat      0.5676857 1.0000000
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 4.92112044 0.05318398 3.47778450
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2306165
## hat      0.2306165 1.0000000
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
## Summary of sample sizes: 262, 262, 263, 260, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE          Rsquared    MAE         
##   1        2      1.156092e+01  0.08571610  9.605273e+00
##   1        3      1.150477e+01  0.08903020  9.554634e+00
##   1        4      1.146466e+01  0.08831781  9.501099e+00
##   1        5      1.145965e+01  0.09190011  9.473041e+00
##   1        6      1.147555e+01  0.09008379  9.464466e+00
##   1        7      1.146559e+01  0.09657359  9.452317e+00
##   1        8      1.153382e+01  0.08640716  9.485018e+00
##   1        9      1.149044e+01  0.09599645  9.442515e+00
##   1       10      1.152473e+01  0.09252961  9.465227e+00
##   1       15      1.166215e+01  0.09129457  9.536157e+00
##   1       20      1.180528e+01  0.08610311  9.607804e+00
##   1       25      1.196708e+01  0.08353391  9.704657e+00
##   2        2      1.156426e+01  0.08867485  9.617039e+00
##   2        3      1.152263e+01  0.08535336  9.563568e+00
##   2        4      1.145716e+01  0.09751990  9.494914e+00
##   2        5      1.148319e+01  0.08892784  9.505452e+00
##   2        6      1.147394e+01  0.09304805  9.458363e+00
##   2        7      3.570434e+11  0.09578670  6.630129e+10
##   2        8      1.149325e+01  0.09523210  9.425823e+00
##   2        9      1.161565e+01  0.09440166  9.487210e+00
##   2       10      1.157380e+01  0.09203896  9.477977e+00
##   2       15      1.174855e+01  0.08246722  9.554296e+00
##   2       20      1.190513e+01  0.08259825  9.642320e+00
##   2       25      1.098507e+13  0.07732271  2.075984e+12
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 4 and degree = 2.
```

```
## Warning: Removed 1 rows containing missing values (geom_path).
```

```
## Warning: Removed 2 rows containing missing values (geom_point).
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)

![plot of chunk PCB3_Total_Training-varImp](figures/PCB3_Total_Training-varImp-1.png)

|variable         |    Overall|
|:----------------|----------:|
|SEPTI_discipline | 100.000000|
|ECBI_Opp         |  77.777897|
|totalChildren    |  47.671907|
|birthOrderOldest |  24.585690|
|birthOrderMiddle |   7.240989|




```
##       RMSE   Rsquared        MAE 
## 10.5743108  0.2978338  8.8284154
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.5457415
## hat         0.5457415 1.0000000
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.8328439  0.2935624  9.5104772
```

```
##            PCB3_Total      hat
## PCB3_Total   1.000000 0.541814
## hat          0.541814 1.000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



