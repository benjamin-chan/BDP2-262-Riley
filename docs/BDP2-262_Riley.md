---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-20"
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
## Warning in nominalTrainWorkflow(x = x, y = y, wts = weights, info =
## trainInfo, : There were missing values in resampled performance measures.
```

```
## Multivariate Adaptive Regression Spline 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 245, 243, 244, 244, 243, 243, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE     
##   1        2      16.30945  0.07634961  13.11803
##   1        3      16.59568  0.06704862  13.38136
##   1        4      16.54292  0.07464692  13.38848
##   1        5      16.78939  0.06660365  13.60468
##   1        6      16.89899  0.06369308  13.68553
##   1        7      17.11603  0.05821955  13.80299
##   1        8      17.24362  0.06148724  13.91943
##   1        9      17.31810  0.06045559  13.97409
##   1       10      17.51110  0.05878670  14.12478
##   1       20      18.13766  0.05780581  14.53757
##   1       30      18.49344  0.05819361  14.80470
##   1       40      18.56386  0.05753052  14.85258
##   1       50      18.57018  0.05763744  14.85638
##   2        2      16.28207  0.08468931  13.08887
##   2        3      16.91899  0.06383469  13.56434
##   2        4      17.08737  0.06839574  13.66393
##   2        5      17.40833  0.06391964  13.83911
##   2        6      17.87173  0.06198592  14.07142
##   2        7      17.97610  0.06344047  14.17440
##   2        8      18.24932  0.05903720  14.35039
##   2        9      18.48691  0.06327363  14.52474
##   2       10      18.61681  0.06267147  14.60864
##   2       20      20.99147  0.05697076  15.91571
##   2       30      22.76168  0.05507497  16.60556
##   2       40      22.86645  0.05561191  16.70322
##   2       50      22.86846  0.05565572  16.70172
##   3        2      16.48510  0.07667286  13.27342
##   3        3      17.05729  0.06206249  13.60001
##   3        4      17.48881  0.05828388  13.83294
##   3        5      18.31822  0.06118430  14.08109
##   3        6      20.21846  0.05802357  14.57002
##   3        7      20.25666  0.06276868  14.60031
##   3        8      20.48950  0.06758097  14.74064
##   3        9      21.84420  0.06905266  15.12100
##   3       10      22.30737  0.07101938  15.36364
##   3       20      24.93827  0.05941148  16.82592
##   3       30      26.69931  0.05794725  18.04020
##   3       40      27.54531  0.05752269  18.56136
##   3       50      27.85031  0.05673634  18.64100
##   4        2      16.48039  0.07131379  13.28713
##   4        3      17.05372  0.06393514  13.59774
##   4        4      17.33231  0.06732612  13.77796
##   4        5      19.23873  0.06921955  14.27052
##   4        6      19.89299  0.06303446  14.58626
##   4        7      20.84020  0.06008405  14.85857
##   4        8      21.43925  0.05893108  15.06620
##   4        9      22.23260  0.05943471  15.38851
##   4       10      22.85104  0.05973044  15.63774
##   4       20      25.78301  0.05923711  17.18712
##   4       30      28.22670  0.05930580  18.77925
##   4       40      30.00535  0.06018776  19.79195
##   4       50      30.81942  0.05904464  20.17958
##   5        2      16.47067  0.07173200  13.25256
##   5        3      17.01397  0.06166471  13.59198
##   5        4      17.36716  0.06175142  13.82335
##   5        5      19.48717  0.05883795  14.42456
##   5        6      20.08048  0.05520035  14.64209
##   5        7      20.29856  0.05965801  14.75175
##   5        8      20.76241  0.05927988  14.96765
##   5        9      21.84782  0.06025792  15.39673
##   5       10      22.41148  0.05925687  15.62771
##   5       20      26.28667  0.06433996  17.52781
##   5       30      29.23525  0.06200849  19.10304
##   5       40      30.75223  0.05949838  20.00940
##   5       50      39.89013  0.05698324  22.14370
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 2 and degree = 2.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)


