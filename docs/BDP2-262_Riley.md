---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-08"
author: Benjamin Chan (chanb@ohsu.edu)
output:
  html_document:
    toc: true
    theme: simplex
---







# Import Andrew's SPSS data



Map new names to variables.


|oldnames                       |newnames                       |
|:------------------------------|:------------------------------|
|record_id                      |id                             |
|eng_span                       |languageSurvey                 |
|children_totv_1                |totalChildren                  |
|oldest_middle_youngest         |birthOrder                     |
|child_age_years                |childAge                       |
|Age_Dichot                     |childAgeDichotomous            |
|child_sexv_1                   |childSex                       |
|child_ethnicity                |childEthnicity                 |
|child_racev_1___1              |childRaceWhite                 |
|child_racev_1___2              |childRaceAsian                 |
|child_racev_1___3              |childRaceAfrAm                 |
|child_racev_1___4              |childRaceAIAN                  |
|child_racev_1___5              |childRaceNHPI                  |
|child_racev_1___6              |childRaceOther                 |
|child_racev_1___7              |childRaceNoResp                |
|visit_typev_1                  |visitType                      |
|related_child                  |childRelationship              |
|gender                         |parentGender                   |
|parent_sexv_1                  |parentSex                      |
|parent_agev_1                  |parentAge                      |
|parent_ethnicity               |parentEthnicity                |
|parent_race___1                |parentRaceWhite                |
|parent_race___2                |parentRaceAsian                |
|parent_race___3                |parentRaceAfrAm                |
|parent_race___4                |parentRaceAIAN                 |
|parent_race___5                |parentRaceNHPI                 |
|parent_race___6                |parentRaceOther                |
|parent_race___7                |parentRaceNoResp               |
|marital_status                 |parentMaritalStatus            |
|parenting_situationv_1         |parentSituation                |
|zipcode                        |zipcode                        |
|community_type                 |community                      |
|distance                       |distance                       |
|parent_educationv_1            |parentEducation                |
|annual_income                  |income                         |
|internet                       |internet                       |
|ECBI_intensity_raw_score       |ECBI_intensity_raw_score       |
|ECBI_intensity_T_score         |ECBI_intensity_T_score         |
|ECBI_intensity_clinical_cutoff |ECBI_intensity_clinical_cutoff |
|ECBI_problem_raw_score         |ECBI_problem_raw_score         |
|ECBI_problem_T_score           |ECBI_problem_T_score           |
|ECBI_problem_clinical_cutoff   |ECBI_problem_clinical_cutoff   |
|ECBI_OPP_Tot                   |ECBI_OPP_Tot                   |
|ECBI_Inatt_Tot                 |ECBI_Inatt_Tot                 |
|ECBI_Cond_Tot                  |ECBI_Cond_Tot                  |
|MAPS_PP                        |MAPS_PP                        |
|MAPS_PR                        |MAPS_PR                        |
|MAPS_WM                        |MAPS_WM                        |
|MAPS_SP                        |MAPS_SP                        |
|MAPS_HS                        |MAPS_HS                        |
|MAPS_LC                        |MAPS_LC                        |
|MAPS_PC                        |MAPS_PC                        |
|MAPS_POS                       |MAPS_POS                       |
|MAPS_NEG                       |MAPS_NEG                       |
|SEPTI_nurturance               |SEPTI_nurturance               |
|SEPTI_n_clinical_cutoff        |SEPTI_n_clinical_cutoff        |
|SEPTI_discipline               |SEPTI_discipline               |
|SEPTI_d_clinical_cutoff        |SEPTI_d_clinical_cutoff        |
|SEPTI_play                     |SEPTI_play                     |
|SEPTI_p_clinical_cutoff        |SEPTI_p_clinical_cutoff        |
|SEPTI_routine                  |SEPTI_routine                  |
|SEPTI_r_clinical_cutoff        |SEPTI_r_clinical_cutoff        |
|SEPTI_total                    |SEPTI_total                    |
|SEPTI_total_clin_cutoff        |SEPTI_total_clin_cutoff        |
|Y1                             |Y1                             |
|Y2                             |Y2                             |
|Y3                             |Y3                             |



Build analysis data set.
Exclude if missing any dependent variable, `Y1`, `Y2`, `Y3`.

![figures/flowChart.png](figures/flowChart.png)


