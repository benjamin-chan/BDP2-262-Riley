---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-18"
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

Split data set into 70:30 training:validation samples.


```r
inTrain <- createDataPartition(df$id, p = 0.7)
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
method <- "earth"
modelLookup(method) %>% kable()
```



|model |parameter |label          |forReg |forClass |probModel |
|:-----|:---------|:--------------|:------|:--------|:---------|
|earth |nprune    |#Terms         |TRUE   |TRUE     |TRUE      |
|earth |degree    |Product Degree |TRUE   |TRUE     |TRUE      |

```r
grid <- expand.grid(nprune = c(seq(2, 8, 1), seq(10, 50, 10)),
                    degree = seq(4))
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
|     10|      1|
|     20|      1|
|     30|      1|
|     40|      1|
|     50|      1|
|      2|      2|
|      3|      2|
|      4|      2|
|      5|      2|
|      6|      2|
|      7|      2|
|      8|      2|
|     10|      2|
|     20|      2|
|     30|      2|
|     40|      2|
|     50|      2|
|      2|      3|
|      3|      3|
|      4|      3|
|      5|      3|
|      6|      3|
|      7|      3|
|      8|      3|
|     10|      3|
|     20|      3|
|     30|      3|
|     40|      3|
|     50|      3|
|      2|      4|
|      3|      4|
|      4|      4|
|      5|      4|
|      6|      4|
|      7|      4|
|      8|      4|
|     10|      4|
|     20|      4|
|     30|      4|
|     40|      4|
|     50|      4|



# Model PCB1


## PCB1 Total

Prediction model for `PCB1`.

Train model over the tuning parameters.


```
## Multivariate Adaptive Regression Spline 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared     MAE     
##    2      1       16.20067  0.062699175  12.90537
##    2      2       16.20067  0.062699175  12.90537
##    2      3       16.68682  0.025391386  13.29963
##    2      4       16.60798  0.026109805  13.32090
##    3      1       16.35646  0.052370250  13.03570
##    3      2       16.41255  0.051857148  13.08261
##    3      3       17.25806  0.012134139  13.74201
##    3      4       16.81878  0.034032785  13.49541
##    4      1       16.63407  0.040927334  13.45923
##    4      2       16.50871  0.049713615  13.14638
##    4      3       17.20046  0.020130745  13.57525
##    4      4       17.02655  0.030055598  13.51229
##    5      1       16.84651  0.035532633  13.72202
##    5      2       16.52789  0.052325422  13.03720
##    5      3       17.70009  0.010562900  13.95441
##    5      4       17.66054  0.015338781  13.82202
##    6      1       16.97112  0.032192378  13.74024
##    6      2       16.61792  0.059103469  13.14951
##    6      3       17.70347  0.019170781  13.76193
##    6      4       17.66695  0.015307940  13.74994
##    7      1       17.05672  0.031988939  13.79038
##    7      2       16.65343  0.066988027  12.99330
##    7      3       18.37568  0.011499457  14.15330
##    7      4       17.79673  0.017845614  13.69375
##    8      1       17.27535  0.024627816  13.87490
##    8      2       17.18170  0.038961373  13.59131
##    8      3       18.37145  0.018938874  14.14801
##    8      4       18.21069  0.007695410  14.10425
##   10      1       18.21591  0.009890400  14.30153
##   10      2       17.66397  0.037331969  13.93320
##   10      3       18.61372  0.016756680  14.24491
##   10      4       19.52552  0.003453360  14.81309
##   20      1       18.82317  0.012777998  14.67125
##   20      2       18.87256  0.050178782  14.78020
##   20      3       19.15453  0.045283035  14.51852
##   20      4       23.33419  0.013992489  16.93958
##   30      1       19.23424  0.007772567  14.99711
##   30      2       20.10002  0.046678612  15.83050
##   30      3       21.31101  0.041161677  16.07388
##   30      4       33.52405  0.014390996  19.14120
##   40      1       19.36410  0.006820354  15.00978
##   40      2       20.15331  0.049140455  16.04780
##   40      3       23.70510  0.046843537  16.83290
##   40      4       35.30708  0.011023769  19.97068
##   50      1       19.42693  0.006053500  15.05409
##   50      2       20.15859  0.048946745  16.05281
##   50      3       23.74034  0.048125613  16.89629
##   50      4       36.16640  0.008952167  20.66012
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 2 and degree = 1.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)


