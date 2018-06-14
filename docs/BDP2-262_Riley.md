---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-14"
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
ctrl <- trainControl(method = "LOOCV",
                     savePredictions = TRUE,
                     allowParallel = TRUE,
                     search = "random")
cores <- 24
```

Set the model and tuning parameter grid.


```r
library(leaps)
method <- "leapSeq"
modelLookup(method) %>% kable()
```



|model   |parameter |label                        |forReg |forClass |probModel |
|:-------|:---------|:----------------------------|:------|:--------|:---------|
|leapSeq |nvmax     |Maximum Number of Predictors |TRUE   |FALSE    |FALSE     |

```r
grid <- expand.grid(nvmax = seq(2, 30, 4))
grid %>% kable()
```



| nvmax|
|-----:|
|     2|
|     6|
|    10|
|    14|
|    18|
|    22|
|    26|
|    30|

```r
citation("leaps")
```

```
## 
## To cite package 'leaps' in publications use:
## 
##   Thomas Lumley based on Fortran code by Alan Miller (2017).
##   leaps: Regression Subset Selection. R package version 3.0.
##   https://CRAN.R-project.org/package=leaps
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {leaps: Regression Subset Selection},
##     author = {Thomas Lumley based on Fortran code by Alan Miller},
##     year = {2017},
##     note = {R package version 3.0},
##     url = {https://CRAN.R-project.org/package=leaps},
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
## Warning in leaps.setup(x, y, wt = weights, nbest = nbest, nvmax = nvmax, :
## 16 linear dependencies found
```

```
## Reordering variables and trying again:
```

```
## Linear Regression with Stepwise Selection 
## 
## 274 samples
##  51 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 273, 273, 273, 273, 273, 273, ... 
## Resampling results across tuning parameters:
## 
##   nvmax  RMSE      Rsquared    MAE     
##    2     17.39600  0.03660455  13.67463
##    6     17.56293  0.02928617  13.76716
##   10     17.69886  0.02368016  14.17450
##   14     17.38574  0.04859149  14.01767
##   18     17.86966  0.02433419  14.29962
##   22     17.38218  0.05674534  13.78994
##   26     17.35455  0.06434033  13.98548
##   30     17.61683  0.06483867  14.17030
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was nvmax = 26.
```

![plot of chunk Y1Training](figures/Y1Training-1.png)

![figures/Y1Training.png](figures/Y1Training.png)


```
## Subset selection object
## 163 Variables  (and intercept)
##                                                                              Forced in
## totalChildren                                                                    FALSE
## birthOrderOldest                                                                 FALSE
## birthOrderMiddle                                                                 FALSE
## birthOrderYoungest                                                               FALSE
## childAge                                                                         FALSE
## childAgeDichotomous3 or older                                                    FALSE
## childSexMale                                                                     FALSE
## childEthnicityNot Hispanic/Latino                                                FALSE
## childEthnicityUnknown                                                            FALSE
## childEthnicityPrefer not to respond                                              FALSE
## childRaceWhite                                                                   FALSE
## childRaceAsian                                                                   FALSE
## childRaceNoResp                                                                  FALSE
## visitTypeChild is sick or medical concern                                        FALSE
## visitTypeBehavioral or developmental concern                                     FALSE
## visitTypeFollow-up appointment                                                   FALSE
## visitTypeOther                                                                   FALSE
## childRelationshipBiological or adoptive father                                   FALSE
## childRelationshipStep parent                                                     FALSE
## childRelationshipOther                                                           FALSE
## parentGenderFemale                                                               FALSE
## parentGenderTransgender                                                          FALSE
## parentGenderOther                                                                FALSE
## parentGenderPrefer not to respond                                                FALSE
## parentSexMale                                                                    FALSE
## parentAge                                                                        FALSE
## parentEthnicityNot Hispanic/Latino                                               FALSE
## parentEthnicityUnknown                                                           FALSE
## parentEthnicityPrefer not to respond                                             FALSE
## parentRaceWhite                                                                  FALSE
## parentRaceAsian                                                                  FALSE
## parentRaceNoResp                                                                 FALSE
## parentMaritalStatusWidowed                                                       FALSE
## parentMaritalStatusDivorced                                                      FALSE
## parentMaritalStatusSeparated                                                     FALSE
## parentMaritalStatusRemarried                                                     FALSE
## parentMaritalStatusNever married                                                 FALSE
## parentSituationCouple parenting with spouse or partner in the same household     FALSE
## parentSituationCo-parenting in separate households                               FALSE
## zipcode90210                                                                     FALSE
## zipcode91020                                                                     FALSE
## zipcode91205                                                                     FALSE
## zipcode91210                                                                     FALSE
## zipcode91402                                                                     FALSE
## zipcode97003                                                                     FALSE
## zipcode97005                                                                     FALSE
## zipcode97006                                                                     FALSE
## zipcode97007                                                                     FALSE
## zipcode97008                                                                     FALSE
## zipcode97023                                                                     FALSE
## zipcode97032                                                                     FALSE
## zipcode97034                                                                     FALSE
## zipcode97035                                                                     FALSE
## zipcode97045                                                                     FALSE
## zipcode97056                                                                     FALSE
## zipcode97062                                                                     FALSE
## zipcode97068                                                                     FALSE
## zipcode97078                                                                     FALSE
## zipcode97086                                                                     FALSE
## zipcode97086-3615                                                                FALSE
## zipcode97089                                                                     FALSE
## zipcode97101                                                                     FALSE
## zipcode97116                                                                     FALSE
## zipcode97123                                                                     FALSE
## zipcode97124                                                                     FALSE
## zipcode97140                                                                     FALSE
## zipcode97141                                                                     FALSE
## zipcode97201                                                                     FALSE
## zipcode97202                                                                     FALSE
## zipcode97206                                                                     FALSE
## zipcode97209                                                                     FALSE
## zipcode97211                                                                     FALSE
## zipcode97212                                                                     FALSE
## zipcode97213                                                                     FALSE
## zipcode97214                                                                     FALSE
## zipcode97215                                                                     FALSE
## zipcode97217                                                                     FALSE
## zipcode97219                                                                     FALSE
## zipcode97220                                                                     FALSE
## zipcode97222                                                                     FALSE
## zipcode97223                                                                     FALSE
## zipcode97224                                                                     FALSE
## zipcode97225                                                                     FALSE
## zipcode97227                                                                     FALSE
## zipcode97229                                                                     FALSE
## zipcode97230                                                                     FALSE
## zipcode97232                                                                     FALSE
## zipcode97232-2555                                                                FALSE
## zipcode97233                                                                     FALSE
## zipcode97236                                                                     FALSE
## zipcode97239                                                                     FALSE
## zipcode97266                                                                     FALSE
## zipcode97267                                                                     FALSE
## zipcode97321                                                                     FALSE
## zipcode97325                                                                     FALSE
## zipcode97429                                                                     FALSE
## zipcode97527                                                                     FALSE
## zipcode97701                                                                     FALSE
## zipcode97702                                                                     FALSE
## zipcode97703                                                                     FALSE
## zipcode97734                                                                     FALSE
## zipcode97738                                                                     FALSE
## zipcode97741                                                                     FALSE
## zipcode97754                                                                     FALSE
## zipcode97756                                                                     FALSE
## zipcode97757                                                                     FALSE
## zipcode97759                                                                     FALSE
## zipcode97760                                                                     FALSE
## zipcode97825                                                                     FALSE
## zipcode98632                                                                     FALSE
## zipcode98660                                                                     FALSE
## zipcode98683                                                                     FALSE
## communitySuburban                                                                FALSE
## communityRural                                                                   FALSE
## distance                                                                         FALSE
## parentEducationVocational school/some college                                    FALSE
## parentEducationCollege                                                           FALSE
## parentEducationGraduate/professional school                                      FALSE
## income$25,001-$49,999                                                            FALSE
## income$50,000-$79,999                                                            FALSE
## income$80,000-$119,999                                                           FALSE
## income$120,000-$149,999                                                          FALSE
## income$150,000 or more                                                           FALSE
## ECBI_intensity_T_score                                                           FALSE
## ECBI_intensity_clinical_cutoff                                                   FALSE
## ECBI_problem_raw_score                                                           FALSE
## ECBI_problem_clinical_cutoff                                                     FALSE
## ECBI_OPP_Tot                                                                     FALSE
## ECBI_Inatt_Tot                                                                   FALSE
## ECBI_Cond_Tot                                                                    FALSE
## MAPS_PP                                                                          FALSE
## MAPS_PR                                                                          FALSE
## MAPS_WM                                                                          FALSE
## MAPS_SP                                                                          FALSE
## MAPS_HS                                                                          FALSE
## MAPS_LC                                                                          FALSE
## MAPS_PC                                                                          FALSE
## SEPTI_nurturance                                                                 FALSE
## SEPTI_n_clinical_cutoff                                                          FALSE
## SEPTI_discipline                                                                 FALSE
## SEPTI_d_clinical_cutoff                                                          FALSE
## SEPTI_play                                                                       FALSE
## SEPTI_p_clinical_cutoff                                                          FALSE
## SEPTI_routine                                                                    FALSE
## SEPTI_r_clinical_cutoff                                                          FALSE
## SEPTI_total                                                                      FALSE
## SEPTI_total_clin_cutoff                                                          FALSE
## childRelationshipGrandparent                                                     FALSE
## childRelationshipRelative                                                        FALSE
## zipcode75502                                                                     FALSE
## zipcode91204                                                                     FALSE
## zipcode91206                                                                     FALSE
## zipcode97027                                                                     FALSE
## zipcode97060                                                                     FALSE
## zipcode97071                                                                     FALSE
## zipcode97203                                                                     FALSE
## zipcode97210                                                                     FALSE
## zipcode97221                                                                     FALSE
## zipcode97707                                                                     FALSE
## zipcode97753                                                                     FALSE
## zipcode98685                                                                     FALSE
## MAPS_POS                                                                         FALSE
## MAPS_NEG                                                                         FALSE
##                                                                              Forced out
## totalChildren                                                                     FALSE
## birthOrderOldest                                                                  FALSE
## birthOrderMiddle                                                                  FALSE
## birthOrderYoungest                                                                FALSE
## childAge                                                                          FALSE
## childAgeDichotomous3 or older                                                     FALSE
## childSexMale                                                                      FALSE
## childEthnicityNot Hispanic/Latino                                                 FALSE
## childEthnicityUnknown                                                             FALSE
## childEthnicityPrefer not to respond                                               FALSE
## childRaceWhite                                                                    FALSE
## childRaceAsian                                                                    FALSE
## childRaceNoResp                                                                   FALSE
## visitTypeChild is sick or medical concern                                         FALSE
## visitTypeBehavioral or developmental concern                                      FALSE
## visitTypeFollow-up appointment                                                    FALSE
## visitTypeOther                                                                    FALSE
## childRelationshipBiological or adoptive father                                    FALSE
## childRelationshipStep parent                                                      FALSE
## childRelationshipOther                                                            FALSE
## parentGenderFemale                                                                FALSE
## parentGenderTransgender                                                           FALSE
## parentGenderOther                                                                 FALSE
## parentGenderPrefer not to respond                                                 FALSE
## parentSexMale                                                                     FALSE
## parentAge                                                                         FALSE
## parentEthnicityNot Hispanic/Latino                                                FALSE
## parentEthnicityUnknown                                                            FALSE
## parentEthnicityPrefer not to respond                                              FALSE
## parentRaceWhite                                                                   FALSE
## parentRaceAsian                                                                   FALSE
## parentRaceNoResp                                                                  FALSE
## parentMaritalStatusWidowed                                                        FALSE
## parentMaritalStatusDivorced                                                       FALSE
## parentMaritalStatusSeparated                                                      FALSE
## parentMaritalStatusRemarried                                                      FALSE
## parentMaritalStatusNever married                                                  FALSE
## parentSituationCouple parenting with spouse or partner in the same household      FALSE
## parentSituationCo-parenting in separate households                                FALSE
## zipcode90210                                                                      FALSE
## zipcode91020                                                                      FALSE
## zipcode91205                                                                      FALSE
## zipcode91210                                                                      FALSE
## zipcode91402                                                                      FALSE
## zipcode97003                                                                      FALSE
## zipcode97005                                                                      FALSE
## zipcode97006                                                                      FALSE
## zipcode97007                                                                      FALSE
## zipcode97008                                                                      FALSE
## zipcode97023                                                                      FALSE
## zipcode97032                                                                      FALSE
## zipcode97034                                                                      FALSE
## zipcode97035                                                                      FALSE
## zipcode97045                                                                      FALSE
## zipcode97056                                                                      FALSE
## zipcode97062                                                                      FALSE
## zipcode97068                                                                      FALSE
## zipcode97078                                                                      FALSE
## zipcode97086                                                                      FALSE
## zipcode97086-3615                                                                 FALSE
## zipcode97089                                                                      FALSE
## zipcode97101                                                                      FALSE
## zipcode97116                                                                      FALSE
## zipcode97123                                                                      FALSE
## zipcode97124                                                                      FALSE
## zipcode97140                                                                      FALSE
## zipcode97141                                                                      FALSE
## zipcode97201                                                                      FALSE
## zipcode97202                                                                      FALSE
## zipcode97206                                                                      FALSE
## zipcode97209                                                                      FALSE
## zipcode97211                                                                      FALSE
## zipcode97212                                                                      FALSE
## zipcode97213                                                                      FALSE
## zipcode97214                                                                      FALSE
## zipcode97215                                                                      FALSE
## zipcode97217                                                                      FALSE
## zipcode97219                                                                      FALSE
## zipcode97220                                                                      FALSE
## zipcode97222                                                                      FALSE
## zipcode97223                                                                      FALSE
## zipcode97224                                                                      FALSE
## zipcode97225                                                                      FALSE
## zipcode97227                                                                      FALSE
## zipcode97229                                                                      FALSE
## zipcode97230                                                                      FALSE
## zipcode97232                                                                      FALSE
## zipcode97232-2555                                                                 FALSE
## zipcode97233                                                                      FALSE
## zipcode97236                                                                      FALSE
## zipcode97239                                                                      FALSE
## zipcode97266                                                                      FALSE
## zipcode97267                                                                      FALSE
## zipcode97321                                                                      FALSE
## zipcode97325                                                                      FALSE
## zipcode97429                                                                      FALSE
## zipcode97527                                                                      FALSE
## zipcode97701                                                                      FALSE
## zipcode97702                                                                      FALSE
## zipcode97703                                                                      FALSE
## zipcode97734                                                                      FALSE
## zipcode97738                                                                      FALSE
## zipcode97741                                                                      FALSE
## zipcode97754                                                                      FALSE
## zipcode97756                                                                      FALSE
## zipcode97757                                                                      FALSE
## zipcode97759                                                                      FALSE
## zipcode97760                                                                      FALSE
## zipcode97825                                                                      FALSE
## zipcode98632                                                                      FALSE
## zipcode98660                                                                      FALSE
## zipcode98683                                                                      FALSE
## communitySuburban                                                                 FALSE
## communityRural                                                                    FALSE
## distance                                                                          FALSE
## parentEducationVocational school/some college                                     FALSE
## parentEducationCollege                                                            FALSE
## parentEducationGraduate/professional school                                       FALSE
## income$25,001-$49,999                                                             FALSE
## income$50,000-$79,999                                                             FALSE
## income$80,000-$119,999                                                            FALSE
## income$120,000-$149,999                                                           FALSE
## income$150,000 or more                                                            FALSE
## ECBI_intensity_T_score                                                            FALSE
## ECBI_intensity_clinical_cutoff                                                    FALSE
## ECBI_problem_raw_score                                                            FALSE
## ECBI_problem_clinical_cutoff                                                      FALSE
## ECBI_OPP_Tot                                                                      FALSE
## ECBI_Inatt_Tot                                                                    FALSE
## ECBI_Cond_Tot                                                                     FALSE
## MAPS_PP                                                                           FALSE
## MAPS_PR                                                                           FALSE
## MAPS_WM                                                                           FALSE
## MAPS_SP                                                                           FALSE
## MAPS_HS                                                                           FALSE
## MAPS_LC                                                                           FALSE
## MAPS_PC                                                                           FALSE
## SEPTI_nurturance                                                                  FALSE
## SEPTI_n_clinical_cutoff                                                           FALSE
## SEPTI_discipline                                                                  FALSE
## SEPTI_d_clinical_cutoff                                                           FALSE
## SEPTI_play                                                                        FALSE
## SEPTI_p_clinical_cutoff                                                           FALSE
## SEPTI_routine                                                                     FALSE
## SEPTI_r_clinical_cutoff                                                           FALSE
## SEPTI_total                                                                       FALSE
## SEPTI_total_clin_cutoff                                                           FALSE
## childRelationshipGrandparent                                                      FALSE
## childRelationshipRelative                                                         FALSE
## zipcode75502                                                                      FALSE
## zipcode91204                                                                      FALSE
## zipcode91206                                                                      FALSE
## zipcode97027                                                                      FALSE
## zipcode97060                                                                      FALSE
## zipcode97071                                                                      FALSE
## zipcode97203                                                                      FALSE
## zipcode97210                                                                      FALSE
## zipcode97221                                                                      FALSE
## zipcode97707                                                                      FALSE
## zipcode97753                                                                      FALSE
## zipcode98685                                                                      FALSE
## MAPS_POS                                                                          FALSE
## MAPS_NEG                                                                          FALSE
## 1 subsets of each size up to 27
## Selection Algorithm: 'sequential replacement'
```

```
## Subset selection object
## 163 Variables  (and intercept)
##                                                                              Forced in
## totalChildren                                                                    FALSE
## birthOrderOldest                                                                 FALSE
## birthOrderMiddle                                                                 FALSE
## birthOrderYoungest                                                               FALSE
## childAge                                                                         FALSE
## childAgeDichotomous3 or older                                                    FALSE
## childSexMale                                                                     FALSE
## childEthnicityNot Hispanic/Latino                                                FALSE
## childEthnicityUnknown                                                            FALSE
## childEthnicityPrefer not to respond                                              FALSE
## childRaceWhite                                                                   FALSE
## childRaceAsian                                                                   FALSE
## childRaceNoResp                                                                  FALSE
## visitTypeChild is sick or medical concern                                        FALSE
## visitTypeBehavioral or developmental concern                                     FALSE
## visitTypeFollow-up appointment                                                   FALSE
## visitTypeOther                                                                   FALSE
## childRelationshipBiological or adoptive father                                   FALSE
## childRelationshipStep parent                                                     FALSE
## childRelationshipOther                                                           FALSE
## parentGenderFemale                                                               FALSE
## parentGenderTransgender                                                          FALSE
## parentGenderOther                                                                FALSE
## parentGenderPrefer not to respond                                                FALSE
## parentSexMale                                                                    FALSE
## parentAge                                                                        FALSE
## parentEthnicityNot Hispanic/Latino                                               FALSE
## parentEthnicityUnknown                                                           FALSE
## parentEthnicityPrefer not to respond                                             FALSE
## parentRaceWhite                                                                  FALSE
## parentRaceAsian                                                                  FALSE
## parentRaceNoResp                                                                 FALSE
## parentMaritalStatusWidowed                                                       FALSE
## parentMaritalStatusDivorced                                                      FALSE
## parentMaritalStatusSeparated                                                     FALSE
## parentMaritalStatusRemarried                                                     FALSE
## parentMaritalStatusNever married                                                 FALSE
## parentSituationCouple parenting with spouse or partner in the same household     FALSE
## parentSituationCo-parenting in separate households                               FALSE
## zipcode90210                                                                     FALSE
## zipcode91020                                                                     FALSE
## zipcode91205                                                                     FALSE
## zipcode91210                                                                     FALSE
## zipcode91402                                                                     FALSE
## zipcode97003                                                                     FALSE
## zipcode97005                                                                     FALSE
## zipcode97006                                                                     FALSE
## zipcode97007                                                                     FALSE
## zipcode97008                                                                     FALSE
## zipcode97023                                                                     FALSE
## zipcode97032                                                                     FALSE
## zipcode97034                                                                     FALSE
## zipcode97035                                                                     FALSE
## zipcode97045                                                                     FALSE
## zipcode97056                                                                     FALSE
## zipcode97062                                                                     FALSE
## zipcode97068                                                                     FALSE
## zipcode97078                                                                     FALSE
## zipcode97086                                                                     FALSE
## zipcode97086-3615                                                                FALSE
## zipcode97089                                                                     FALSE
## zipcode97101                                                                     FALSE
## zipcode97116                                                                     FALSE
## zipcode97123                                                                     FALSE
## zipcode97124                                                                     FALSE
## zipcode97140                                                                     FALSE
## zipcode97141                                                                     FALSE
## zipcode97201                                                                     FALSE
## zipcode97202                                                                     FALSE
## zipcode97206                                                                     FALSE
## zipcode97209                                                                     FALSE
## zipcode97211                                                                     FALSE
## zipcode97212                                                                     FALSE
## zipcode97213                                                                     FALSE
## zipcode97214                                                                     FALSE
## zipcode97215                                                                     FALSE
## zipcode97217                                                                     FALSE
## zipcode97219                                                                     FALSE
## zipcode97220                                                                     FALSE
## zipcode97222                                                                     FALSE
## zipcode97223                                                                     FALSE
## zipcode97224                                                                     FALSE
## zipcode97225                                                                     FALSE
## zipcode97227                                                                     FALSE
## zipcode97229                                                                     FALSE
## zipcode97230                                                                     FALSE
## zipcode97232                                                                     FALSE
## zipcode97232-2555                                                                FALSE
## zipcode97233                                                                     FALSE
## zipcode97236                                                                     FALSE
## zipcode97239                                                                     FALSE
## zipcode97266                                                                     FALSE
## zipcode97267                                                                     FALSE
## zipcode97321                                                                     FALSE
## zipcode97325                                                                     FALSE
## zipcode97429                                                                     FALSE
## zipcode97527                                                                     FALSE
## zipcode97701                                                                     FALSE
## zipcode97702                                                                     FALSE
## zipcode97703                                                                     FALSE
## zipcode97734                                                                     FALSE
## zipcode97738                                                                     FALSE
## zipcode97741                                                                     FALSE
## zipcode97754                                                                     FALSE
## zipcode97756                                                                     FALSE
## zipcode97757                                                                     FALSE
## zipcode97759                                                                     FALSE
## zipcode97760                                                                     FALSE
## zipcode97825                                                                     FALSE
## zipcode98632                                                                     FALSE
## zipcode98660                                                                     FALSE
## zipcode98683                                                                     FALSE
## communitySuburban                                                                FALSE
## communityRural                                                                   FALSE
## distance                                                                         FALSE
## parentEducationVocational school/some college                                    FALSE
## parentEducationCollege                                                           FALSE
## parentEducationGraduate/professional school                                      FALSE
## income$25,001-$49,999                                                            FALSE
## income$50,000-$79,999                                                            FALSE
## income$80,000-$119,999                                                           FALSE
## income$120,000-$149,999                                                          FALSE
## income$150,000 or more                                                           FALSE
## ECBI_intensity_T_score                                                           FALSE
## ECBI_intensity_clinical_cutoff                                                   FALSE
## ECBI_problem_raw_score                                                           FALSE
## ECBI_problem_clinical_cutoff                                                     FALSE
## ECBI_OPP_Tot                                                                     FALSE
## ECBI_Inatt_Tot                                                                   FALSE
## ECBI_Cond_Tot                                                                    FALSE
## MAPS_PP                                                                          FALSE
## MAPS_PR                                                                          FALSE
## MAPS_WM                                                                          FALSE
## MAPS_SP                                                                          FALSE
## MAPS_HS                                                                          FALSE
## MAPS_LC                                                                          FALSE
## MAPS_PC                                                                          FALSE
## SEPTI_nurturance                                                                 FALSE
## SEPTI_n_clinical_cutoff                                                          FALSE
## SEPTI_discipline                                                                 FALSE
## SEPTI_d_clinical_cutoff                                                          FALSE
## SEPTI_play                                                                       FALSE
## SEPTI_p_clinical_cutoff                                                          FALSE
## SEPTI_routine                                                                    FALSE
## SEPTI_r_clinical_cutoff                                                          FALSE
## SEPTI_total                                                                      FALSE
## SEPTI_total_clin_cutoff                                                          FALSE
## childRelationshipGrandparent                                                     FALSE
## childRelationshipRelative                                                        FALSE
## zipcode75502                                                                     FALSE
## zipcode91204                                                                     FALSE
## zipcode91206                                                                     FALSE
## zipcode97027                                                                     FALSE
## zipcode97060                                                                     FALSE
## zipcode97071                                                                     FALSE
## zipcode97203                                                                     FALSE
## zipcode97210                                                                     FALSE
## zipcode97221                                                                     FALSE
## zipcode97707                                                                     FALSE
## zipcode97753                                                                     FALSE
## zipcode98685                                                                     FALSE
## MAPS_POS                                                                         FALSE
## MAPS_NEG                                                                         FALSE
##                                                                              Forced out
## totalChildren                                                                     FALSE
## birthOrderOldest                                                                  FALSE
## birthOrderMiddle                                                                  FALSE
## birthOrderYoungest                                                                FALSE
## childAge                                                                          FALSE
## childAgeDichotomous3 or older                                                     FALSE
## childSexMale                                                                      FALSE
## childEthnicityNot Hispanic/Latino                                                 FALSE
## childEthnicityUnknown                                                             FALSE
## childEthnicityPrefer not to respond                                               FALSE
## childRaceWhite                                                                    FALSE
## childRaceAsian                                                                    FALSE
## childRaceNoResp                                                                   FALSE
## visitTypeChild is sick or medical concern                                         FALSE
## visitTypeBehavioral or developmental concern                                      FALSE
## visitTypeFollow-up appointment                                                    FALSE
## visitTypeOther                                                                    FALSE
## childRelationshipBiological or adoptive father                                    FALSE
## childRelationshipStep parent                                                      FALSE
## childRelationshipOther                                                            FALSE
## parentGenderFemale                                                                FALSE
## parentGenderTransgender                                                           FALSE
## parentGenderOther                                                                 FALSE
## parentGenderPrefer not to respond                                                 FALSE
## parentSexMale                                                                     FALSE
## parentAge                                                                         FALSE
## parentEthnicityNot Hispanic/Latino                                                FALSE
## parentEthnicityUnknown                                                            FALSE
## parentEthnicityPrefer not to respond                                              FALSE
## parentRaceWhite                                                                   FALSE
## parentRaceAsian                                                                   FALSE
## parentRaceNoResp                                                                  FALSE
## parentMaritalStatusWidowed                                                        FALSE
## parentMaritalStatusDivorced                                                       FALSE
## parentMaritalStatusSeparated                                                      FALSE
## parentMaritalStatusRemarried                                                      FALSE
## parentMaritalStatusNever married                                                  FALSE
## parentSituationCouple parenting with spouse or partner in the same household      FALSE
## parentSituationCo-parenting in separate households                                FALSE
## zipcode90210                                                                      FALSE
## zipcode91020                                                                      FALSE
## zipcode91205                                                                      FALSE
## zipcode91210                                                                      FALSE
## zipcode91402                                                                      FALSE
## zipcode97003                                                                      FALSE
## zipcode97005                                                                      FALSE
## zipcode97006                                                                      FALSE
## zipcode97007                                                                      FALSE
## zipcode97008                                                                      FALSE
## zipcode97023                                                                      FALSE
## zipcode97032                                                                      FALSE
## zipcode97034                                                                      FALSE
## zipcode97035                                                                      FALSE
## zipcode97045                                                                      FALSE
## zipcode97056                                                                      FALSE
## zipcode97062                                                                      FALSE
## zipcode97068                                                                      FALSE
## zipcode97078                                                                      FALSE
## zipcode97086                                                                      FALSE
## zipcode97086-3615                                                                 FALSE
## zipcode97089                                                                      FALSE
## zipcode97101                                                                      FALSE
## zipcode97116                                                                      FALSE
## zipcode97123                                                                      FALSE
## zipcode97124                                                                      FALSE
## zipcode97140                                                                      FALSE
## zipcode97141                                                                      FALSE
## zipcode97201                                                                      FALSE
## zipcode97202                                                                      FALSE
## zipcode97206                                                                      FALSE
## zipcode97209                                                                      FALSE
## zipcode97211                                                                      FALSE
## zipcode97212                                                                      FALSE
## zipcode97213                                                                      FALSE
## zipcode97214                                                                      FALSE
## zipcode97215                                                                      FALSE
## zipcode97217                                                                      FALSE
## zipcode97219                                                                      FALSE
## zipcode97220                                                                      FALSE
## zipcode97222                                                                      FALSE
## zipcode97223                                                                      FALSE
## zipcode97224                                                                      FALSE
## zipcode97225                                                                      FALSE
## zipcode97227                                                                      FALSE
## zipcode97229                                                                      FALSE
## zipcode97230                                                                      FALSE
## zipcode97232                                                                      FALSE
## zipcode97232-2555                                                                 FALSE
## zipcode97233                                                                      FALSE
## zipcode97236                                                                      FALSE
## zipcode97239                                                                      FALSE
## zipcode97266                                                                      FALSE
## zipcode97267                                                                      FALSE
## zipcode97321                                                                      FALSE
## zipcode97325                                                                      FALSE
## zipcode97429                                                                      FALSE
## zipcode97527                                                                      FALSE
## zipcode97701                                                                      FALSE
## zipcode97702                                                                      FALSE
## zipcode97703                                                                      FALSE
## zipcode97734                                                                      FALSE
## zipcode97738                                                                      FALSE
## zipcode97741                                                                      FALSE
## zipcode97754                                                                      FALSE
## zipcode97756                                                                      FALSE
## zipcode97757                                                                      FALSE
## zipcode97759                                                                      FALSE
## zipcode97760                                                                      FALSE
## zipcode97825                                                                      FALSE
## zipcode98632                                                                      FALSE
## zipcode98660                                                                      FALSE
## zipcode98683                                                                      FALSE
## communitySuburban                                                                 FALSE
## communityRural                                                                    FALSE
## distance                                                                          FALSE
## parentEducationVocational school/some college                                     FALSE
## parentEducationCollege                                                            FALSE
## parentEducationGraduate/professional school                                       FALSE
## income$25,001-$49,999                                                             FALSE
## income$50,000-$79,999                                                             FALSE
## income$80,000-$119,999                                                            FALSE
## income$120,000-$149,999                                                           FALSE
## income$150,000 or more                                                            FALSE
## ECBI_intensity_T_score                                                            FALSE
## ECBI_intensity_clinical_cutoff                                                    FALSE
## ECBI_problem_raw_score                                                            FALSE
## ECBI_problem_clinical_cutoff                                                      FALSE
## ECBI_OPP_Tot                                                                      FALSE
## ECBI_Inatt_Tot                                                                    FALSE
## ECBI_Cond_Tot                                                                     FALSE
## MAPS_PP                                                                           FALSE
## MAPS_PR                                                                           FALSE
## MAPS_WM                                                                           FALSE
## MAPS_SP                                                                           FALSE
## MAPS_HS                                                                           FALSE
## MAPS_LC                                                                           FALSE
## MAPS_PC                                                                           FALSE
## SEPTI_nurturance                                                                  FALSE
## SEPTI_n_clinical_cutoff                                                           FALSE
## SEPTI_discipline                                                                  FALSE
## SEPTI_d_clinical_cutoff                                                           FALSE
## SEPTI_play                                                                        FALSE
## SEPTI_p_clinical_cutoff                                                           FALSE
## SEPTI_routine                                                                     FALSE
## SEPTI_r_clinical_cutoff                                                           FALSE
## SEPTI_total                                                                       FALSE
## SEPTI_total_clin_cutoff                                                           FALSE
## childRelationshipGrandparent                                                      FALSE
## childRelationshipRelative                                                         FALSE
## zipcode75502                                                                      FALSE
## zipcode91204                                                                      FALSE
## zipcode91206                                                                      FALSE
## zipcode97027                                                                      FALSE
## zipcode97060                                                                      FALSE
## zipcode97071                                                                      FALSE
## zipcode97203                                                                      FALSE
## zipcode97210                                                                      FALSE
## zipcode97221                                                                      FALSE
## zipcode97707                                                                      FALSE
## zipcode97753                                                                      FALSE
## zipcode98685                                                                      FALSE
## MAPS_POS                                                                          FALSE
## MAPS_NEG                                                                          FALSE
## 1 subsets of each size up to 27
## Selection Algorithm: 'sequential replacement'
##           totalChildren birthOrderOldest birthOrderMiddle
## 1  ( 1 )  " "           " "              " "             
## 2  ( 1 )  " "           " "              " "             
## 3  ( 1 )  " "           " "              " "             
## 4  ( 1 )  " "           " "              "*"             
## 5  ( 1 )  " "           " "              " "             
## 6  ( 1 )  " "           " "              "*"             
## 7  ( 1 )  " "           " "              "*"             
## 8  ( 1 )  " "           " "              "*"             
## 9  ( 1 )  " "           " "              "*"             
## 10  ( 1 ) " "           " "              "*"             
## 11  ( 1 ) " "           " "              "*"             
## 12  ( 1 ) " "           " "              "*"             
## 13  ( 1 ) " "           " "              "*"             
## 14  ( 1 ) " "           " "              "*"             
## 15  ( 1 ) " "           " "              "*"             
## 16  ( 1 ) " "           " "              "*"             
## 17  ( 1 ) " "           " "              "*"             
## 18  ( 1 ) " "           " "              "*"             
## 19  ( 1 ) "*"           "*"              "*"             
## 20  ( 1 ) " "           " "              "*"             
## 21  ( 1 ) " "           " "              "*"             
## 22  ( 1 ) " "           " "              "*"             
## 23  ( 1 ) " "           " "              "*"             
## 24  ( 1 ) " "           " "              "*"             
## 25  ( 1 ) " "           " "              "*"             
## 26  ( 1 ) " "           " "              "*"             
## 27  ( 1 ) " "           " "              "*"             
##           birthOrderYoungest childAge childAgeDichotomous3 or older
## 1  ( 1 )  " "                " "      " "                          
## 2  ( 1 )  " "                " "      " "                          
## 3  ( 1 )  " "                " "      " "                          
## 4  ( 1 )  " "                " "      " "                          
## 5  ( 1 )  " "                " "      " "                          
## 6  ( 1 )  " "                " "      " "                          
## 7  ( 1 )  " "                " "      " "                          
## 8  ( 1 )  " "                " "      " "                          
## 9  ( 1 )  " "                " "      " "                          
## 10  ( 1 ) " "                " "      " "                          
## 11  ( 1 ) " "                " "      " "                          
## 12  ( 1 ) " "                " "      "*"                          
## 13  ( 1 ) " "                " "      "*"                          
## 14  ( 1 ) " "                " "      "*"                          
## 15  ( 1 ) " "                " "      "*"                          
## 16  ( 1 ) " "                " "      "*"                          
## 17  ( 1 ) " "                " "      "*"                          
## 18  ( 1 ) " "                " "      "*"                          
## 19  ( 1 ) "*"                "*"      "*"                          
## 20  ( 1 ) " "                " "      "*"                          
## 21  ( 1 ) "*"                " "      "*"                          
## 22  ( 1 ) "*"                " "      "*"                          
## 23  ( 1 ) "*"                " "      "*"                          
## 24  ( 1 ) "*"                " "      "*"                          
## 25  ( 1 ) "*"                " "      "*"                          
## 26  ( 1 ) "*"                " "      "*"                          
## 27  ( 1 ) "*"                " "      "*"                          
##           childSexMale childEthnicityNot Hispanic/Latino
## 1  ( 1 )  " "          " "                              
## 2  ( 1 )  " "          " "                              
## 3  ( 1 )  " "          " "                              
## 4  ( 1 )  " "          " "                              
## 5  ( 1 )  " "          " "                              
## 6  ( 1 )  " "          " "                              
## 7  ( 1 )  " "          " "                              
## 8  ( 1 )  " "          " "                              
## 9  ( 1 )  " "          " "                              
## 10  ( 1 ) " "          " "                              
## 11  ( 1 ) " "          " "                              
## 12  ( 1 ) " "          " "                              
## 13  ( 1 ) " "          " "                              
## 14  ( 1 ) " "          " "                              
## 15  ( 1 ) " "          " "                              
## 16  ( 1 ) " "          " "                              
## 17  ( 1 ) " "          " "                              
## 18  ( 1 ) " "          " "                              
## 19  ( 1 ) "*"          "*"                              
## 20  ( 1 ) " "          " "                              
## 21  ( 1 ) " "          " "                              
## 22  ( 1 ) " "          " "                              
## 23  ( 1 ) " "          " "                              
## 24  ( 1 ) " "          " "                              
## 25  ( 1 ) " "          " "                              
## 26  ( 1 ) " "          " "                              
## 27  ( 1 ) " "          " "                              
##           childEthnicityUnknown childEthnicityPrefer not to respond
## 1  ( 1 )  " "                   " "                                
## 2  ( 1 )  " "                   " "                                
## 3  ( 1 )  " "                   " "                                
## 4  ( 1 )  " "                   " "                                
## 5  ( 1 )  " "                   " "                                
## 6  ( 1 )  " "                   " "                                
## 7  ( 1 )  " "                   " "                                
## 8  ( 1 )  " "                   " "                                
## 9  ( 1 )  " "                   " "                                
## 10  ( 1 ) " "                   " "                                
## 11  ( 1 ) " "                   " "                                
## 12  ( 1 ) " "                   " "                                
## 13  ( 1 ) " "                   " "                                
## 14  ( 1 ) " "                   " "                                
## 15  ( 1 ) " "                   " "                                
## 16  ( 1 ) " "                   " "                                
## 17  ( 1 ) " "                   " "                                
## 18  ( 1 ) " "                   " "                                
## 19  ( 1 ) "*"                   "*"                                
## 20  ( 1 ) " "                   " "                                
## 21  ( 1 ) " "                   " "                                
## 22  ( 1 ) " "                   " "                                
## 23  ( 1 ) " "                   " "                                
## 24  ( 1 ) " "                   " "                                
## 25  ( 1 ) " "                   " "                                
## 26  ( 1 ) " "                   " "                                
## 27  ( 1 ) " "                   " "                                
##           childRaceWhite childRaceAsian childRaceNoResp
## 1  ( 1 )  "*"            " "            " "            
## 2  ( 1 )  "*"            " "            " "            
## 3  ( 1 )  "*"            " "            " "            
## 4  ( 1 )  "*"            " "            " "            
## 5  ( 1 )  "*"            " "            " "            
## 6  ( 1 )  "*"            " "            " "            
## 7  ( 1 )  "*"            " "            " "            
## 8  ( 1 )  "*"            " "            " "            
## 9  ( 1 )  "*"            " "            " "            
## 10  ( 1 ) "*"            " "            " "            
## 11  ( 1 ) "*"            " "            " "            
## 12  ( 1 ) "*"            " "            " "            
## 13  ( 1 ) "*"            " "            " "            
## 14  ( 1 ) "*"            " "            " "            
## 15  ( 1 ) "*"            " "            " "            
## 16  ( 1 ) "*"            " "            " "            
## 17  ( 1 ) "*"            " "            " "            
## 18  ( 1 ) "*"            " "            " "            
## 19  ( 1 ) "*"            "*"            "*"            
## 20  ( 1 ) "*"            " "            " "            
## 21  ( 1 ) "*"            " "            " "            
## 22  ( 1 ) "*"            " "            " "            
## 23  ( 1 ) "*"            " "            " "            
## 24  ( 1 ) "*"            " "            " "            
## 25  ( 1 ) "*"            " "            " "            
## 26  ( 1 ) "*"            " "            " "            
## 27  ( 1 ) "*"            " "            " "            
##           visitTypeChild is sick or medical concern
## 1  ( 1 )  " "                                      
## 2  ( 1 )  " "                                      
## 3  ( 1 )  " "                                      
## 4  ( 1 )  " "                                      
## 5  ( 1 )  " "                                      
## 6  ( 1 )  " "                                      
## 7  ( 1 )  " "                                      
## 8  ( 1 )  " "                                      
## 9  ( 1 )  " "                                      
## 10  ( 1 ) " "                                      
## 11  ( 1 ) " "                                      
## 12  ( 1 ) " "                                      
## 13  ( 1 ) " "                                      
## 14  ( 1 ) " "                                      
## 15  ( 1 ) " "                                      
## 16  ( 1 ) " "                                      
## 17  ( 1 ) " "                                      
## 18  ( 1 ) " "                                      
## 19  ( 1 ) "*"                                      
## 20  ( 1 ) " "                                      
## 21  ( 1 ) " "                                      
## 22  ( 1 ) " "                                      
## 23  ( 1 ) " "                                      
## 24  ( 1 ) " "                                      
## 25  ( 1 ) " "                                      
## 26  ( 1 ) " "                                      
## 27  ( 1 ) " "                                      
##           visitTypeBehavioral or developmental concern
## 1  ( 1 )  " "                                         
## 2  ( 1 )  " "                                         
## 3  ( 1 )  " "                                         
## 4  ( 1 )  " "                                         
## 5  ( 1 )  " "                                         
## 6  ( 1 )  " "                                         
## 7  ( 1 )  " "                                         
## 8  ( 1 )  " "                                         
## 9  ( 1 )  " "                                         
## 10  ( 1 ) " "                                         
## 11  ( 1 ) " "                                         
## 12  ( 1 ) " "                                         
## 13  ( 1 ) " "                                         
## 14  ( 1 ) " "                                         
## 15  ( 1 ) " "                                         
## 16  ( 1 ) " "                                         
## 17  ( 1 ) " "                                         
## 18  ( 1 ) " "                                         
## 19  ( 1 ) "*"                                         
## 20  ( 1 ) " "                                         
## 21  ( 1 ) " "                                         
## 22  ( 1 ) " "                                         
## 23  ( 1 ) " "                                         
## 24  ( 1 ) " "                                         
## 25  ( 1 ) " "                                         
## 26  ( 1 ) " "                                         
## 27  ( 1 ) " "                                         
##           visitTypeFollow-up appointment visitTypeOther
## 1  ( 1 )  " "                            " "           
## 2  ( 1 )  " "                            " "           
## 3  ( 1 )  " "                            " "           
## 4  ( 1 )  " "                            " "           
## 5  ( 1 )  " "                            " "           
## 6  ( 1 )  " "                            " "           
## 7  ( 1 )  " "                            " "           
## 8  ( 1 )  " "                            " "           
## 9  ( 1 )  " "                            " "           
## 10  ( 1 ) " "                            "*"           
## 11  ( 1 ) " "                            "*"           
## 12  ( 1 ) " "                            "*"           
## 13  ( 1 ) " "                            "*"           
## 14  ( 1 ) " "                            "*"           
## 15  ( 1 ) " "                            "*"           
## 16  ( 1 ) " "                            "*"           
## 17  ( 1 ) " "                            "*"           
## 18  ( 1 ) " "                            "*"           
## 19  ( 1 ) "*"                            "*"           
## 20  ( 1 ) " "                            "*"           
## 21  ( 1 ) " "                            "*"           
## 22  ( 1 ) " "                            "*"           
## 23  ( 1 ) " "                            "*"           
## 24  ( 1 ) " "                            "*"           
## 25  ( 1 ) " "                            "*"           
## 26  ( 1 ) " "                            "*"           
## 27  ( 1 ) " "                            "*"           
##           childRelationshipBiological or adoptive father
## 1  ( 1 )  " "                                           
## 2  ( 1 )  " "                                           
## 3  ( 1 )  " "                                           
## 4  ( 1 )  " "                                           
## 5  ( 1 )  " "                                           
## 6  ( 1 )  " "                                           
## 7  ( 1 )  " "                                           
## 8  ( 1 )  " "                                           
## 9  ( 1 )  " "                                           
## 10  ( 1 ) " "                                           
## 11  ( 1 ) " "                                           
## 12  ( 1 ) " "                                           
## 13  ( 1 ) " "                                           
## 14  ( 1 ) " "                                           
## 15  ( 1 ) " "                                           
## 16  ( 1 ) " "                                           
## 17  ( 1 ) " "                                           
## 18  ( 1 ) " "                                           
## 19  ( 1 ) "*"                                           
## 20  ( 1 ) " "                                           
## 21  ( 1 ) " "                                           
## 22  ( 1 ) " "                                           
## 23  ( 1 ) " "                                           
## 24  ( 1 ) " "                                           
## 25  ( 1 ) " "                                           
## 26  ( 1 ) " "                                           
## 27  ( 1 ) " "                                           
##           childRelationshipStep parent childRelationshipGrandparent
## 1  ( 1 )  " "                          " "                         
## 2  ( 1 )  " "                          " "                         
## 3  ( 1 )  " "                          " "                         
## 4  ( 1 )  " "                          " "                         
## 5  ( 1 )  " "                          " "                         
## 6  ( 1 )  " "                          " "                         
## 7  ( 1 )  " "                          " "                         
## 8  ( 1 )  " "                          " "                         
## 9  ( 1 )  " "                          " "                         
## 10  ( 1 ) " "                          " "                         
## 11  ( 1 ) " "                          " "                         
## 12  ( 1 ) " "                          " "                         
## 13  ( 1 ) " "                          " "                         
## 14  ( 1 ) " "                          " "                         
## 15  ( 1 ) " "                          " "                         
## 16  ( 1 ) " "                          " "                         
## 17  ( 1 ) " "                          " "                         
## 18  ( 1 ) " "                          " "                         
## 19  ( 1 ) "*"                          " "                         
## 20  ( 1 ) " "                          " "                         
## 21  ( 1 ) " "                          " "                         
## 22  ( 1 ) " "                          " "                         
## 23  ( 1 ) " "                          " "                         
## 24  ( 1 ) " "                          " "                         
## 25  ( 1 ) " "                          " "                         
## 26  ( 1 ) " "                          " "                         
## 27  ( 1 ) " "                          " "                         
##           childRelationshipRelative childRelationshipOther
## 1  ( 1 )  " "                       " "                   
## 2  ( 1 )  " "                       " "                   
## 3  ( 1 )  " "                       " "                   
## 4  ( 1 )  " "                       " "                   
## 5  ( 1 )  " "                       " "                   
## 6  ( 1 )  " "                       " "                   
## 7  ( 1 )  " "                       " "                   
## 8  ( 1 )  " "                       " "                   
## 9  ( 1 )  " "                       " "                   
## 10  ( 1 ) " "                       " "                   
## 11  ( 1 ) " "                       " "                   
## 12  ( 1 ) " "                       " "                   
## 13  ( 1 ) " "                       " "                   
## 14  ( 1 ) " "                       " "                   
## 15  ( 1 ) " "                       " "                   
## 16  ( 1 ) " "                       " "                   
## 17  ( 1 ) " "                       " "                   
## 18  ( 1 ) " "                       " "                   
## 19  ( 1 ) " "                       " "                   
## 20  ( 1 ) " "                       " "                   
## 21  ( 1 ) " "                       " "                   
## 22  ( 1 ) " "                       " "                   
## 23  ( 1 ) " "                       " "                   
## 24  ( 1 ) " "                       " "                   
## 25  ( 1 ) " "                       " "                   
## 26  ( 1 ) " "                       " "                   
## 27  ( 1 ) " "                       " "                   
##           parentGenderFemale parentGenderTransgender parentGenderOther
## 1  ( 1 )  " "                " "                     " "              
## 2  ( 1 )  " "                " "                     " "              
## 3  ( 1 )  " "                " "                     " "              
## 4  ( 1 )  " "                " "                     " "              
## 5  ( 1 )  " "                " "                     " "              
## 6  ( 1 )  " "                " "                     " "              
## 7  ( 1 )  " "                " "                     " "              
## 8  ( 1 )  " "                " "                     " "              
## 9  ( 1 )  " "                "*"                     " "              
## 10  ( 1 ) " "                "*"                     " "              
## 11  ( 1 ) " "                "*"                     " "              
## 12  ( 1 ) " "                "*"                     " "              
## 13  ( 1 ) " "                "*"                     " "              
## 14  ( 1 ) " "                "*"                     " "              
## 15  ( 1 ) " "                "*"                     " "              
## 16  ( 1 ) " "                "*"                     " "              
## 17  ( 1 ) " "                "*"                     " "              
## 18  ( 1 ) " "                "*"                     " "              
## 19  ( 1 ) " "                " "                     " "              
## 20  ( 1 ) " "                "*"                     " "              
## 21  ( 1 ) " "                "*"                     " "              
## 22  ( 1 ) " "                "*"                     " "              
## 23  ( 1 ) " "                "*"                     " "              
## 24  ( 1 ) " "                "*"                     " "              
## 25  ( 1 ) " "                "*"                     " "              
## 26  ( 1 ) " "                "*"                     " "              
## 27  ( 1 ) " "                "*"                     " "              
##           parentGenderPrefer not to respond parentSexMale parentAge
## 1  ( 1 )  " "                               " "           " "      
## 2  ( 1 )  " "                               " "           " "      
## 3  ( 1 )  " "                               " "           " "      
## 4  ( 1 )  " "                               " "           " "      
## 5  ( 1 )  " "                               " "           " "      
## 6  ( 1 )  " "                               " "           " "      
## 7  ( 1 )  " "                               " "           " "      
## 8  ( 1 )  " "                               " "           " "      
## 9  ( 1 )  " "                               " "           " "      
## 10  ( 1 ) " "                               " "           " "      
## 11  ( 1 ) " "                               " "           " "      
## 12  ( 1 ) " "                               " "           " "      
## 13  ( 1 ) " "                               " "           " "      
## 14  ( 1 ) " "                               " "           " "      
## 15  ( 1 ) " "                               " "           " "      
## 16  ( 1 ) " "                               " "           " "      
## 17  ( 1 ) " "                               " "           " "      
## 18  ( 1 ) " "                               " "           "*"      
## 19  ( 1 ) " "                               " "           " "      
## 20  ( 1 ) " "                               " "           "*"      
## 21  ( 1 ) " "                               " "           "*"      
## 22  ( 1 ) " "                               " "           "*"      
## 23  ( 1 ) " "                               " "           "*"      
## 24  ( 1 ) " "                               " "           "*"      
## 25  ( 1 ) " "                               " "           "*"      
## 26  ( 1 ) " "                               " "           "*"      
## 27  ( 1 ) " "                               " "           "*"      
##           parentEthnicityNot Hispanic/Latino parentEthnicityUnknown
## 1  ( 1 )  " "                                " "                   
## 2  ( 1 )  " "                                " "                   
## 3  ( 1 )  " "                                " "                   
## 4  ( 1 )  " "                                " "                   
## 5  ( 1 )  " "                                " "                   
## 6  ( 1 )  " "                                " "                   
## 7  ( 1 )  " "                                " "                   
## 8  ( 1 )  " "                                " "                   
## 9  ( 1 )  " "                                " "                   
## 10  ( 1 ) " "                                " "                   
## 11  ( 1 ) " "                                " "                   
## 12  ( 1 ) " "                                " "                   
## 13  ( 1 ) " "                                " "                   
## 14  ( 1 ) " "                                " "                   
## 15  ( 1 ) " "                                " "                   
## 16  ( 1 ) " "                                " "                   
## 17  ( 1 ) " "                                " "                   
## 18  ( 1 ) " "                                " "                   
## 19  ( 1 ) " "                                " "                   
## 20  ( 1 ) " "                                " "                   
## 21  ( 1 ) " "                                " "                   
## 22  ( 1 ) " "                                " "                   
## 23  ( 1 ) " "                                " "                   
## 24  ( 1 ) " "                                " "                   
## 25  ( 1 ) " "                                " "                   
## 26  ( 1 ) " "                                " "                   
## 27  ( 1 ) " "                                " "                   
##           parentEthnicityPrefer not to respond parentRaceWhite
## 1  ( 1 )  " "                                  " "            
## 2  ( 1 )  " "                                  " "            
## 3  ( 1 )  " "                                  " "            
## 4  ( 1 )  " "                                  " "            
## 5  ( 1 )  " "                                  " "            
## 6  ( 1 )  " "                                  " "            
## 7  ( 1 )  " "                                  " "            
## 8  ( 1 )  " "                                  " "            
## 9  ( 1 )  " "                                  " "            
## 10  ( 1 ) " "                                  " "            
## 11  ( 1 ) " "                                  " "            
## 12  ( 1 ) " "                                  " "            
## 13  ( 1 ) " "                                  " "            
## 14  ( 1 ) " "                                  " "            
## 15  ( 1 ) " "                                  " "            
## 16  ( 1 ) " "                                  " "            
## 17  ( 1 ) " "                                  " "            
## 18  ( 1 ) " "                                  " "            
## 19  ( 1 ) " "                                  " "            
## 20  ( 1 ) " "                                  " "            
## 21  ( 1 ) " "                                  " "            
## 22  ( 1 ) " "                                  " "            
## 23  ( 1 ) " "                                  " "            
## 24  ( 1 ) " "                                  " "            
## 25  ( 1 ) " "                                  " "            
## 26  ( 1 ) " "                                  " "            
## 27  ( 1 ) " "                                  " "            
##           parentRaceAsian parentRaceNoResp parentMaritalStatusWidowed
## 1  ( 1 )  " "             " "              " "                       
## 2  ( 1 )  " "             " "              " "                       
## 3  ( 1 )  " "             " "              " "                       
## 4  ( 1 )  " "             " "              " "                       
## 5  ( 1 )  " "             " "              " "                       
## 6  ( 1 )  " "             " "              " "                       
## 7  ( 1 )  " "             " "              " "                       
## 8  ( 1 )  " "             " "              " "                       
## 9  ( 1 )  " "             " "              " "                       
## 10  ( 1 ) " "             " "              " "                       
## 11  ( 1 ) " "             " "              " "                       
## 12  ( 1 ) " "             " "              " "                       
## 13  ( 1 ) " "             " "              " "                       
## 14  ( 1 ) " "             " "              " "                       
## 15  ( 1 ) " "             " "              " "                       
## 16  ( 1 ) " "             " "              " "                       
## 17  ( 1 ) " "             " "              " "                       
## 18  ( 1 ) " "             " "              " "                       
## 19  ( 1 ) " "             " "              " "                       
## 20  ( 1 ) " "             " "              " "                       
## 21  ( 1 ) " "             " "              " "                       
## 22  ( 1 ) " "             " "              " "                       
## 23  ( 1 ) " "             " "              " "                       
## 24  ( 1 ) " "             " "              " "                       
## 25  ( 1 ) " "             " "              " "                       
## 26  ( 1 ) " "             " "              " "                       
## 27  ( 1 ) " "             " "              " "                       
##           parentMaritalStatusDivorced parentMaritalStatusSeparated
## 1  ( 1 )  " "                         " "                         
## 2  ( 1 )  " "                         " "                         
## 3  ( 1 )  " "                         " "                         
## 4  ( 1 )  " "                         " "                         
## 5  ( 1 )  " "                         " "                         
## 6  ( 1 )  " "                         " "                         
## 7  ( 1 )  " "                         " "                         
## 8  ( 1 )  " "                         " "                         
## 9  ( 1 )  " "                         " "                         
## 10  ( 1 ) " "                         " "                         
## 11  ( 1 ) " "                         " "                         
## 12  ( 1 ) " "                         " "                         
## 13  ( 1 ) " "                         " "                         
## 14  ( 1 ) " "                         " "                         
## 15  ( 1 ) " "                         " "                         
## 16  ( 1 ) " "                         " "                         
## 17  ( 1 ) " "                         " "                         
## 18  ( 1 ) " "                         " "                         
## 19  ( 1 ) " "                         " "                         
## 20  ( 1 ) " "                         " "                         
## 21  ( 1 ) " "                         " "                         
## 22  ( 1 ) " "                         " "                         
## 23  ( 1 ) " "                         " "                         
## 24  ( 1 ) " "                         " "                         
## 25  ( 1 ) " "                         " "                         
## 26  ( 1 ) " "                         "*"                         
## 27  ( 1 ) " "                         "*"                         
##           parentMaritalStatusRemarried parentMaritalStatusNever married
## 1  ( 1 )  " "                          " "                             
## 2  ( 1 )  " "                          " "                             
## 3  ( 1 )  " "                          " "                             
## 4  ( 1 )  " "                          " "                             
## 5  ( 1 )  " "                          " "                             
## 6  ( 1 )  " "                          " "                             
## 7  ( 1 )  " "                          " "                             
## 8  ( 1 )  " "                          " "                             
## 9  ( 1 )  " "                          " "                             
## 10  ( 1 ) " "                          " "                             
## 11  ( 1 ) " "                          " "                             
## 12  ( 1 ) " "                          " "                             
## 13  ( 1 ) " "                          " "                             
## 14  ( 1 ) " "                          " "                             
## 15  ( 1 ) " "                          " "                             
## 16  ( 1 ) " "                          " "                             
## 17  ( 1 ) " "                          " "                             
## 18  ( 1 ) " "                          " "                             
## 19  ( 1 ) " "                          " "                             
## 20  ( 1 ) " "                          " "                             
## 21  ( 1 ) " "                          " "                             
## 22  ( 1 ) " "                          " "                             
## 23  ( 1 ) " "                          " "                             
## 24  ( 1 ) " "                          " "                             
## 25  ( 1 ) " "                          " "                             
## 26  ( 1 ) " "                          " "                             
## 27  ( 1 ) " "                          " "                             
##           parentSituationCouple parenting with spouse or partner in the same household
## 1  ( 1 )  " "                                                                         
## 2  ( 1 )  " "                                                                         
## 3  ( 1 )  " "                                                                         
## 4  ( 1 )  " "                                                                         
## 5  ( 1 )  " "                                                                         
## 6  ( 1 )  " "                                                                         
## 7  ( 1 )  " "                                                                         
## 8  ( 1 )  " "                                                                         
## 9  ( 1 )  " "                                                                         
## 10  ( 1 ) " "                                                                         
## 11  ( 1 ) " "                                                                         
## 12  ( 1 ) " "                                                                         
## 13  ( 1 ) " "                                                                         
## 14  ( 1 ) " "                                                                         
## 15  ( 1 ) " "                                                                         
## 16  ( 1 ) " "                                                                         
## 17  ( 1 ) " "                                                                         
## 18  ( 1 ) " "                                                                         
## 19  ( 1 ) " "                                                                         
## 20  ( 1 ) " "                                                                         
## 21  ( 1 ) " "                                                                         
## 22  ( 1 ) " "                                                                         
## 23  ( 1 ) " "                                                                         
## 24  ( 1 ) " "                                                                         
## 25  ( 1 ) " "                                                                         
## 26  ( 1 ) " "                                                                         
## 27  ( 1 ) " "                                                                         
##           parentSituationCo-parenting in separate households zipcode75502
## 1  ( 1 )  " "                                                " "         
## 2  ( 1 )  " "                                                " "         
## 3  ( 1 )  " "                                                " "         
## 4  ( 1 )  " "                                                " "         
## 5  ( 1 )  " "                                                " "         
## 6  ( 1 )  " "                                                " "         
## 7  ( 1 )  " "                                                " "         
## 8  ( 1 )  " "                                                " "         
## 9  ( 1 )  " "                                                " "         
## 10  ( 1 ) " "                                                " "         
## 11  ( 1 ) " "                                                " "         
## 12  ( 1 ) " "                                                " "         
## 13  ( 1 ) " "                                                " "         
## 14  ( 1 ) " "                                                " "         
## 15  ( 1 ) " "                                                " "         
## 16  ( 1 ) " "                                                " "         
## 17  ( 1 ) "*"                                                " "         
## 18  ( 1 ) " "                                                " "         
## 19  ( 1 ) " "                                                " "         
## 20  ( 1 ) "*"                                                " "         
## 21  ( 1 ) "*"                                                " "         
## 22  ( 1 ) "*"                                                " "         
## 23  ( 1 ) "*"                                                " "         
## 24  ( 1 ) "*"                                                " "         
## 25  ( 1 ) "*"                                                " "         
## 26  ( 1 ) "*"                                                " "         
## 27  ( 1 ) "*"                                                " "         
##           zipcode90210 zipcode91020 zipcode91204 zipcode91205 zipcode91206
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode91210 zipcode91402 zipcode97003 zipcode97005 zipcode97006
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97007 zipcode97008 zipcode97023 zipcode97027 zipcode97032
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97034 zipcode97035 zipcode97045 zipcode97056 zipcode97060
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97062 zipcode97068 zipcode97071 zipcode97078 zipcode97086
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          "*"          " "         
## 16  ( 1 ) " "          " "          " "          "*"          " "         
## 17  ( 1 ) " "          " "          " "          "*"          " "         
## 18  ( 1 ) " "          " "          " "          "*"          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          "*"          " "         
## 21  ( 1 ) " "          " "          " "          "*"          " "         
## 22  ( 1 ) " "          " "          " "          "*"          " "         
## 23  ( 1 ) " "          " "          " "          "*"          " "         
## 24  ( 1 ) " "          " "          " "          "*"          " "         
## 25  ( 1 ) " "          " "          " "          "*"          " "         
## 26  ( 1 ) " "          " "          " "          "*"          " "         
## 27  ( 1 ) " "          " "          " "          "*"          " "         
##           zipcode97086-3615 zipcode97089 zipcode97101 zipcode97116
## 1  ( 1 )  " "               " "          " "          " "         
## 2  ( 1 )  " "               " "          " "          " "         
## 3  ( 1 )  " "               " "          " "          " "         
## 4  ( 1 )  " "               " "          " "          " "         
## 5  ( 1 )  " "               " "          " "          " "         
## 6  ( 1 )  " "               " "          " "          " "         
## 7  ( 1 )  " "               " "          " "          " "         
## 8  ( 1 )  " "               " "          " "          " "         
## 9  ( 1 )  " "               " "          " "          " "         
## 10  ( 1 ) " "               " "          " "          " "         
## 11  ( 1 ) " "               " "          " "          " "         
## 12  ( 1 ) " "               " "          " "          " "         
## 13  ( 1 ) " "               " "          " "          " "         
## 14  ( 1 ) " "               " "          " "          " "         
## 15  ( 1 ) " "               " "          " "          " "         
## 16  ( 1 ) " "               " "          " "          " "         
## 17  ( 1 ) " "               " "          " "          " "         
## 18  ( 1 ) " "               " "          " "          " "         
## 19  ( 1 ) " "               " "          " "          " "         
## 20  ( 1 ) " "               " "          " "          " "         
## 21  ( 1 ) " "               " "          " "          " "         
## 22  ( 1 ) " "               " "          " "          " "         
## 23  ( 1 ) " "               " "          " "          " "         
## 24  ( 1 ) " "               " "          " "          " "         
## 25  ( 1 ) " "               " "          " "          "*"         
## 26  ( 1 ) " "               " "          " "          "*"         
## 27  ( 1 ) " "               " "          " "          "*"         
##           zipcode97123 zipcode97124 zipcode97140 zipcode97141 zipcode97201
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97202 zipcode97203 zipcode97206 zipcode97209 zipcode97210
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97211 zipcode97212 zipcode97213 zipcode97214 zipcode97215
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) "*"          " "          " "          " "          " "         
##           zipcode97217 zipcode97219 zipcode97220 zipcode97221 zipcode97222
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97223 zipcode97224 zipcode97225 zipcode97227 zipcode97229
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          "*"          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          "*"          " "          " "         
## 8  ( 1 )  " "          " "          "*"          " "          " "         
## 9  ( 1 )  " "          " "          "*"          " "          " "         
## 10  ( 1 ) " "          " "          "*"          " "          " "         
## 11  ( 1 ) " "          " "          "*"          " "          " "         
## 12  ( 1 ) " "          " "          "*"          " "          " "         
## 13  ( 1 ) " "          " "          "*"          " "          " "         
## 14  ( 1 ) " "          " "          "*"          " "          " "         
## 15  ( 1 ) " "          " "          "*"          " "          " "         
## 16  ( 1 ) " "          " "          "*"          " "          " "         
## 17  ( 1 ) " "          " "          "*"          " "          " "         
## 18  ( 1 ) " "          " "          "*"          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          "*"          " "          " "         
## 21  ( 1 ) " "          " "          "*"          " "          " "         
## 22  ( 1 ) " "          " "          "*"          " "          " "         
## 23  ( 1 ) " "          " "          "*"          " "          " "         
## 24  ( 1 ) " "          " "          "*"          " "          " "         
## 25  ( 1 ) " "          " "          "*"          " "          " "         
## 26  ( 1 ) " "          " "          "*"          " "          " "         
## 27  ( 1 ) " "          " "          "*"          " "          " "         
##           zipcode97230 zipcode97232 zipcode97232-2555 zipcode97233
## 1  ( 1 )  " "          " "          " "               " "         
## 2  ( 1 )  " "          " "          " "               " "         
## 3  ( 1 )  " "          " "          " "               " "         
## 4  ( 1 )  " "          " "          " "               " "         
## 5  ( 1 )  " "          " "          " "               " "         
## 6  ( 1 )  " "          " "          " "               " "         
## 7  ( 1 )  " "          " "          " "               " "         
## 8  ( 1 )  " "          " "          " "               " "         
## 9  ( 1 )  " "          " "          " "               " "         
## 10  ( 1 ) " "          " "          " "               " "         
## 11  ( 1 ) " "          " "          " "               " "         
## 12  ( 1 ) " "          " "          " "               " "         
## 13  ( 1 ) " "          " "          " "               " "         
## 14  ( 1 ) " "          " "          " "               " "         
## 15  ( 1 ) " "          " "          " "               " "         
## 16  ( 1 ) " "          " "          " "               " "         
## 17  ( 1 ) " "          " "          " "               " "         
## 18  ( 1 ) " "          " "          " "               " "         
## 19  ( 1 ) " "          " "          " "               " "         
## 20  ( 1 ) " "          " "          " "               " "         
## 21  ( 1 ) " "          " "          " "               " "         
## 22  ( 1 ) " "          " "          " "               " "         
## 23  ( 1 ) " "          " "          " "               " "         
## 24  ( 1 ) " "          " "          " "               " "         
## 25  ( 1 ) " "          " "          " "               " "         
## 26  ( 1 ) " "          " "          " "               " "         
## 27  ( 1 ) " "          " "          " "               " "         
##           zipcode97236 zipcode97239 zipcode97266 zipcode97267 zipcode97321
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          " "         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97325 zipcode97429 zipcode97527 zipcode97701 zipcode97702
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          "*"         
## 6  ( 1 )  " "          " "          " "          " "          "*"         
## 7  ( 1 )  " "          " "          " "          " "          "*"         
## 8  ( 1 )  " "          " "          " "          " "          "*"         
## 9  ( 1 )  " "          " "          " "          " "          "*"         
## 10  ( 1 ) " "          " "          " "          " "          "*"         
## 11  ( 1 ) " "          " "          " "          " "          "*"         
## 12  ( 1 ) " "          " "          " "          " "          "*"         
## 13  ( 1 ) " "          " "          " "          " "          "*"         
## 14  ( 1 ) " "          " "          " "          " "          "*"         
## 15  ( 1 ) " "          " "          " "          " "          "*"         
## 16  ( 1 ) " "          " "          " "          " "          "*"         
## 17  ( 1 ) " "          " "          " "          " "          "*"         
## 18  ( 1 ) " "          " "          " "          " "          "*"         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          "*"         
## 21  ( 1 ) " "          " "          " "          " "          "*"         
## 22  ( 1 ) " "          " "          " "          " "          "*"         
## 23  ( 1 ) " "          " "          " "          " "          "*"         
## 24  ( 1 ) " "          " "          "*"          " "          "*"         
## 25  ( 1 ) " "          " "          "*"          " "          "*"         
## 26  ( 1 ) " "          " "          "*"          " "          "*"         
## 27  ( 1 ) " "          " "          "*"          " "          "*"         
##           zipcode97703 zipcode97707 zipcode97734 zipcode97738 zipcode97741
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          " "          " "          " "         
## 12  ( 1 ) " "          " "          " "          " "          " "         
## 13  ( 1 ) " "          " "          " "          " "          " "         
## 14  ( 1 ) " "          " "          " "          " "          "*"         
## 15  ( 1 ) " "          " "          " "          " "          " "         
## 16  ( 1 ) " "          " "          " "          " "          " "         
## 17  ( 1 ) " "          " "          " "          " "          " "         
## 18  ( 1 ) " "          " "          " "          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          " "          " "          " "         
## 21  ( 1 ) " "          " "          " "          " "          " "         
## 22  ( 1 ) " "          " "          " "          " "          " "         
## 23  ( 1 ) " "          " "          " "          " "          " "         
## 24  ( 1 ) " "          " "          " "          " "          " "         
## 25  ( 1 ) " "          " "          " "          " "          " "         
## 26  ( 1 ) " "          " "          " "          " "          " "         
## 27  ( 1 ) " "          " "          " "          " "          " "         
##           zipcode97753 zipcode97754 zipcode97756 zipcode97757 zipcode97759
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          " "          " "          " "         
## 3  ( 1 )  " "          " "          " "          " "          " "         
## 4  ( 1 )  " "          " "          " "          " "          " "         
## 5  ( 1 )  " "          " "          " "          " "          " "         
## 6  ( 1 )  " "          " "          " "          " "          " "         
## 7  ( 1 )  " "          " "          " "          " "          " "         
## 8  ( 1 )  " "          " "          " "          " "          " "         
## 9  ( 1 )  " "          " "          " "          " "          " "         
## 10  ( 1 ) " "          " "          " "          " "          " "         
## 11  ( 1 ) " "          " "          "*"          " "          " "         
## 12  ( 1 ) " "          " "          "*"          " "          " "         
## 13  ( 1 ) " "          " "          "*"          " "          " "         
## 14  ( 1 ) " "          " "          "*"          " "          " "         
## 15  ( 1 ) " "          " "          "*"          " "          " "         
## 16  ( 1 ) " "          " "          "*"          " "          " "         
## 17  ( 1 ) " "          " "          "*"          " "          " "         
## 18  ( 1 ) " "          " "          "*"          " "          " "         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          "*"          " "          " "         
## 21  ( 1 ) " "          " "          "*"          " "          " "         
## 22  ( 1 ) " "          " "          "*"          " "          " "         
## 23  ( 1 ) " "          " "          "*"          " "          " "         
## 24  ( 1 ) " "          " "          "*"          " "          " "         
## 25  ( 1 ) " "          " "          "*"          " "          " "         
## 26  ( 1 ) " "          " "          "*"          " "          " "         
## 27  ( 1 ) " "          " "          "*"          " "          " "         
##           zipcode97760 zipcode97825 zipcode98632 zipcode98660 zipcode98683
## 1  ( 1 )  " "          " "          " "          " "          " "         
## 2  ( 1 )  " "          " "          "*"          " "          " "         
## 3  ( 1 )  " "          " "          "*"          " "          " "         
## 4  ( 1 )  " "          " "          "*"          " "          " "         
## 5  ( 1 )  " "          " "          "*"          " "          " "         
## 6  ( 1 )  " "          " "          "*"          " "          " "         
## 7  ( 1 )  " "          " "          "*"          " "          " "         
## 8  ( 1 )  " "          " "          "*"          "*"          " "         
## 9  ( 1 )  " "          " "          "*"          "*"          " "         
## 10  ( 1 ) " "          " "          "*"          "*"          " "         
## 11  ( 1 ) " "          " "          "*"          "*"          " "         
## 12  ( 1 ) " "          " "          "*"          "*"          " "         
## 13  ( 1 ) " "          " "          "*"          "*"          " "         
## 14  ( 1 ) " "          " "          "*"          "*"          " "         
## 15  ( 1 ) " "          " "          "*"          "*"          " "         
## 16  ( 1 ) " "          " "          "*"          "*"          " "         
## 17  ( 1 ) " "          " "          "*"          "*"          " "         
## 18  ( 1 ) " "          " "          "*"          "*"          "*"         
## 19  ( 1 ) " "          " "          " "          " "          " "         
## 20  ( 1 ) " "          " "          "*"          "*"          "*"         
## 21  ( 1 ) " "          " "          "*"          "*"          "*"         
## 22  ( 1 ) " "          " "          "*"          "*"          "*"         
## 23  ( 1 ) " "          " "          "*"          "*"          "*"         
## 24  ( 1 ) " "          " "          "*"          "*"          "*"         
## 25  ( 1 ) " "          " "          "*"          "*"          "*"         
## 26  ( 1 ) " "          " "          "*"          "*"          "*"         
## 27  ( 1 ) " "          " "          "*"          "*"          "*"         
##           zipcode98685 communitySuburban communityRural distance
## 1  ( 1 )  " "          " "               " "            " "     
## 2  ( 1 )  " "          " "               " "            " "     
## 3  ( 1 )  " "          " "               " "            " "     
## 4  ( 1 )  " "          " "               " "            " "     
## 5  ( 1 )  " "          " "               " "            " "     
## 6  ( 1 )  " "          " "               " "            " "     
## 7  ( 1 )  " "          " "               " "            " "     
## 8  ( 1 )  " "          " "               " "            " "     
## 9  ( 1 )  " "          " "               " "            " "     
## 10  ( 1 ) " "          " "               " "            " "     
## 11  ( 1 ) " "          " "               " "            " "     
## 12  ( 1 ) " "          " "               " "            " "     
## 13  ( 1 ) " "          " "               " "            " "     
## 14  ( 1 ) " "          " "               " "            " "     
## 15  ( 1 ) " "          " "               " "            " "     
## 16  ( 1 ) " "          " "               " "            " "     
## 17  ( 1 ) " "          " "               " "            " "     
## 18  ( 1 ) " "          " "               " "            " "     
## 19  ( 1 ) " "          " "               " "            " "     
## 20  ( 1 ) " "          " "               " "            " "     
## 21  ( 1 ) " "          " "               " "            " "     
## 22  ( 1 ) " "          " "               " "            "*"     
## 23  ( 1 ) " "          " "               " "            "*"     
## 24  ( 1 ) " "          " "               " "            "*"     
## 25  ( 1 ) " "          " "               " "            "*"     
## 26  ( 1 ) " "          " "               " "            "*"     
## 27  ( 1 ) " "          " "               " "            "*"     
##           parentEducationVocational school/some college
## 1  ( 1 )  " "                                          
## 2  ( 1 )  " "                                          
## 3  ( 1 )  " "                                          
## 4  ( 1 )  " "                                          
## 5  ( 1 )  " "                                          
## 6  ( 1 )  " "                                          
## 7  ( 1 )  " "                                          
## 8  ( 1 )  " "                                          
## 9  ( 1 )  " "                                          
## 10  ( 1 ) " "                                          
## 11  ( 1 ) " "                                          
## 12  ( 1 ) " "                                          
## 13  ( 1 ) " "                                          
## 14  ( 1 ) " "                                          
## 15  ( 1 ) " "                                          
## 16  ( 1 ) " "                                          
## 17  ( 1 ) " "                                          
## 18  ( 1 ) " "                                          
## 19  ( 1 ) " "                                          
## 20  ( 1 ) " "                                          
## 21  ( 1 ) " "                                          
## 22  ( 1 ) " "                                          
## 23  ( 1 ) " "                                          
## 24  ( 1 ) " "                                          
## 25  ( 1 ) " "                                          
## 26  ( 1 ) " "                                          
## 27  ( 1 ) " "                                          
##           parentEducationCollege
## 1  ( 1 )  " "                   
## 2  ( 1 )  " "                   
## 3  ( 1 )  " "                   
## 4  ( 1 )  " "                   
## 5  ( 1 )  " "                   
## 6  ( 1 )  " "                   
## 7  ( 1 )  " "                   
## 8  ( 1 )  " "                   
## 9  ( 1 )  " "                   
## 10  ( 1 ) " "                   
## 11  ( 1 ) " "                   
## 12  ( 1 ) " "                   
## 13  ( 1 ) " "                   
## 14  ( 1 ) " "                   
## 15  ( 1 ) " "                   
## 16  ( 1 ) " "                   
## 17  ( 1 ) " "                   
## 18  ( 1 ) " "                   
## 19  ( 1 ) " "                   
## 20  ( 1 ) " "                   
## 21  ( 1 ) " "                   
## 22  ( 1 ) " "                   
## 23  ( 1 ) " "                   
## 24  ( 1 ) " "                   
## 25  ( 1 ) " "                   
## 26  ( 1 ) " "                   
## 27  ( 1 ) " "                   
##           parentEducationGraduate/professional school
## 1  ( 1 )  " "                                        
## 2  ( 1 )  " "                                        
## 3  ( 1 )  " "                                        
## 4  ( 1 )  " "                                        
## 5  ( 1 )  " "                                        
## 6  ( 1 )  " "                                        
## 7  ( 1 )  " "                                        
## 8  ( 1 )  " "                                        
## 9  ( 1 )  " "                                        
## 10  ( 1 ) " "                                        
## 11  ( 1 ) " "                                        
## 12  ( 1 ) " "                                        
## 13  ( 1 ) " "                                        
## 14  ( 1 ) " "                                        
## 15  ( 1 ) " "                                        
## 16  ( 1 ) " "                                        
## 17  ( 1 ) " "                                        
## 18  ( 1 ) " "                                        
## 19  ( 1 ) " "                                        
## 20  ( 1 ) " "                                        
## 21  ( 1 ) " "                                        
## 22  ( 1 ) " "                                        
## 23  ( 1 ) " "                                        
## 24  ( 1 ) " "                                        
## 25  ( 1 ) " "                                        
## 26  ( 1 ) " "                                        
## 27  ( 1 ) " "                                        
##           income$25,001-$49,999 income$50,000-$79,999
## 1  ( 1 )  " "                   " "                  
## 2  ( 1 )  " "                   " "                  
## 3  ( 1 )  " "                   " "                  
## 4  ( 1 )  " "                   " "                  
## 5  ( 1 )  " "                   " "                  
## 6  ( 1 )  " "                   " "                  
## 7  ( 1 )  " "                   " "                  
## 8  ( 1 )  " "                   " "                  
## 9  ( 1 )  " "                   " "                  
## 10  ( 1 ) " "                   " "                  
## 11  ( 1 ) " "                   " "                  
## 12  ( 1 ) " "                   " "                  
## 13  ( 1 ) " "                   " "                  
## 14  ( 1 ) " "                   " "                  
## 15  ( 1 ) " "                   " "                  
## 16  ( 1 ) "*"                   " "                  
## 17  ( 1 ) "*"                   " "                  
## 18  ( 1 ) "*"                   " "                  
## 19  ( 1 ) " "                   " "                  
## 20  ( 1 ) "*"                   " "                  
## 21  ( 1 ) "*"                   " "                  
## 22  ( 1 ) "*"                   " "                  
## 23  ( 1 ) "*"                   " "                  
## 24  ( 1 ) "*"                   " "                  
## 25  ( 1 ) "*"                   " "                  
## 26  ( 1 ) "*"                   " "                  
## 27  ( 1 ) "*"                   " "                  
##           income$80,000-$119,999 income$120,000-$149,999
## 1  ( 1 )  " "                    " "                    
## 2  ( 1 )  " "                    " "                    
## 3  ( 1 )  " "                    " "                    
## 4  ( 1 )  " "                    " "                    
## 5  ( 1 )  " "                    " "                    
## 6  ( 1 )  " "                    "*"                    
## 7  ( 1 )  " "                    "*"                    
## 8  ( 1 )  " "                    "*"                    
## 9  ( 1 )  " "                    "*"                    
## 10  ( 1 ) " "                    "*"                    
## 11  ( 1 ) " "                    "*"                    
## 12  ( 1 ) " "                    "*"                    
## 13  ( 1 ) " "                    "*"                    
## 14  ( 1 ) " "                    "*"                    
## 15  ( 1 ) " "                    "*"                    
## 16  ( 1 ) " "                    "*"                    
## 17  ( 1 ) " "                    "*"                    
## 18  ( 1 ) " "                    "*"                    
## 19  ( 1 ) " "                    " "                    
## 20  ( 1 ) " "                    "*"                    
## 21  ( 1 ) " "                    "*"                    
## 22  ( 1 ) " "                    "*"                    
## 23  ( 1 ) " "                    "*"                    
## 24  ( 1 ) " "                    "*"                    
## 25  ( 1 ) " "                    "*"                    
## 26  ( 1 ) " "                    "*"                    
## 27  ( 1 ) " "                    "*"                    
##           income$150,000 or more ECBI_intensity_T_score
## 1  ( 1 )  " "                    " "                   
## 2  ( 1 )  " "                    " "                   
## 3  ( 1 )  " "                    " "                   
## 4  ( 1 )  " "                    " "                   
## 5  ( 1 )  " "                    " "                   
## 6  ( 1 )  " "                    " "                   
## 7  ( 1 )  " "                    " "                   
## 8  ( 1 )  " "                    " "                   
## 9  ( 1 )  " "                    " "                   
## 10  ( 1 ) " "                    " "                   
## 11  ( 1 ) " "                    " "                   
## 12  ( 1 ) " "                    " "                   
## 13  ( 1 ) " "                    " "                   
## 14  ( 1 ) " "                    " "                   
## 15  ( 1 ) " "                    " "                   
## 16  ( 1 ) " "                    " "                   
## 17  ( 1 ) " "                    " "                   
## 18  ( 1 ) " "                    " "                   
## 19  ( 1 ) " "                    " "                   
## 20  ( 1 ) " "                    " "                   
## 21  ( 1 ) " "                    " "                   
## 22  ( 1 ) " "                    " "                   
## 23  ( 1 ) " "                    " "                   
## 24  ( 1 ) " "                    " "                   
## 25  ( 1 ) " "                    " "                   
## 26  ( 1 ) " "                    " "                   
## 27  ( 1 ) " "                    " "                   
##           ECBI_intensity_clinical_cutoff ECBI_problem_raw_score
## 1  ( 1 )  " "                            " "                   
## 2  ( 1 )  " "                            " "                   
## 3  ( 1 )  " "                            " "                   
## 4  ( 1 )  " "                            " "                   
## 5  ( 1 )  " "                            " "                   
## 6  ( 1 )  " "                            " "                   
## 7  ( 1 )  " "                            " "                   
## 8  ( 1 )  " "                            " "                   
## 9  ( 1 )  " "                            " "                   
## 10  ( 1 ) " "                            " "                   
## 11  ( 1 ) " "                            " "                   
## 12  ( 1 ) " "                            " "                   
## 13  ( 1 ) " "                            "*"                   
## 14  ( 1 ) " "                            "*"                   
## 15  ( 1 ) " "                            "*"                   
## 16  ( 1 ) " "                            "*"                   
## 17  ( 1 ) " "                            "*"                   
## 18  ( 1 ) " "                            "*"                   
## 19  ( 1 ) " "                            " "                   
## 20  ( 1 ) " "                            "*"                   
## 21  ( 1 ) " "                            "*"                   
## 22  ( 1 ) " "                            "*"                   
## 23  ( 1 ) " "                            "*"                   
## 24  ( 1 ) " "                            "*"                   
## 25  ( 1 ) " "                            "*"                   
## 26  ( 1 ) " "                            "*"                   
## 27  ( 1 ) " "                            "*"                   
##           ECBI_problem_clinical_cutoff ECBI_OPP_Tot ECBI_Inatt_Tot
## 1  ( 1 )  " "                          " "          " "           
## 2  ( 1 )  " "                          " "          " "           
## 3  ( 1 )  " "                          " "          " "           
## 4  ( 1 )  " "                          " "          " "           
## 5  ( 1 )  " "                          " "          " "           
## 6  ( 1 )  " "                          " "          " "           
## 7  ( 1 )  " "                          " "          " "           
## 8  ( 1 )  " "                          " "          " "           
## 9  ( 1 )  " "                          " "          " "           
## 10  ( 1 ) " "                          " "          " "           
## 11  ( 1 ) " "                          " "          " "           
## 12  ( 1 ) " "                          " "          " "           
## 13  ( 1 ) " "                          " "          " "           
## 14  ( 1 ) " "                          " "          " "           
## 15  ( 1 ) " "                          " "          " "           
## 16  ( 1 ) " "                          " "          " "           
## 17  ( 1 ) " "                          " "          " "           
## 18  ( 1 ) " "                          " "          " "           
## 19  ( 1 ) " "                          " "          " "           
## 20  ( 1 ) " "                          " "          " "           
## 21  ( 1 ) " "                          " "          " "           
## 22  ( 1 ) " "                          " "          " "           
## 23  ( 1 ) " "                          "*"          " "           
## 24  ( 1 ) " "                          "*"          " "           
## 25  ( 1 ) " "                          "*"          " "           
## 26  ( 1 ) " "                          "*"          " "           
## 27  ( 1 ) " "                          "*"          " "           
##           ECBI_Cond_Tot MAPS_PP MAPS_PR MAPS_WM MAPS_SP MAPS_HS MAPS_LC
## 1  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 2  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 3  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 4  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 5  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 6  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 7  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 8  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 9  ( 1 )  " "           " "     " "     " "     " "     " "     " "    
## 10  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 11  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 12  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 13  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 14  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 15  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 16  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 17  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 18  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 19  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 20  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 21  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 22  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 23  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 24  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 25  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 26  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
## 27  ( 1 ) " "           " "     " "     " "     " "     " "     " "    
##           MAPS_PC MAPS_POS MAPS_NEG SEPTI_nurturance
## 1  ( 1 )  " "     " "      " "      " "             
## 2  ( 1 )  " "     " "      " "      " "             
## 3  ( 1 )  " "     " "      " "      " "             
## 4  ( 1 )  " "     " "      " "      " "             
## 5  ( 1 )  " "     " "      " "      " "             
## 6  ( 1 )  " "     " "      " "      " "             
## 7  ( 1 )  " "     " "      " "      " "             
## 8  ( 1 )  " "     " "      " "      " "             
## 9  ( 1 )  " "     " "      " "      " "             
## 10  ( 1 ) " "     " "      " "      " "             
## 11  ( 1 ) " "     " "      " "      " "             
## 12  ( 1 ) " "     " "      " "      " "             
## 13  ( 1 ) " "     " "      " "      " "             
## 14  ( 1 ) " "     " "      " "      " "             
## 15  ( 1 ) " "     " "      " "      " "             
## 16  ( 1 ) " "     " "      " "      " "             
## 17  ( 1 ) " "     " "      " "      " "             
## 18  ( 1 ) " "     " "      " "      " "             
## 19  ( 1 ) " "     " "      " "      " "             
## 20  ( 1 ) " "     " "      " "      " "             
## 21  ( 1 ) " "     " "      " "      " "             
## 22  ( 1 ) " "     " "      " "      " "             
## 23  ( 1 ) " "     " "      " "      " "             
## 24  ( 1 ) " "     " "      " "      " "             
## 25  ( 1 ) " "     " "      " "      " "             
## 26  ( 1 ) " "     " "      " "      " "             
## 27  ( 1 ) " "     " "      " "      " "             
##           SEPTI_n_clinical_cutoff SEPTI_discipline SEPTI_d_clinical_cutoff
## 1  ( 1 )  " "                     " "              " "                    
## 2  ( 1 )  " "                     " "              " "                    
## 3  ( 1 )  " "                     " "              " "                    
## 4  ( 1 )  " "                     " "              " "                    
## 5  ( 1 )  " "                     " "              " "                    
## 6  ( 1 )  " "                     " "              " "                    
## 7  ( 1 )  " "                     " "              " "                    
## 8  ( 1 )  " "                     " "              " "                    
## 9  ( 1 )  " "                     " "              " "                    
## 10  ( 1 ) " "                     " "              " "                    
## 11  ( 1 ) " "                     " "              " "                    
## 12  ( 1 ) " "                     " "              " "                    
## 13  ( 1 ) " "                     " "              " "                    
## 14  ( 1 ) " "                     " "              " "                    
## 15  ( 1 ) " "                     " "              " "                    
## 16  ( 1 ) " "                     " "              " "                    
## 17  ( 1 ) " "                     " "              " "                    
## 18  ( 1 ) " "                     " "              " "                    
## 19  ( 1 ) " "                     " "              " "                    
## 20  ( 1 ) " "                     " "              " "                    
## 21  ( 1 ) " "                     " "              " "                    
## 22  ( 1 ) " "                     " "              " "                    
## 23  ( 1 ) " "                     " "              " "                    
## 24  ( 1 ) " "                     " "              " "                    
## 25  ( 1 ) " "                     " "              " "                    
## 26  ( 1 ) " "                     " "              " "                    
## 27  ( 1 ) " "                     " "              " "                    
##           SEPTI_play SEPTI_p_clinical_cutoff SEPTI_routine
## 1  ( 1 )  " "        " "                     " "          
## 2  ( 1 )  " "        " "                     " "          
## 3  ( 1 )  " "        " "                     " "          
## 4  ( 1 )  " "        " "                     " "          
## 5  ( 1 )  " "        " "                     " "          
## 6  ( 1 )  " "        " "                     " "          
## 7  ( 1 )  " "        " "                     " "          
## 8  ( 1 )  " "        " "                     " "          
## 9  ( 1 )  " "        " "                     " "          
## 10  ( 1 ) " "        " "                     " "          
## 11  ( 1 ) " "        " "                     " "          
## 12  ( 1 ) " "        " "                     " "          
## 13  ( 1 ) " "        " "                     " "          
## 14  ( 1 ) " "        " "                     " "          
## 15  ( 1 ) "*"        " "                     " "          
## 16  ( 1 ) "*"        " "                     " "          
## 17  ( 1 ) "*"        " "                     " "          
## 18  ( 1 ) "*"        " "                     " "          
## 19  ( 1 ) " "        " "                     " "          
## 20  ( 1 ) "*"        " "                     "*"          
## 21  ( 1 ) "*"        " "                     "*"          
## 22  ( 1 ) "*"        " "                     "*"          
## 23  ( 1 ) "*"        " "                     "*"          
## 24  ( 1 ) "*"        " "                     "*"          
## 25  ( 1 ) "*"        " "                     "*"          
## 26  ( 1 ) "*"        " "                     "*"          
## 27  ( 1 ) "*"        " "                     "*"          
##           SEPTI_r_clinical_cutoff SEPTI_total SEPTI_total_clin_cutoff
## 1  ( 1 )  " "                     " "         " "                    
## 2  ( 1 )  " "                     " "         " "                    
## 3  ( 1 )  " "                     "*"         " "                    
## 4  ( 1 )  "*"                     " "         " "                    
## 5  ( 1 )  "*"                     " "         " "                    
## 6  ( 1 )  "*"                     " "         " "                    
## 7  ( 1 )  "*"                     " "         " "                    
## 8  ( 1 )  "*"                     " "         " "                    
## 9  ( 1 )  "*"                     " "         " "                    
## 10  ( 1 ) "*"                     " "         " "                    
## 11  ( 1 ) "*"                     " "         " "                    
## 12  ( 1 ) "*"                     " "         " "                    
## 13  ( 1 ) "*"                     " "         " "                    
## 14  ( 1 ) "*"                     " "         " "                    
## 15  ( 1 ) "*"                     " "         " "                    
## 16  ( 1 ) "*"                     " "         " "                    
## 17  ( 1 ) "*"                     " "         " "                    
## 18  ( 1 ) "*"                     " "         " "                    
## 19  ( 1 ) " "                     " "         " "                    
## 20  ( 1 ) "*"                     " "         " "                    
## 21  ( 1 ) "*"                     " "         " "                    
## 22  ( 1 ) "*"                     " "         " "                    
## 23  ( 1 ) "*"                     " "         " "                    
## 24  ( 1 ) "*"                     " "         " "                    
## 25  ( 1 ) "*"                     " "         " "                    
## 26  ( 1 ) "*"                     " "         " "                    
## 27  ( 1 ) "*"                     " "         " "
```

![plot of chunk Y1Training-finalModel](figures/Y1Training-finalModel-1.png)

```
## Warning in mean.default(y, rm.na = TRUE): argument is not numeric or
## logical: returning NA
```

```
## Error in model.frame.default(formula = y ~ x, na.action = na.omit, drop.unused.levels = TRUE): invalid type (list) for variable 'y'
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
## 17.96794225  0.01183806 14.41780385
```

```
##            Y1       hat
## Y1  1.0000000 0.1088029
## hat 0.1088029 1.0000000
```

![plot of chunk Y1Validation-predict](figures/Y1Validation-predict-1.png)