```
##        Y1              Y2              Y3       
##  Min.   :19.00   Min.   : 6.00   Min.   :15.00  
##  1st Qu.:60.00   1st Qu.:22.00   1st Qu.:39.00  
##  Median :75.00   Median :25.00   Median :48.00  
##  Mean   :71.34   Mean   :24.53   Mean   :47.56  
##  3rd Qu.:85.00   3rd Qu.:28.00   3rd Qu.:57.00  
##  Max.   :95.00   Max.   :30.00   Max.   :75.00
```





# Preprocess data

Initial preprocesssing that needs to be done that is common to `Y1`, `Y2`, and `Y3`.

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
## Number of complete cases before imputation = 247
```

```r
nzv <- 
  dfTrain %>% 
  select(-c(id, Y1, Y2, Y3)) %>% 
  nearZeroVar(names = TRUE, saveMetric = TRUE) %>%
  mutate(varname = row.names(.)) %>% 
  filter(nzv == TRUE) %>% 
  select(varname, freqRatio, percentUnique, zeroVar, nzv) 
nzv %>% kable()
```



|varname         | freqRatio| percentUnique|zeroVar |nzv  |
|:---------------|---------:|-------------:|:-------|:----|
|languageSurvey  |  53.80000|      0.729927|FALSE   |TRUE |
|childRaceAfrAm  |  26.40000|      0.729927|FALSE   |TRUE |
|childRaceAIAN   |  38.14286|      0.729927|FALSE   |TRUE |
|childRaceNHPI   |  44.66667|      0.729927|FALSE   |TRUE |
|childRaceOther  |  21.83333|      0.729927|FALSE   |TRUE |
|parentRaceAfrAm |  44.66667|      0.729927|FALSE   |TRUE |
|parentRaceAIAN  |  29.44444|      0.729927|FALSE   |TRUE |
|parentRaceNHPI  |  44.66667|      0.729927|FALSE   |TRUE |
|parentRaceOther |  20.07692|      0.729927|FALSE   |TRUE |
|internet        |  33.25000|      0.729927|FALSE   |TRUE |

```r
dfTrainPreProc1 <-
  dfTrain %>% 
  select(-one_of(nzv$varname))
dfOutcomes <- 
  dfTrainPreProc1 %>% 
  select(c(id, Y1, Y2, Y3))
dfTrainPreProc2 <- 
  dfTrainPreProc1 %>% 
  select(-c(id, Y1, Y2, Y3))
preProc <-
  dfTrainPreProc2 %>% 
  preProcess(method = c("nzv", "corr", "knnImpute"), verbose = TRUE)
```

```
##   2 highly correlated predictors were removed.
## Calculating 30 means for centering
## Calculating 30 standard deviations for scaling
```

```r
preProc
```

```
## Created from 247 samples and 53 variables
## 
## Pre-processing:
##   - centered (30)
##   - ignored (21)
##   - 5 nearest neighbor imputation (30)
##   - removed (2)
##   - scaled (30)
```

```r
dfTrainPreProc3 <-  
  predict(preProc, dfTrainPreProc2) %>% 
  mutate(childAgeDichotomous = case_when(is.na(childAgeDichotomous) & childAge < 3 ~ 1,
                                         is.na(childAgeDichotomous) & childAge >= 3 ~ 2,
                                         TRUE ~ as.numeric(childAgeDichotomous))) %>% 
  mutate(childAgeDichotomous = factor(childAgeDichotomous, 
                                      levels = seq(2), 
                                      labels = c("Under 3", "3 or older")))
dfTrainPreProc <- bind_cols(dfOutcomes, dfTrainPreProc3)
message(sprintf("Number of complete cases after imputation = %d",
                complete.cases(dfTrainPreProc) %>% sum()))
```

```
## Number of complete cases after imputation = 274
```

```r
save(dfTrainPreProc, dfValid, dfTrain, df, file = "data/processed/dataframes.RData")
dfTrainPreProc %>% write.csv("data/processed/dfTrainPreProc.csv", row.names = FALSE)
rm(dfTrainPreProc1, dfTrainPreProc2, dfTrainPreProc3)
```

Set the control parameters.


```r
ctrl <- trainControl(method = "repeatedcv",
                     number = 10,
                     repeats = 50,
                     savePredictions = TRUE,
                     allowParallel = TRUE,
                     search = "random")
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
method <- "earth"
modelLookup(method) %>% kable()
```



|model |parameter |label          |forReg |forClass |probModel |
|:-----|:---------|:--------------|:------|:--------|:---------|
|earth |nprune    |#Terms         |TRUE   |TRUE     |TRUE      |
|earth |degree    |Product Degree |TRUE   |TRUE     |TRUE      |

```r
grid <- expand.grid(nprune = seq(2, 8, 1),
                    degree = seq(3))
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
|      2|      2|
|      3|      2|
|      4|      2|
|      5|      2|
|      6|      2|
|      7|      2|
|      8|      2|
|      2|      3|
|      3|      3|
|      4|      3|
|      5|      3|
|      6|      3|
|      7|      3|
|      8|      3|