```
## Selected 2 of 120 terms, and 1 of 161 predictors
## Termination condition: GRSq -10 at 120 terms
## Importance: parentRaceWhite1, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 264.8591    RSS 70196.46    GRSq 0.06059551    RSq 0.07446106
```

```
## Call: earth(x=matrix[271,161], y=c(73,77,76,38,7...), keepxy=TRUE,
##             degree=1, nprune=2)
## 
##                  coefficients
## (Intercept)          74.22368
## parentRaceWhite1    -10.16215
## 
## Selected 2 of 120 terms, and 1 of 161 predictors
## Termination condition: GRSq -10 at 120 terms
## Importance: parentRaceWhite1, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 264.8591    RSS 70196.46    GRSq 0.06059551    RSq 0.07446106
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 161)
## 
##                                 Overall
## parentRaceWhite1                    100
## zipcode97215                          0
## ECBI_intensity_T_score                0
## MAPS_PR                               0
## income$80,000-$119,999                0
## parentMaritalStatusRemarried          0
## zipcode97267                          0
## zipcode97027                          0
## parentMaritalStatusNevermarried       0
## MAPS_SP                               0
## zipcode97702                          0
## birthOrderMiddle                      0
## zipcode97203                          0
## zipcode97086                          0
## zipcode97210                          0
## parentRaceNoResp1                     0
## childRelationshipOther                0
## zipcode97757                          0
## ECBI_Opp                              0
## childAge                              0
```


```
##        RMSE    Rsquared         MAE 
## 16.08180802  0.07281038 12.81580213
```

```
##            PCB2_Tot        hat
## PCB2_Tot 1.00000000 0.09767668
## hat      0.09767668 1.00000000
```

