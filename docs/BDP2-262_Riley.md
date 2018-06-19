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
grid <- expand.grid(nprune = c(seq(2, 9, 1), seq(10, 50, 10)),
                    degree = seq(5))
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
|      9|      2|
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
|      9|      3|
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
|      9|      4|
|     10|      4|
|     20|      4|
|     30|      4|
|     40|      4|
|     50|      4|
|      2|      5|
|      3|      5|
|      4|      5|
|      5|      5|
|      6|      5|
|      7|      5|
|      8|      5|
|      9|      5|
|     10|      5|
|     20|      5|
|     30|      5|
|     40|      5|
|     50|      5|



# Model PCB1


## PCB1 Total

Prediction model for `PCB1`.

Train model over the tuning parameters.


```
## Multivariate Adaptive Regression Spline 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 290, 290, 290, 290, 290, 290, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared      MAE     
##    2      1       15.99799  8.624413e-04  13.00794
##    2      2       16.94806  4.417104e-03  13.32211
##    2      3       17.04075  8.967514e-03  13.47931
##    2      4       18.01057  2.745886e-03  13.87793
##    2      5       16.82776  9.797959e-03  13.54521
##    3      1       16.00033  6.028004e-03  13.06611
##    3      2       15.37573  6.266278e-02  12.33500
##    3      3       17.08955  9.138638e-04  13.58053
##    3      4       17.02980  4.517321e-03  13.42309
##    3      5       17.81272  5.700830e-03  13.62939
##    4      1       15.78126  2.505014e-02  12.77574
##    4      2       15.32520  6.846124e-02  12.29220
##    4      3       17.49705  3.845489e-03  13.73991
##    4      4       18.62264  1.185477e-02  13.89637
##    4      5       18.92075  3.279074e-03  14.00757
##    5      1       16.25399  7.760380e-03  12.91845
##    5      2       16.12274  2.888682e-02  12.64923
##    5      3       18.13580  2.161441e-04  14.16894
##    5      4       19.82068  2.756631e-03  14.42384
##    5      5       20.00861  5.964235e-04  14.43709
##    6      1       16.59016  3.240987e-03  13.16955
##    6      2       15.57209  5.659922e-02  12.37108
##    6      3       18.54143  2.129331e-04  14.33268
##    6      4       19.90115  6.382900e-03  14.55836
##    6      5       18.70277  1.044334e-02  14.20865
##    7      1       16.62400  6.333705e-03  13.00835
##    7      2       16.39524  2.908864e-02  12.64972
##    7      3       18.51679  8.521210e-05  14.46584
##    7      4       20.87844  3.788013e-03  15.00204
##    7      5       19.61548  6.456004e-03  14.44733
##    8      1       16.74449  4.168665e-03  13.18143
##    8      2       16.70754  2.254753e-02  12.95847
##    8      3       18.73619  1.397572e-04  14.59933
##    8      4       21.75298  3.794464e-03  15.30456
##    8      5       20.86409  2.081976e-03  14.95466
##    9      1       17.06755  2.043189e-04  13.48347
##    9      2       17.40115  8.548764e-03  13.41023
##    9      3       19.41789  1.346769e-04  14.99258
##    9      4       21.84937  3.532210e-03  15.40193
##    9      5       21.18170  3.323902e-03  15.08462
##   10      1       17.30815  5.909089e-05  13.71877
##   10      2       17.33829  1.221904e-02  13.46850
##   10      3       19.50481  2.371949e-04  15.03168
##   10      4       21.99258  4.089378e-03  15.49541
##   10      5       21.55128  2.448514e-03  15.23143
##   20      1       18.09806  8.730018e-04  14.12948
##   20      2       18.27738  1.784678e-02  13.88293
##   20      3       23.06627  8.451192e-04  16.69054
##   20      4       24.91908  4.032507e-03  17.42807
##   20      5       23.39324  3.171643e-03  16.92375
##   30      1       18.49078  2.846140e-03  14.47660
##   30      2       18.21426  2.145115e-02  13.82205
##   30      3       24.82077  6.006432e-04  17.75361
##   30      4       28.61609  7.382017e-04  19.38110
##   30      5       25.70542  3.416544e-05  18.28547
##   40      1       18.53655  6.057773e-03  14.55362
##   40      2       18.22531  2.157408e-02  13.82434
##   40      3       24.96360  2.780889e-04  17.82838
##   40      4       33.77927  5.842090e-04  21.17199
##   40      5       31.89150  1.342958e-04  20.75186
##   50      1       18.54012  6.799144e-03  14.53371
##   50      2       18.22531  2.157408e-02  13.82434
##   50      3       24.99084  4.078517e-04  17.95107
##   50      4       33.84663  3.723473e-04  21.73750
##   50      5       33.14195  7.653205e-04  21.78235
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 4 and degree = 2.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)


```
## Selected 3 of 44 terms, and 4 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 44 terms
## Importance: childRaceWhite1, parentEthnicityNotHispanic/Latino, ...
## Number of terms at each degree of interaction: 1 0 2
## GCV 232.5616    RSS 64913.47    GRSq 0.07896037    RSq 0.1104466
```

```
## Call: earth(x=matrix[291,159], y=c(73,77,76,65,3...), keepxy=TRUE,
##             degree=2, nprune=4)
## 
##                                                         coefficients
## (Intercept)                                                72.714041
## childRaceWhite1 * parentEthnicityNotHispanic/Latino        -8.704925
## childEthnicityNotHispanic/Latino * h(-0.681607-MAPS_HS)    17.330516
## 
## Selected 3 of 44 terms, and 4 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 44 terms
## Importance: childRaceWhite1, parentEthnicityNotHispanic/Latino, ...
## Number of terms at each degree of interaction: 1 0 2
## GCV 232.5616    RSS 64913.47    GRSq 0.07896037    RSq 0.1104466
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 159)
## 
##                                   Overall
## childRaceWhite1                    100.00
## parentEthnicityNotHispanic/Latino  100.00
## MAPS_HS                             77.31
## childEthnicityNotHispanic/Latino    77.31
## zipcode97035                         0.00
## zipcode97267                         0.00
## parentGenderPrefernottorespond       0.00
## ECBI_intensity_clinical_cutoff       0.00
## zipcode97325                         0.00
## ECBI_problem_T_score                 0.00
## childRaceNoResp1                     0.00
## zipcode97034                         0.00
## MAPS_SP                              0.00
## zipcode97045                         0.00
## zipcode91206                         0.00
## zipcode97023                         0.00
## zipcode97140                         0.00
## income$120,000-$149,999              0.00
## zipcode97051                         0.00
## zipcode97221                         0.00
```


```
##       RMSE   Rsquared        MAE 
## 14.9231199  0.1093606 11.9215600
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.1889719
## hat      0.1889719 1.0000000
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
##       RMSE   Rsquared        MAE 
## 17.7707691  0.1003297 13.6095304
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.3167486
## hat         0.3167486 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Multivariate Adaptive Regression Spline 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 290, 290, 290, 290, 290, 290, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared      MAE     
##    2      1       4.381690  8.059225e-01  3.304141
##    2      2       4.385167  1.766151e-03  3.307422
##    2      3       4.363747  1.093869e-03  3.283099
##    2      4       4.382011  2.863382e-05  3.303260
##    2      5       4.405349  7.582452e-05  3.326965
##    3      1       4.551612  3.928288e-02  3.386132
##    3      2       4.412085  5.705166e-04  3.304704
##    3      3       4.518241  2.558562e-03  3.414259
##    3      4       4.499053  5.708299e-04  3.411578
##    3      5       4.508728  9.735215e-04  3.416962
##    4      1       4.518402  1.621353e-05  3.368497
##    4      2       4.466453  8.837670e-05  3.388707
##    4      3       4.600258  1.115557e-02  3.481428
##    4      4       4.582644  4.665179e-04  3.465791
##    4      5       4.596814  3.358522e-03  3.502249
##    5      1       4.355606  2.965141e-02  3.263084
##    5      2       4.479709  1.326294e-03  3.378019
##    5      3       4.656149  6.811764e-03  3.518942
##    5      4       4.585433  5.300388e-04  3.479174
##    5      5       4.608331  1.066683e-05  3.494853
##    6      1       4.394914  2.507881e-02  3.285962
##    6      2       4.588169  4.816088e-04  3.458870
##    6      3       4.832355  4.145806e-03  3.584345
##    6      4       4.721266  3.389270e-04  3.517178
##    6      5       4.981022  1.125493e-07  3.636871
##    7      1       4.465356  1.695313e-02  3.349072
##    7      2       4.632050  4.900470e-04  3.478395
##    7      3       4.791186  3.281859e-06  3.598258
##    7      4       4.819119  6.364456e-04  3.609878
##    7      5       5.051136  2.820953e-04  3.692528
##    8      1       4.541387  1.174322e-02  3.421167
##    8      2       4.671031  1.011057e-03  3.556960
##    8      3       4.815520  5.593581e-04  3.645194
##    8      4       4.844285  1.426684e-03  3.632480
##    8      5       5.075278  7.166343e-04  3.716914
##    9      1       4.468040  2.814415e-02  3.351514
##    9      2       4.739306  2.422008e-09  3.574036
##    9      3       4.813320  2.338736e-03  3.631147
##    9      4       4.901241  1.157648e-03  3.657230
##    9      5       5.075686  1.135358e-03  3.719954
##   10      1       4.464884  3.760096e-02  3.323436
##   10      2       4.658299  9.759270e-04  3.597252
##   10      3       4.814904  4.310751e-03  3.614624
##   10      4       4.935262  1.366923e-03  3.685902
##   10      5       5.066523  2.110550e-03  3.697361
##   20      1       4.571123  3.605222e-02  3.376862
##   20      2       5.283591  2.100280e-03  3.898692
##   20      3       5.012497  3.246629e-02  3.851928
##   20      4       5.686406  5.153378e-03  4.093208
##   20      5       5.828154  3.163268e-03  4.158699
##   30      1       4.515620  4.515008e-02  3.331536
##   30      2       5.730026  1.396595e-03  3.980172
##   30      3       6.453195  3.352148e-02  4.457608
##   30      4       6.772781  8.290413e-03  4.470310
##   30      5       7.089224  4.622982e-03  4.709279
##   40      1       4.520446  5.184274e-02  3.356328
##   40      2       5.731307  1.380251e-03  3.984048
##   40      3       7.049299  2.539393e-02  4.751061
##   40      4       7.421649  3.274745e-03  4.872772
##   40      5       7.465754  2.813551e-03  4.904628
##   50      1       4.533024  4.962461e-02  3.372235
##   50      2       5.731307  1.380251e-03  3.984048
##   50      3       7.681619  2.260870e-02  4.895984
##   50      4       8.054000  2.814064e-03  5.171437
##   50      5       8.048160  3.625610e-03  5.120126
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 5 and degree = 1.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)