```r
citation(method)
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



# Model 1

Prediction model for `Y1`.

Train model over the tuning parameters.


```
## Warning in nominalTrainWorkflow(x = x, y = y, wts = weights, info =
## trainInfo, : There were missing values in resampled performance measures.
```

```
## Multivariate Adaptive Regression Spline 
## 
## 274 samples
##  51 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 50 times) 
## Summary of sample sizes: 247, 246, 247, 247, 247, 246, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE     
##   1       2       17.13406  0.07929239  13.71328
##   1       3       17.23651  0.08314674  13.78765
##   1       4       17.26866  0.08556012  13.85806
##   1       5       17.43226  0.07825704  13.94377
##   1       6       17.65325  0.06822519  14.11949
##   1       7       17.75137  0.07108870  14.18879
##   1       8       17.90116  0.06810602  14.25926
##   2       2       17.38415  0.06785644  13.93422
##   2       3       17.82426  0.06296132  14.18043
##   2       4       18.09926  0.05868106  14.40085
##   2       5       18.50074  0.05527826  14.62787
##   2       6       18.78379  0.05613203  14.75910
##   2       7       19.02022  0.05703011  14.86908
##   2       8       19.19281  0.06064838  14.97792
##   3       2       17.62777  0.06474974  14.09974
##   3       3       17.98996  0.07345258  14.20457
##   3       4       19.01632  0.06615987  14.64983
##   3       5       19.29056  0.06500075  14.83188
##   3       6       19.66481  0.06664439  15.02840
##   3       7       19.77798  0.06557503  15.12069
##   3       8       20.44010  0.06464180  15.37954
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 2 and degree = 1.
```

```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

![figures/Y1Training.png](figures/Y1Training.png)


```
## Selected 2 of 122 terms, and 1 of 163 predictors
## Termination condition: Reached nk 201
## Importance: childRaceWhite, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 292.0476    RSS 78278.36    GRSq 0.06414023    RSq 0.07780223
```

```
## Call: earth(x=matrix[274,163], y=c(77,79,80,40,7...), keepxy=TRUE,
##             degree=1, nprune=2)
## 
##                coefficients
## (Intercept)        80.30303
## childRaceWhite    -11.48091
## 
## Selected 2 of 122 terms, and 1 of 163 predictors
## Termination condition: Reached nk 201
## Importance: childRaceWhite, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 292.0476    RSS 78278.36    GRSq 0.06414023    RSq 0.07780223
```

![plot of chunk Y1Training-finalModel](figures/Y1Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 163)
## 
##                                             Overall
## childRaceWhite                                  100
## zipcode97702                                      0
## ECBI_Inatt_Tot                                    0
## SEPTI_discipline                                  0
## childRelationshipGrandparent                      0
## parentEducationVocationalschool/somecollege       0
## zipcode97239                                      0
## zipcode97223                                      0
## SEPTI_total                                       0
## childRelationshipStepparent                       0
## zipcode75502                                      0
## distance                                          0
## parentMaritalStatusNevermarried                   0
## zipcode97203                                      0
## zipcode97707                                      0
## communityRural                                    0
## visitTypeOther                                    0
## zipcode97027                                      0
## parentGenderFemale                                0
## communitySuburban                                 0
```

```{r Y1Training-predict)
dfTrainPred <- 
  dfTrainPreProc %>% 
  mutate(hat = predict(trainingModel, dfTrainPreProc) %>% as.numeric())
postResample(pred = dfTrainPred$hat, obs = dfTrainPred$Y1)
cor(dfTrainPred %>% select(Y1, hat))
dfTrainPred %>% 
  ggplot() +
  ggtitle(sprintf("Correlation = %.03f", cor(dfTrainPred %>% select(Y1, hat)) %>% .[1, 2])) +
  aes(x = hat, y = Y1) +
  geom_abline(slope = 1, intercept = 0) +
  geom_smooth(method = "lm", formula = y ~ x - 1, color = rgb(0, 0, 1, 0.5), se = FALSE) +
  geom_smooth(method = "lm", formula = y ~ x, color = rgb(1, 0, 0, 0.5), se = FALSE) +
  geom_point(alpha = 1/2)