```
## Warning: Removed 1 rows containing non-finite values (stat_smooth).

## Warning: Removed 1 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

![plot of chunk PCB1_Total_Training-predict](figures/PCB1_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##        RMSE    Rsquared         MAE 
## 15.70888010  0.03426741 12.44589271
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.1851146
## hat         0.1851146 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Multivariate Adaptive Regression Spline 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared      MAE     
##    2      1       4.738926  0.8475635985  3.557317
##    2      2       4.765900  0.0035392603  3.574807
##    2      3       4.723706  0.0071082414  3.522137
##    2      4       4.720958  0.0047245785  3.521926
##    3      1       5.061439  0.0655361908  3.796143
##    3      2       4.800874  0.0028432392  3.609067
##    3      3       4.687675  0.0280944209  3.515861
##    3      4       4.789969  0.0036261228  3.633382
##    4      1       4.964319  0.0099528456  3.628885
##    4      2       4.709539  0.0312694189  3.516033
##    4      3       5.039440  0.0171229210  3.539220
##    4      4       5.167980  0.0007664401  3.685734
##    5      1       5.083947  0.0132531273  3.760566
##    5      2       4.845760  0.0276626751  3.554804
##    5      3       4.954395  0.0270072426  3.474490
##    5      4       5.147534  0.0022937414  3.680845
##    6      1       5.208465  0.0235072815  3.871535
##    6      2       4.913492  0.0229056037  3.591207
##    6      3       5.242755  0.0165796295  3.618596
##    6      4       5.519560  0.0001524131  3.839393
##    7      1       5.219464  0.0120464306  3.798592
##    7      2       5.023329  0.0091262531  3.721732
##    7      3       5.173486  0.0198799100  3.622751
##    7      4       5.301426  0.0001273598  3.794933
##    8      1       5.140246  0.0015512469  3.712038
##    8      2       5.327459  0.0132203933  3.915551
##    8      3       5.333522  0.0188424339  3.801187
##    8      4       5.363422  0.0001438160  3.861254
##   10      1       5.154944  0.0003207424  3.836867
##   10      2       5.155930  0.0214618780  3.858015
##   10      3       5.524321  0.0119167548  3.880097
##   10      4       5.323123  0.0022787916  3.899070
##   20      1       5.294185  0.0087117884  3.961219
##   20      2       6.225093  0.0213541537  4.109923
##   20      3       5.799607  0.0159615990  4.175976
##   20      4       6.221616  0.0028363320  4.399923
##   30      1       5.477977  0.0070030137  4.156108
##   30      2       6.303116  0.0301781216  4.252620
##   30      3       6.075656  0.0184901149  4.343537
##   30      4       6.892230  0.0002584523  4.834679
##   40      1       5.499438  0.0068773190  4.186732
##   40      2       6.348231  0.0297914733  4.301491
##   40      3       6.204967  0.0163185364  4.463410
##   40      4       7.130278  0.0036043641  5.053999
##   50      1       5.502954  0.0067460377  4.196348
##   50      2       6.347627  0.0298154889  4.300960
##   50      3       6.281860  0.0129567561  4.520481
##   50      4       7.407793  0.0067595084  5.213648
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 3 and degree = 3.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)


```
## Selected 2 of 69 terms, and 2 of 161 predictors
## Termination condition: RSq changed by less than 0.001 at 69 terms
## Importance: zipcode97702, communityRural, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 0 1
## GCV 21.09831    RSS 5570.907    GRSq 0.05969828    RSq 0.07703066
```

```
## Call: earth(x=matrix[271,161], y=c(25,29,25,22,2...), keepxy=TRUE,
##             degree=3, nprune=3)
## 
##                               coefficients
## (Intercept)                       24.51866
## zipcode97702 * communityRural    -12.51866
## 
## Selected 2 of 69 terms, and 2 of 161 predictors
## Termination condition: RSq changed by less than 0.001 at 69 terms
## Importance: zipcode97702, communityRural, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 0 1
## GCV 21.09831    RSS 5570.907    GRSq 0.05969828    RSq 0.07703066
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 161)
## 
##                                                 Overall
## communityRural                                      100
## zipcode97702                                        100
## parentSituationCo-parentinginseparatehouseholds       0
## parentGenderFemale                                    0
## MAPS_PP                                               0
## zipcode97140                                          0
## ECBI_problem_T_score                                  0
## zipcode97754                                          0
## communitySuburban                                     0
## SEPTI_discipline                                      0
## income$150,000ormore                                  0
## parentSexMale                                         0
## childRaceWhite1                                       0
## parentChildRatio                                      0
## zipcode97023                                          0
## MAPS_NEG                                              0
## zipcode97325                                          0
## income$25,001-$49,999                                 0
## birthOrderYoungest                                    0
## zipcode97003                                          0
```


```
##       RMSE   Rsquared        MAE 
## 4.52820018 0.07684678 3.43721192
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2772125
## hat      0.2772125 1.0000000
```

```
## Warning: Removed 1 rows containing non-finite values (stat_smooth).