```
## Selected 5 of 21 terms, and 4 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 21 terms
## Importance: zipcode97210, SEPTI_discipline, SEPTI_total, zipcode97702, ...
## Number of terms at each degree of interaction: 1 4 (additive model)
## GCV 17.2069    RSS 4702.274    GRSq 0.1028649    RSq 0.1516793
```

```
## Call: earth(x=matrix[291,159], y=c(25,29,25,24,2...), keepxy=TRUE,
##             degree=1, nprune=5)
## 
##                             coefficients
## (Intercept)                    25.051661
## zipcode97210                  -18.828904
## zipcode97702                   -3.449768
## h(SEPTI_discipline-1.13043)    -8.444283
## h(SEPTI_total-1.05466)          7.693120
## 
## Selected 5 of 21 terms, and 4 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 21 terms
## Importance: zipcode97210, SEPTI_discipline, SEPTI_total, zipcode97702, ...
## Number of terms at each degree of interaction: 1 4 (additive model)
## GCV 17.2069    RSS 4702.274    GRSq 0.1028649    RSq 0.1516793
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 159)
## 
##                              Overall
## zipcode97210                  100.00
## SEPTI_total                    72.40
## SEPTI_discipline               72.40
## zipcode97702                   64.26
## zipcode97219                    0.00
## zipcode97227                    0.00
## MAPS_PR                         0.00
## zipcode97005                    0.00
## ECBI_problem_clinical_cutoff    0.00
## income$80,000-$119,999          0.00
## zipcode97232                    0.00
## parentSexMale                   0.00
## zipcode97203                    0.00
## childRelationshipOther          0.00
## MAPS_SP                         0.00
## zipcode91210                    0.00
## zipcode97068                    0.00
## zipcode97267                    0.00
## zipcode97202                    0.00
## zipcode97056                    0.00
```