```
## Call: earth(x=matrix[271,161], y=c(73,77,76,38,7...), keepxy=TRUE,
##             degree=2, nprune=2)
## 
##                  coefficients
## (Intercept)          74.22368
## parentRaceWhite1    -10.16215
## 
## Selected 2 of 68 terms, and 1 of 161 predictors
## Termination condition: RSq changed by less than 0.001 at 68 terms
## Importance: parentRaceWhite1, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 265.8502    RSS 70196.46    GRSq 0.05708043    RSq 0.07446106
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-1.png)

```
##                  nsubsets   gcv    rss
## parentRaceWhite1        1 100.0  100.0
```

```
##  plotmo grid:    totalChildren birthOrderOldest birthOrderMiddle
##                   -0.003470588                0                0
##  birthOrderYoungest childSexMale   childAge
##                   0            1 -0.0641945
##  childEthnicityNotHispanic/Latino childEthnicityUnknown
##                                 1                     0
##  childEthnicityPrefernottorespond childRaceWhite1 childRaceAsian1
##                                 0               1               0
##  childRaceOther1 childRaceNoResp1
##                0                0
##  childRelationshipBiologicaloradoptivefather childRelationshipStepparent
##                                            0                           0
##  childRelationshipGrandparent childRelationshipRelative
##                             0                         0
##  childRelationshipOther parentGenderFemale parentGenderTransgender
##                       0                  1                       0
##  parentGenderOther parentGenderPrefernottorespond parentSexMale
##                  0                              0             0
##    parentAge parentEthnicityNotHispanic/Latino parentEthnicityUnknown
##  -0.01037539                                 1                      0
##  parentEthnicityPrefernottorespond parentRaceWhite1 parentRaceAsian1
##                                  0                1                0
##  parentRaceOther1 parentRaceNoResp1 parentMaritalStatusWidowed
##                 0                 0                          0
##  parentMaritalStatusDivorced parentMaritalStatusSeparated
##                            0                            0
##  parentMaritalStatusRemarried parentMaritalStatusNevermarried
##                             0                               0
##  parentSituationCoupleparentingwithspouseorpartnerinthesamehousehold
##                                                                    1
##  parentSituationCo-parentinginseparatehouseholds parentsNumber
##                                                0     0.4384894
##  parentChildRatio zipcodeClass2 zipcode90210 zipcode91020 zipcode91204
##        -0.2786226             0            0            0            0
##  zipcode91205 zipcode91206 zipcode91210 zipcode91402 zipcode97003
##             0            0            0            0            0
##  zipcode97005 zipcode97006 zipcode97007 zipcode97008 zipcode97023
##             0            0            0            0            0
##  zipcode97027 zipcode97032 zipcode97034 zipcode97035 zipcode97045
##             0            0            0            0            0
##  zipcode97051 zipcode97056 zipcode97060 zipcode97062 zipcode97068
##             0            0            0            0            0
##  zipcode97071 zipcode97078 zipcode97086 zipcode97089 zipcode97101
##             0            0            0            0            0
##  zipcode97116 zipcode97123 zipcode97124 zipcode97140 zipcode97141
##             0            0            0            0            0
##  zipcode97201 zipcode97202 zipcode97203 zipcode97206 zipcode97209
##             0            0            0            0            0
##  zipcode97210 zipcode97211 zipcode97212 zipcode97213 zipcode97214
##             0            0            0            0            0
##  zipcode97215 zipcode97217 zipcode97219 zipcode97220 zipcode97221
##             0            0            0            0            0
##  zipcode97222 zipcode97223 zipcode97224 zipcode97225 zipcode97227
##             0            0            0            0            0
##  zipcode97229 zipcode97230 zipcode97232 zipcode97233 zipcode97236
##             0            0            0            0            0
##  zipcode97239 zipcode97266 zipcode97267 zipcode97321 zipcode97325
##             0            0            0            0            0
##  zipcode97429 zipcode97527 zipcode97701 zipcode97702 zipcode97703
##             0            0            0            0            0
##  zipcode97707 zipcode97734 zipcode97738 zipcode97741 zipcode97753
##             0            0            0            0            0
##  zipcode97754 zipcode97756 zipcode97757 zipcode97759 zipcode97760
##             0            0            0            0            0
##  zipcode97825 zipcode98632 zipcode98660 zipcode98683 zipcode98685
##             0            0            0            0            0
##  communitySuburban communityRural   distance
##                  0              0 -0.3035392
##  parentEducationVocationalschool/somecollege parentEducationCollege
##                                            0                      0
##  parentEducationGraduate/professionalschool income$25,001-$49,999
##                                           0                     0
##  income$50,000-$79,999 income$80,000-$119,999 income$120,000-$149,999
##                      0                      0                       0
##  income$150,000ormore ECBI_intensity_T_score
##                     0             0.04911075
##  ECBI_intensity_clinical_cutoff ECBI_problem_T_score
##                      -0.4279721           -0.2886208
##  ECBI_problem_clinical_cutoff   ECBI_Opp ECBI_Inatt  ECBI_Cond
##                    -0.5835555 0.05333038  0.1374456 -0.2370995
##       MAPS_PP    MAPS_PR   MAPS_WM   MAPS_SP    MAPS_HS     MAPS_LC
##  -0.009849928 0.02993201 0.2231501 0.4423819 -0.1437172 -0.04766026
##     MAPS_PC  MAPS_POS   MAPS_NEG SEPTI_nurturance SEPTI_n_clinical_cutoff
##  -0.7264933 0.1459447 -0.2250795        0.1846658              -0.6606743
##  SEPTI_discipline SEPTI_d_clinical_cutoff SEPTI_play
##       -0.04470959              -0.8974074  0.0797063
##  SEPTI_p_clinical_cutoff SEPTI_routine SEPTI_r_clinical_cutoff SEPTI_total
##                -0.814894     0.1496458              -0.7057189 -0.03370314
##  SEPTI_total_clin_cutoff
##               -0.5562876
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-2.png)


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
## Warning in nominalTrainWorkflow(x = x, y = y, wts = weights, info =
## trainInfo, : There were missing values in resampled performance measures.
```

```
## Multivariate Adaptive Regression Spline 
## 
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 242, 245, 244, 243, 244, 244, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE     
##   1        2      4.769325  0.06613931  3.610917
##   1        3      4.922471  0.03844446  3.706263
##   1        4      4.939594  0.03052891  3.692469
##   1        5      4.981488  0.03550842  3.739028
##   1        6      5.025680  0.03399006  3.772536
##   1        7      5.071779  0.03584101  3.803607
##   1        8      5.090674  0.03718882  3.819131
##   1        9      5.088761  0.03499261  3.815950
##   1       10      5.114498  0.03799732  3.844966
##   1       11      5.151898  0.03955700  3.873592
##   1       12      5.162393  0.04208952  3.891939
##   2        2      4.769821  0.04666825  3.607858
##   2        3      4.857098  0.05780132  3.659889
##   2        4      4.957456  0.06293342  3.704690
##   2        5      5.008163  0.06070630  3.746639
##   2        6      5.096832  0.05741652  3.808399
##   2        7      5.199082  0.06145834  3.868549
##   2        8      5.317522  0.05515465  3.930419
##   2        9      5.409578  0.05650789  3.977810
##   2       10      5.461163  0.06126465  4.012128
##   2       11      5.547540  0.06428380  4.058466
##   2       12      5.584412  0.06218295  4.099706
##   3        2      4.734929  0.07804425  3.586465
##   3        3      4.828192  0.08462966  3.622234
##   3        4      4.933699  0.08459886  3.680742
##   3        5      5.125595  0.07156658  3.774898
##   3        6      5.320382  0.07197377  3.853325
##   3        7      5.475390  0.06801197  3.941423
##   3        8      5.546821  0.06993094  3.980766
##   3        9      5.736633  0.06499686  4.062049
##   3       10      5.784803  0.06719904  4.098070
##   3       11      5.860063  0.06965193  4.136968
##   3       12      5.967136  0.06598272  4.213140
##   4        2      4.731605  0.08079646  3.570583
##   4        3      4.805048  0.08268506  3.604754
##   4        4      4.943166  0.08069046  3.677574
##   4        5      5.107684  0.07997665  3.745236
##   4        6      5.273105  0.07942169  3.820900
##   4        7      5.454679  0.07642709  3.905491
##   4        8      5.598704  0.07980582  3.971211
##   4        9      5.835714  0.07054114  4.065519
##   4       10      5.923231  0.07270869  4.129321
##   4       11      6.040383  0.07336396  4.176608
##   4       12      7.617641  0.06884490  4.536421
##   5        2      4.756675  0.07730367  3.584494
##   5        3      4.850959  0.07699275  3.628111
##   5        4      4.952615  0.07850762  3.687418
##   5        5      5.143592  0.07135049  3.771871
##   5        6      5.286429  0.06854776  3.839080
##   5        7      5.474546  0.07192351  3.928575
##   5        8      5.705495  0.07683940  4.008676
##   5        9      5.808935  0.07255259  4.062503
##   5       10      6.005708  0.07226854  4.151417
##   5       11      6.095712  0.06490003  4.202338
##   5       12      6.216328  0.06447521  4.276768
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 2 and degree = 4.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)