## Warning: Removed 1 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 4.15448482 0.01646725 3.20589552
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.1283248
## hat      0.1283248 1.0000000
```

![plot of chunk PCB2_Tot_Validation-predict](figures/PCB2_Tot_Validation-predict-1.png)



# Model PCB3


## Total PCB3

Prediction model for `PCB3_Total`.

Train model over the tuning parameters.


| nprune| degree|
|------:|------:|
|      7|      1|
|      8|      1|
|      9|      1|
|     10|      1|
|     11|      1|
|     12|      1|
|     20|      1|
|     30|      1|
|     40|      1|
|     50|      1|
|      7|      2|
|      8|      2|
|      9|      2|
|     10|      2|
|     11|      2|
|     12|      2|
|     20|      2|
|     30|      2|
|     40|      2|
|     50|      2|
|      7|      3|
|      8|      3|
|      9|      3|
|     10|      3|
|     11|      3|
|     12|      3|
|     20|      3|
|     30|      3|
|     40|      3|
|     50|      3|

```
## Multivariate Adaptive Regression Spline 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 270, 270, 270, 270, 270, 270, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared     MAE      
##    7      1       11.89024  0.046735782   9.697572
##    7      2       12.98940  0.010998518  10.006925
##    7      3       11.93928  0.060003219   9.499099
##    8      1       12.25892  0.021609344   9.880644
##    8      2       13.18927  0.010811400   9.983937
##    8      3       12.01644  0.057286131   9.609710
##    9      1       12.45805  0.021619001   9.982546
##    9      2       13.44427  0.005227253  10.203121
##    9      3       12.13227  0.056751108   9.729840
##   10      1       12.39110  0.031686320   9.854439
##   10      2       13.42530  0.005798694  10.319450
##   10      3       12.53124  0.043148426   9.858555
##   11      1       12.45640  0.028214457   9.933379
##   11      2       13.46566  0.006875640  10.301301
##   11      3       12.40648  0.053881842   9.776370
##   12      1       12.57727  0.022711722  10.052099
##   12      2       13.38588  0.011421295  10.170620
##   12      3       12.44171  0.058961884   9.845559
##   20      1       13.66106  0.005493263  10.773537
##   20      2       13.69188  0.023534235  10.401977
##   20      3       18.00410  0.026639776  11.040946
##   30      1       14.21114  0.007861517  10.952900
##   30      2       14.23533  0.013270453  10.839146
##   30      3       19.51705  0.034879936  11.724791
##   40      1       14.39845  0.006998174  11.096557
##   40      2       14.25613  0.013470241  10.826069
##   40      3       20.61056  0.043031753  12.314697
##   50      1       14.38219  0.007624427  11.075679
##   50      2       14.25613  0.013470241  10.826069
##   50      3       20.72018  0.042367538  12.467801
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 7 and degree = 1.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)


```
## Selected 6 of 119 terms, and 3 of 161 predictors
## Termination condition: GRSq -10 at 119 terms
## Importance: ECBI_intensity_T_score, MAPS_LC, SEPTI_nurturance, ...
## Number of terms at each degree of interaction: 1 5 (additive model)
## GCV 125.9221    RSS 31410.83    GRSq 0.1098164    RSq 0.1745348
```

```
## Call: earth(x=matrix[271,161], y=c(58,54,64,41,5...), keepxy=TRUE,
##             degree=1, nprune=7)
## 
##                                    coefficients
## (Intercept)                           40.979163
## h(-1.4681-ECBI_intensity_T_score)     14.703186
## h(ECBI_intensity_T_score- -1.4681)     2.787303
## h(-0.460716-MAPS_LC)                  -8.930168
## h(-0.0628444-SEPTI_nurturance)         3.361093
## h(SEPTI_nurturance- -0.0628444)        5.706977
## 
## Selected 6 of 119 terms, and 3 of 161 predictors
## Termination condition: GRSq -10 at 119 terms
## Importance: ECBI_intensity_T_score, MAPS_LC, SEPTI_nurturance, ...
## Number of terms at each degree of interaction: 1 5 (additive model)
## GCV 125.9221    RSS 31410.83    GRSq 0.1098164    RSq 0.1745348
```

![plot of chunk PCB3_Total_Training-finalModel](figures/PCB3_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 161)
## 
##                                  Overall
## ECBI_intensity_T_score            100.00
## MAPS_LC                            79.06
## SEPTI_nurturance                   48.27
## childRelationshipRelative           0.00
## MAPS_SP                             0.00
## MAPS_POS                            0.00
## childRaceAsian1                     0.00
## zipcode97210                        0.00
## communityRural                      0.00
## ECBI_intensity_clinical_cutoff      0.00
## zipcode97217                        0.00
## zipcode97124                        0.00
## zipcode97027                        0.00
## childEthnicityNotHispanic/Latino    0.00
## zipcode97220                        0.00
## zipcode97032                        0.00
## zipcode97086                        0.00
## SEPTI_total_clin_cutoff             0.00
## parentRaceNoResp1                   0.00
## zipcode97140                        0.00
```


```
##      RMSE  Rsquared       MAE 
## 10.752374  0.175924  8.627267
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.1812032
## hat      0.1812032 1.0000000
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.5940115  0.1472462  9.6520793
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.3837267
## hat         0.3837267 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