```
##      RMSE  Rsquared       MAE 
## 4.0169105 0.1511992 3.0482525
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.3888434
## hat      0.3888434 1.0000000
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
## 4.93309269 0.04381085 3.53335085
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2093104
## hat      0.2093104 1.0000000
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
|     13|      1|
|     14|      1|
|     15|      1|
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
|     13|      2|
|     14|      2|
|     15|      2|
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
|     13|      3|
|     14|      3|
|     15|      3|
|     20|      3|
|     30|      3|
|     40|      3|
|     50|      3|
|      7|      4|
|      8|      4|
|      9|      4|
|     10|      4|
|     11|      4|
|     12|      4|
|     13|      4|
|     14|      4|
|     15|      4|
|     20|      4|
|     30|      4|
|     40|      4|
|     50|      4|
|      7|      5|
|      8|      5|
|      9|      5|
|     10|      5|
|     11|      5|
|     12|      5|
|     13|      5|
|     14|      5|
|     15|      5|
|     20|      5|
|     30|      5|
|     40|      5|
|     50|      5|

```
## Multivariate Adaptive Regression Spline 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 290, 290, 290, 290, 290, 290, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared      MAE      
##    7      1       12.32712  2.009430e-02  10.058696
##    7      2       12.21896  4.317615e-02   9.636461
##    7      3       12.37837  3.006925e-02   9.765708
##    7      4       12.70828  2.935100e-02  10.146235
##    7      5       12.71914  1.392728e-02  10.145365
##    8      1       12.37030  1.794987e-02  10.034046
##    8      2       12.23123  4.861387e-02   9.636687
##    8      3       12.56989  2.568438e-02  10.029973
##    8      4       12.63572  3.537606e-02  10.110007
##    8      5       12.79594  1.475676e-02  10.202122
##    9      1       12.43822  2.010606e-02  10.127254
##    9      2       12.31161  4.336819e-02   9.613292
##    9      3       12.69573  2.842659e-02  10.137293
##    9      4       12.80944  3.004642e-02  10.211733
##    9      5       13.12757  9.809694e-03  10.349492
##   10      1       12.49666  1.977265e-02  10.147210
##   10      2       12.50476  4.042990e-02   9.703454
##   10      3       12.92316  2.586853e-02  10.221345
##   10      4       13.28192  1.321945e-02  10.372328
##   10      5       13.39544  9.230946e-03  10.531050
##   11      1       12.53139  2.090911e-02  10.177918
##   11      2       12.53346  4.167987e-02   9.701729
##   11      3       12.94881  2.748159e-02  10.269900
##   11      4       13.47318  1.010178e-02  10.526513
##   11      5       13.51260  9.439470e-03  10.602335
##   12      1       12.53451  2.339139e-02  10.235960
##   12      2       13.23693  3.202573e-02  10.049339
##   12      3       12.89794  2.987301e-02  10.205210
##   12      4       14.01158  1.060978e-02  10.824663
##   12      5       13.77300  5.866674e-03  10.771539
##   13      1       12.44749  3.122845e-02  10.089581
##   13      2       13.44061  3.359467e-02  10.179769
##   13      3       13.40586  1.681598e-02  10.433033
##   13      4       14.34384  7.027744e-03  11.025874
##   13      5       13.80584  7.351555e-03  10.819936
##   14      1       12.25705  4.396624e-02   9.867603
##   14      2       13.65732  2.759229e-02  10.399833
##   14      3       13.40003  1.441896e-02  10.575499
##   14      4       14.48881  6.028837e-03  11.142070
##   14      5       13.92394  6.800597e-03  10.955955
##   15      1       12.37534  4.558418e-02   9.924832
##   15      2       13.96899  2.010715e-02  10.760884
##   15      3       13.26719  2.346080e-02  10.449836
##   15      4       14.50945  6.812591e-03  11.131647
##   15      5       13.86700  7.140333e-03  10.978423
##   20      1       12.52026  4.918368e-02   9.983306
##   20      2       14.06042  2.726452e-02  10.847855
##   20      3       13.82238  2.244627e-02  10.905099
##   20      4       15.43765  5.824365e-03  11.861205
##   20      5       19.40864  4.437626e-03  12.132031
##   30      1       13.06894  3.717178e-02  10.403372
##   30      2       14.30008  2.300390e-02  11.036977
##   30      3       15.34716  1.007147e-02  11.629751
##   30      4       19.58483  6.077510e-05  12.135875
##   30      5       22.23236  2.221242e-03  13.715273
##   40      1       13.08981  3.666990e-02  10.417264
##   40      2       14.36851  2.058011e-02  11.091417
##   40      3       15.56124  1.137947e-02  11.653653
##   40      4       19.93117  1.486863e-04  12.653679
##   40      5       22.94263  2.497851e-03  14.178522
##   50      1       13.11637  3.541812e-02  10.444405
##   50      2       14.36538  2.066534e-02  11.089985
##   50      3       15.55101  1.190112e-02  11.664168
##   50      4       20.31558  5.675126e-05  12.885520
##   50      5       23.12094  2.530371e-03  14.355351
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 7 and degree = 2.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)