```
## Call: earth(x=matrix[271,161], y=c(25,29,25,22,2...), keepxy=TRUE,
##             degree=4, nprune=2)
## 
##                                                                         coefficients
## (Intercept)                                                                24.674429
## h(childAge- -0.659842) * h(MAPS_PP- -0.00984993) * h(-0.667244-MAPS_LC)    -4.464482
## 
## Selected 2 of 97 terms, and 3 of 161 predictors
## Termination condition: GRSq -10 at 97 terms
## Importance: childAge, MAPS_PP, MAPS_LC, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 0 0 1
## GCV 21.00742    RSS 5546.909    GRSq 0.06374886    RSq 0.08100657
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-1.png)

```
##          nsubsets   gcv    rss
## childAge        1 100.0  100.0
## MAPS_PP         1 100.0  100.0
## MAPS_LC         1 100.0  100.0
```

```
##  plotmo grid:    totalChildren birthOrderOldest birthOrderMiddle
##                   -0.003470588                0                0
##  birthOrderYoungest childSexMale   childAge
##                   0            1 -0.0641945
##  childEthnicityNotHispanic/Latino childEthnicityUnknown
##                                 1                     0
##  childEthnicityPrefernottorespond childRaceWhite1 childRaceAsian1
##                                 0               1               0
##  childRaceOther1 childRaceNoResp1
##                0                0
##  childRelationshipBiologicaloradoptivefather childRelationshipStepparent
##                                            0                           0
##  childRelationshipGrandparent childRelationshipRelative
##                             0                         0
##  childRelationshipOther parentGenderFemale parentGenderTransgender
##                       0                  1                       0
##  parentGenderOther parentGenderPrefernottorespond parentSexMale
##                  0                              0             0
##    parentAge parentEthnicityNotHispanic/Latino parentEthnicityUnknown
##  -0.01037539                                 1                      0
##  parentEthnicityPrefernottorespond parentRaceWhite1 parentRaceAsian1
##                                  0                1                0
##  parentRaceOther1 parentRaceNoResp1 parentMaritalStatusWidowed
##                 0                 0                          0
##  parentMaritalStatusDivorced parentMaritalStatusSeparated
##                            0                            0
##  parentMaritalStatusRemarried parentMaritalStatusNevermarried
##                             0                               0
##  parentSituationCoupleparentingwithspouseorpartnerinthesamehousehold
##                                                                    1
##  parentSituationCo-parentinginseparatehouseholds parentsNumber
##                                                0     0.4384894
##  parentChildRatio zipcodeClass2 zipcode90210 zipcode91020 zipcode91204
##        -0.2786226             0            0            0            0
##  zipcode91205 zipcode91206 zipcode91210 zipcode91402 zipcode97003
##             0            0            0            0            0
##  zipcode97005 zipcode97006 zipcode97007 zipcode97008 zipcode97023
##             0            0            0            0            0
##  zipcode97027 zipcode97032 zipcode97034 zipcode97035 zipcode97045
##             0            0            0            0            0
##  zipcode97051 zipcode97056 zipcode97060 zipcode97062 zipcode97068
##             0            0            0            0            0
##  zipcode97071 zipcode97078 zipcode97086 zipcode97089 zipcode97101
##             0            0            0            0            0
##  zipcode97116 zipcode97123 zipcode97124 zipcode97140 zipcode97141
##             0            0            0            0            0
##  zipcode97201 zipcode97202 zipcode97203 zipcode97206 zipcode97209
##             0            0            0            0            0
##  zipcode97210 zipcode97211 zipcode97212 zipcode97213 zipcode97214
##             0            0            0            0            0
##  zipcode97215 zipcode97217 zipcode97219 zipcode97220 zipcode97221
##             0            0            0            0            0
##  zipcode97222 zipcode97223 zipcode97224 zipcode97225 zipcode97227
##             0            0            0            0            0
##  zipcode97229 zipcode97230 zipcode97232 zipcode97233 zipcode97236
##             0            0            0            0            0
##  zipcode97239 zipcode97266 zipcode97267 zipcode97321 zipcode97325
##             0            0            0            0            0
##  zipcode97429 zipcode97527 zipcode97701 zipcode97702 zipcode97703
##             0            0            0            0            0
##  zipcode97707 zipcode97734 zipcode97738 zipcode97741 zipcode97753
##             0            0            0            0            0
##  zipcode97754 zipcode97756 zipcode97757 zipcode97759 zipcode97760
##             0            0            0            0            0
##  zipcode97825 zipcode98632 zipcode98660 zipcode98683 zipcode98685
##             0            0            0            0            0
##  communitySuburban communityRural   distance
##                  0              0 -0.3035392
##  parentEducationVocationalschool/somecollege parentEducationCollege
##                                            0                      0
##  parentEducationGraduate/professionalschool income$25,001-$49,999
##                                           0                     0
##  income$50,000-$79,999 income$80,000-$119,999 income$120,000-$149,999
##                      0                      0                       0
##  income$150,000ormore ECBI_intensity_T_score
##                     0             0.04911075
##  ECBI_intensity_clinical_cutoff ECBI_problem_T_score
##                      -0.4279721           -0.2886208
##  ECBI_problem_clinical_cutoff   ECBI_Opp ECBI_Inatt  ECBI_Cond
##                    -0.5835555 0.05333038  0.1374456 -0.2370995
##       MAPS_PP    MAPS_PR   MAPS_WM   MAPS_SP    MAPS_HS     MAPS_LC
##  -0.009849928 0.02993201 0.2231501 0.4423819 -0.1437172 -0.04766026
##     MAPS_PC  MAPS_POS   MAPS_NEG SEPTI_nurturance SEPTI_n_clinical_cutoff
##  -0.7264933 0.1459447 -0.2250795        0.1846658              -0.6606743
##  SEPTI_discipline SEPTI_d_clinical_cutoff SEPTI_play
##       -0.04470959              -0.8974074  0.0797063
##  SEPTI_p_clinical_cutoff SEPTI_routine SEPTI_r_clinical_cutoff SEPTI_total
##                -0.814894     0.1496458              -0.7057189 -0.03370314
##  SEPTI_total_clin_cutoff
##               -0.5562876
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-2.png)