```

Evaluate model on the validation sample.


```
##        RMSE    Rsquared         MAE 
## 17.28865022  0.02081483 13.95346623
```

```
##            Y1       hat
## Y1  1.0000000 0.1442734
## hat 0.1442734 1.0000000
```

![plot of chunk Y1Validation-predict](figures/Y1Validation-predict-1.png)



# Model 2

Prediction model for `Y2`.

Train model over the tuning parameters.


```
## Warning in nominalTrainWorkflow(x = x, y = y, wts = weights, info =
## trainInfo, : There were missing values in resampled performance measures.
```

```
## Multivariate Adaptive Regression Spline 
## 
## 274 samples
##  51 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 50 times) 
## Summary of sample sizes: 247, 247, 246, 247, 246, 245, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE     
##   1       2       4.418233  0.05036974  3.384833
##   1       3       4.410074  0.06302883  3.348780
##   1       4       4.338489  0.09519097  3.275891
##   1       5       4.300901  0.11368059  3.246480
##   1       6       4.375873  0.09810081  3.313028
##   1       7       4.412169  0.09345659  3.346279
##   1       8       4.470584  0.08664421  3.390465
##   2       2       4.667784  0.04602229  3.464448
##   2       3       4.772853  0.04627233  3.519607
##   2       4       4.849307  0.04927904  3.554871
##   2       5       4.948384  0.04627231  3.600726
##   2       6       5.086690  0.04601391  3.660133
##   2       7       5.204135  0.04610951  3.717773
##   2       8       5.371936  0.04244528  3.799765
##   3       2       4.483157  0.06192865  3.416468
##   3       3       4.646819  0.05506877  3.489984
##   3       4       4.745054  0.05135138  3.539784
##   3       5       4.930259  0.05061488  3.618705
##   3       6       5.055259  0.04892681  3.674142
##   3       7       5.366321  0.04600681  3.777637
##   3       8       5.457541  0.04373498  3.839231
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 5 and degree = 1.
```

```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

![figures/Y2Training.png](figures/Y2Training.png)


```
## Selected 4 of 122 terms, and 3 of 163 predictors
## Termination condition: Reached nk 201
## Importance: MAPS_POS, zipcode97702, SEPTI_r_clinical_cutoff, ...
## Number of terms at each degree of interaction: 1 3 (additive model)
## GCV 17.89015    RSS 4654.639    GRSq 0.1036596    RSq 0.1426262
```

```
## Call: earth(x=matrix[274,163], y=c(25,29,25,22,2...), keepxy=TRUE,
##             degree=1, nprune=5)
## 
##                         coefficients
## (Intercept)                23.609727
## zipcode97702               -4.151507
## SEPTI_r_clinical_cutoff    -1.000289
## h(MAPS_POS- -0.636609)      1.636962
## 
## Selected 4 of 122 terms, and 3 of 163 predictors
## Termination condition: Reached nk 201
## Importance: MAPS_POS, zipcode97702, SEPTI_r_clinical_cutoff, ...
## Number of terms at each degree of interaction: 1 3 (additive model)
## GCV 17.89015    RSS 4654.639    GRSq 0.1036596    RSq 0.1426262
```

![plot of chunk Y2Training-finalModel](figures/Y2Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 163)
## 
##                                Overall
## MAPS_POS                        100.00
## zipcode97702                     79.97
## SEPTI_r_clinical_cutoff          58.54
## zipcode97267                      0.00
## SEPTI_total                       0.00
## ECBI_intensity_clinical_cutoff    0.00
## income$80,000-$119,999            0.00
## SEPTI_discipline                  0.00
## ECBI_intensity_T_score            0.00
## MAPS_SP                           0.00
## visitTypeFollow-upappointment     0.00
## parentAge                         0.00
## parentEducationCollege            0.00
## zipcode97227                      0.00
## zipcode97201                      0.00
## zipcode75502                      0.00
## zipcode97233                      0.00
## zipcode97213                      0.00
## birthOrderMiddle                  0.00
## ECBI_Inatt_Tot                    0.00
```


```
##      RMSE  Rsquared       MAE 
## 4.1216177 0.1426262 3.0991466
```

```
##            Y2       hat
## Y2  1.0000000 0.3776588
## hat 0.3776588 1.0000000
```

![plot of chunk Y2Training-predict](figures/Y2Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 4.92654917 0.01302418 3.45931558
```

```
##            Y2       hat
## Y2  1.0000000 0.1141235
## hat 0.1141235 1.0000000
```

![plot of chunk Y2Validation-predict](figures/Y2Validation-predict-1.png)



# Model 3

Prediction model for `Y3`.