```
## Selected 7 of 37 terms, and 7 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 37 terms
## Importance: MAPS_LC, MAPS_PC, SEPTI_nurturance, childAge, ECBI_Opp, ...
## Number of terms at each degree of interaction: 1 2 4
## GCV 117.6639    RSS 30578.46    GRSq 0.1664208    RSq 0.250423
```

```
## Call: earth(x=matrix[291,159], y=c(58,54,64,53,4...), keepxy=TRUE,
##             degree=2, nprune=7)
## 
##                                                       coefficients
## (Intercept)                                              47.691807
## h(-1.20749-parentAge)                                    14.329552
## h(-1.22955-SEPTI_nurturance)                              7.569124
## h(parentAge- -1.20749) * parentMaritalStatusSeparated    17.596539
## h(childAge- -0.525913) * h(0.167133-MAPS_LC)             -3.567605
## h(ECBI_Opp- -1.02458) * h(SEPTI_nurturance-0.170631)      5.158189
## h(0.167133-MAPS_LC) * h(MAPS_PC- -0.375671)              -4.414231
## 
## Selected 7 of 37 terms, and 7 of 159 predictors
## Termination condition: RSq changed by less than 0.001 at 37 terms
## Importance: MAPS_LC, MAPS_PC, SEPTI_nurturance, childAge, ECBI_Opp, ...
## Number of terms at each degree of interaction: 1 2 4
## GCV 117.6639    RSS 30578.46    GRSq 0.1664208    RSq 0.250423
```

![plot of chunk PCB3_Total_Training-finalModel](figures/PCB3_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 159)
## 
##                                   Overall
## MAPS_LC                            100.00
## MAPS_PC                             85.56
## SEPTI_nurturance                    85.23
## childAge                            74.07
## ECBI_Opp                            67.71
## parentMaritalStatusSeparated        40.00
## parentAge                           40.00
## SEPTI_play                           0.00
## zipcode97239                         0.00
## parentGenderFemale                   0.00
## zipcode97123                         0.00
## MAPS_NEG                             0.00
## zipcode97738                         0.00
## parentRaceAsian1                     0.00
## parentMaritalStatusNevermarried      0.00
## zipcode97213                         0.00
## zipcode97032                         0.00
## parentEthnicityPrefernottorespond    0.00
## SEPTI_p_clinical_cutoff              0.00
## SEPTI_r_clinical_cutoff              0.00
```


```
##       RMSE   Rsquared        MAE 
## 10.2524982  0.2506547  8.3203397
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2350039
## hat      0.2350039 1.0000000
```

```
## Warning: Removed 1 rows containing non-finite values (stat_smooth).

## Warning: Removed 1 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.7977230  0.1799826  9.2805942
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.4242435
## hat         0.4242435 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