```
##       RMSE   Rsquared        MAE 
## 4.51498144 0.08084681 3.42395955
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2843357
## hat      0.2843357 1.0000000
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##         RMSE     Rsquared          MAE 
## 4.049151e+00 7.534834e-05 3.097394e+00
```

```
##             PCB2_Tot         hat
## PCB2_Tot 1.000000000 0.008680342
## hat      0.008680342 1.000000000
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
## 273 samples
##  54 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 244, 244, 244, 244, 244, 244, ... 
## Resampling results across tuning parameters:
## 
##   degree  nprune  RMSE      Rsquared    MAE      
##   1        7      12.00126  0.07011204   9.670214
##   1        8      12.07515  0.07503988   9.702391
##   1        9      12.16860  0.07719527   9.756740
##   1       10      12.27907  0.07063920   9.827741
##   1       11      12.38075  0.06996774   9.893367
##   1       12      12.44136  0.06975099   9.954306
##   1       13      12.60167  0.06816870  10.051811
##   1       14      12.71609  0.06556260  10.143587
##   1       15      12.78262  0.06361319  10.205863
##   1       20      13.14380  0.06043544  10.468992
##   1       30      13.51755  0.05985220  10.727433
##   1       40      13.63500  0.05930007  10.808311
##   1       50      13.71340  0.05912628  10.866224
##   2        7      12.51544  0.07826745   9.889329
##   2        8      12.71646  0.07538202  10.010602
##   2        9      12.84219  0.07615696  10.082433
##   2       10      13.11300  0.07432381  10.240262
##   2       11      13.21222  0.07423478  10.294757
##   2       12      13.42843  0.07254833  10.379903
##   2       13      13.52638  0.07083502  10.448446
##   2       14      13.60683  0.06941864  10.518040
##   2       15      13.69393  0.06992001  10.562025
##   2       20      14.17864  0.07217179  10.853499
##   2       30      14.52754  0.07126839  11.054188
##   2       40      14.62732  0.07049295  11.093565
##   2       50      14.62732  0.07049295  11.093565
##   3        7      12.58731  0.08076082   9.914775
##   3        8      12.63106  0.08498430   9.944877
##   3        9      12.75626  0.08568387  10.009558
##   3       10      12.97480  0.08405913  10.129887
##   3       11      13.09417  0.08536887  10.176216
##   3       12      13.25165  0.08440561  10.263615
##   3       13      13.53794  0.08578631  10.384976
##   3       14      13.58670  0.08525385  10.420521
##   3       15      15.19039  0.08337233  10.837397
##   3       20      26.24252  0.07885648  13.396659
##   3       30      28.02931  0.07942070  14.349633
##   3       40      40.57772  0.07630748  17.084570
##   3       50      40.67515  0.07525768  17.146564
##   4        7      12.93066  0.07380147  10.041061
##   4        8      13.00671  0.07365723  10.080201
##   4        9      13.19798  0.07447886  10.165517
##   4       10      13.86338  0.07405635  10.384963
##   4       11      13.98857  0.07566140  10.451509
##   4       12      14.08175  0.07504597  10.540966
##   4       13      14.28069  0.07350242  10.651087
##   4       14      14.35706  0.07176911  10.712318
##   4       15      14.84594  0.07094395  10.909317
##   4       20      19.38427  0.06798776  12.121892
##   4       30      32.09090  0.06852903  15.279219
##   4       40      34.13222  0.06183259  16.223698
##   4       50      34.78837  0.05903250  16.547834
##   5        7      12.82983  0.06935641  10.000329
##   5        8      13.06068  0.06863361  10.115023
##   5        9      13.18511  0.07227458  10.153428
##   5       10      13.32107  0.07091645  10.216402
##   5       11      13.57188  0.07209270  10.320536
##   5       12      14.06387  0.07219917  10.493462
##   5       13      17.27360  0.07017637  11.167814
##   5       14      17.41115  0.06803185  11.269042
##   5       15      18.11490  0.06861365  11.511189
##   5       20      20.31949  0.06582894  12.282750
##   5       30      33.69421  0.06183240  15.633640
##   5       40      34.73985  0.06055452  16.284785
##   5       50      35.24522  0.05909654  16.571283
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 7 and degree = 1.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)


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
##                        nsubsets   gcv    rss
## ECBI_intensity_T_score        4 100.0  100.0
## MAPS_LC                       3  79.1   81.6
## SEPTI_nurturance              2  48.3   57.4
## parentAge-unused              1  55.2   54.6
```