Train model over the tuning parameters.


| nprune| degree|
|------:|------:|
|      7|      1|
|      8|      1|
|      9|      1|
|     10|      1|
|     11|      1|
|     12|      1|
|      7|      2|
|      8|      2|
|      9|      2|
|     10|      2|
|     11|      2|
|     12|      2|
|      7|      3|
|      8|      3|
|      9|      3|
|     10|      3|
|     11|      3|
|     12|      3|

```
## Multivariate Adaptive Regression Spline 
## 
## 274 samples
##  51 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 50 times) 
## Summary of sample sizes: 247, 246, 247, 245, 247, 246, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE      
##   1        7      11.38132  0.12775693   9.347546
##   1        8      11.31965  0.13893535   9.278663
##   1        9      11.32448  0.14403027   9.266579
##   1       10      11.33809  0.14885610   9.262431
##   1       11      11.38975  0.15037662   9.290773
##   1       12      11.45324  0.14730584   9.322245
##   2        7      12.10988  0.10386956   9.757157
##   2        8      12.27120  0.10593401   9.825971
##   2        9      12.49936  0.10708985   9.952391
##   2       10      12.64214  0.10714884  10.009016
##   2       11      12.77425  0.10749931  10.083628
##   2       12      12.90093  0.10906841  10.143701
##   3        7      12.13052  0.10042431   9.768990
##   3        8      14.33433  0.09868374  10.261862
##   3        9      14.70919  0.09862058  10.406614
##   3       10      14.93276  0.09842126  10.531897
##   3       11      15.24309  0.10014719  10.631220
##   3       12      15.39052  0.10155342  10.690937
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 8 and degree = 1.
```

```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

![figures/Y3Training.png](figures/Y3Training.png)


```
## Selected 8 of 122 terms, and 7 of 163 predictors
## Termination condition: Reached nk 201
## Importance: SEPTI_discipline, SEPTI_total, childAge, zipcode97702, ...
## Number of terms at each degree of interaction: 1 7 (additive model)
## GCV 113.9786    RSS 27904.36    GRSq 0.1858469    RSq 0.2672087
```

```
## Call: earth(x=matrix[274,163], y=c(58,54,64,41,5...), keepxy=TRUE,
##             degree=1, nprune=8)
## 
##                                                 coefficients
## (Intercept)                                        46.694740
## parentSituationCo-parentinginseparatehouseholds     9.399783
## zipcode97702                                       -7.967396
## h(childAge-0.00619587)                             -5.486517
## h(-1.06097-ECBI_problem_raw_score)                 76.403589
## h(-0.421301-ECBI_Cond_Tot)                         -8.168302
## h(SEPTI_discipline- -1.27627)                       3.025683
## h(-1.45385-SEPTI_total)                            16.916900
## 
## Selected 8 of 122 terms, and 7 of 163 predictors
## Termination condition: Reached nk 201
## Importance: SEPTI_discipline, SEPTI_total, childAge, zipcode97702, ...
## Number of terms at each degree of interaction: 1 7 (additive model)
## GCV 113.9786    RSS 27904.36    GRSq 0.1858469    RSq 0.2672087
```

![plot of chunk Y3Training-finalModel](figures/Y3Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 163)
## 
##                                                 Overall
## SEPTI_discipline                                 100.00
## SEPTI_total                                       87.23
## childAge                                          74.90
## zipcode97702                                      56.71
## ECBI_problem_raw_score                            49.54
## ECBI_Cond_Tot                                     42.09
## parentSituationCo-parentinginseparatehouseholds   27.59
## SEPTI_play                                         0.00
## parentSexMale                                      0.00
## zipcode97027                                       0.00
## zipcode97210                                       0.00
## parentRaceNoResp                                   0.00
## zipcode97101                                       0.00
## zipcode97215                                       0.00
## zipcode97214                                       0.00
## zipcode97141                                       0.00
## zipcode97203                                       0.00
## parentEthnicityUnknown                             0.00
## zipcode97321                                       0.00
## zipcode97230                                       0.00
```


```
##       RMSE   Rsquared        MAE 
## 10.0916174  0.2672087  8.1083143
```

```
##            Y3       hat
## Y3  1.0000000 0.5169223
## hat 0.5169223 1.0000000
```

![plot of chunk Y3Training-predict](figures/Y3Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.8666417  0.1086082  9.2850770
```

```
##            Y3       hat
## Y3  1.0000000 0.3295577
## hat 0.3295577 1.0000000
```

![plot of chunk Y3Validation-predict](figures/Y3Validation-predict-1.png)