```
##  plotmo grid:    totalChildren birthOrderOldest birthOrderMiddle
##                   -0.003470588                0                0
##  birthOrderYoungest childSexMale   childAge
##                   0            1 -0.0641945
##  childEthnicityNotHispanic/Latino childEthnicityUnknown
##                                 1                     0
##  childEthnicityPrefernottorespond childRaceWhite1 childRaceAsian1
##                                 0               1               0
##  childRaceOther1 childRaceNoResp1
##                0                0
##  childRelationshipBiologicaloradoptivefather childRelationshipStepparent
##                                            0                           0
##  childRelationshipGrandparent childRelationshipRelative
##                             0                         0
##  childRelationshipOther parentGenderFemale parentGenderTransgender
##                       0                  1                       0
##  parentGenderOther parentGenderPrefernottorespond parentSexMale
##                  0                              0             0
##    parentAge parentEthnicityNotHispanic/Latino parentEthnicityUnknown
##  -0.01037539                                 1                      0
##  parentEthnicityPrefernottorespond parentRaceWhite1 parentRaceAsian1
##                                  0                1                0
##  parentRaceOther1 parentRaceNoResp1 parentMaritalStatusWidowed
##                 0                 0                          0
##  parentMaritalStatusDivorced parentMaritalStatusSeparated
##                            0                            0
##  parentMaritalStatusRemarried parentMaritalStatusNevermarried
##                             0                               0
##  parentSituationCoupleparentingwithspouseorpartnerinthesamehousehold
##                                                                    1
##  parentSituationCo-parentinginseparatehouseholds parentsNumber
##                                                0     0.4384894
##  parentChildRatio zipcodeClass2 zipcode90210 zipcode91020 zipcode91204
##        -0.2786226             0            0            0            0
##  zipcode91205 zipcode91206 zipcode91210 zipcode91402 zipcode97003
##             0            0            0            0            0
##  zipcode97005 zipcode97006 zipcode97007 zipcode97008 zipcode97023
##             0            0            0            0            0
##  zipcode97027 zipcode97032 zipcode97034 zipcode97035 zipcode97045
##             0            0            0            0            0
##  zipcode97051 zipcode97056 zipcode97060 zipcode97062 zipcode97068
##             0            0            0            0            0
##  zipcode97071 zipcode97078 zipcode97086 zipcode97089 zipcode97101
##             0            0            0            0            0
##  zipcode97116 zipcode97123 zipcode97124 zipcode97140 zipcode97141
##             0            0            0            0            0
##  zipcode97201 zipcode97202 zipcode97203 zipcode97206 zipcode97209
##             0            0            0            0            0
##  zipcode97210 zipcode97211 zipcode97212 zipcode97213 zipcode97214
##             0            0            0            0            0
##  zipcode97215 zipcode97217 zipcode97219 zipcode97220 zipcode97221
##             0            0            0            0            0
##  zipcode97222 zipcode97223 zipcode97224 zipcode97225 zipcode97227
##             0            0            0            0            0
##  zipcode97229 zipcode97230 zipcode97232 zipcode97233 zipcode97236
##             0            0            0            0            0
##  zipcode97239 zipcode97266 zipcode97267 zipcode97321 zipcode97325
##             0            0            0            0            0
##  zipcode97429 zipcode97527 zipcode97701 zipcode97702 zipcode97703
##             0            0            0            0            0
##  zipcode97707 zipcode97734 zipcode97738 zipcode97741 zipcode97753
##             0            0            0            0            0
##  zipcode97754 zipcode97756 zipcode97757 zipcode97759 zipcode97760
##             0            0            0            0            0
##  zipcode97825 zipcode98632 zipcode98660 zipcode98683 zipcode98685
##             0            0            0            0            0
##  communitySuburban communityRural   distance
##                  0              0 -0.3035392
##  parentEducationVocationalschool/somecollege parentEducationCollege
##                                            0                      0
##  parentEducationGraduate/professionalschool income$25,001-$49,999
##                                           0                     0
##  income$50,000-$79,999 income$80,000-$119,999 income$120,000-$149,999
##                      0                      0                       0
##  income$150,000ormore ECBI_intensity_T_score
##                     0             0.04911075
##  ECBI_intensity_clinical_cutoff ECBI_problem_T_score
##                      -0.4279721           -0.2886208
##  ECBI_problem_clinical_cutoff   ECBI_Opp ECBI_Inatt  ECBI_Cond
##                    -0.5835555 0.05333038  0.1374456 -0.2370995
##       MAPS_PP    MAPS_PR   MAPS_WM   MAPS_SP    MAPS_HS     MAPS_LC
##  -0.009849928 0.02993201 0.2231501 0.4423819 -0.1437172 -0.04766026
##     MAPS_PC  MAPS_POS   MAPS_NEG SEPTI_nurturance SEPTI_n_clinical_cutoff
##  -0.7264933 0.1459447 -0.2250795        0.1846658              -0.6606743
##  SEPTI_discipline SEPTI_d_clinical_cutoff SEPTI_play
##       -0.04470959              -0.8974074  0.0797063
##  SEPTI_p_clinical_cutoff SEPTI_routine SEPTI_r_clinical_cutoff SEPTI_total
##                -0.814894     0.1496458              -0.7057189 -0.03370314
##  SEPTI_total_clin_cutoff
##               -0.5562876
```

![plot of chunk PCB3_Total_Training-finalModel](figures/PCB3_Total_Training-finalModel-2.png)


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



