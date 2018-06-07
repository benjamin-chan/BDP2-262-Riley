---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-06"
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





Output to [CSV file](../data/processed/dataframe.csv).



Build analysis data set.
Exclude if missing any dependent variable, `Y1`, `Y2`, `Y3`.

![figures/flowChart.png](figures/flowChart.png)







# Model 1

Prediction model for `Y1`.


## Data preprocessing

Split data set into 60:40 training:validation samples.



Preprocess the training sample.

1. Exclude near-zero variance predictors
2. Center variables
3. Scale variables
4. Impute missing values using k-nearest neighbor


```
## Number of complete cases before imputation = 247
```

```
## Created from 247 samples and 63 variables
## 
## Pre-processing:
##   - centered (30)
##   - ignored (31)
##   - 5 nearest neighbor imputation (30)
##   - removed (2)
##   - scaled (30)
```

```
## Number of complete cases after imputation = 274
```

## Training

Set the control parameters.



Set the model and tuning parameter grid.


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

Train model over the tuning parameters.


```
## Random Forest 
## 
## 274 samples
##  61 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 25 times) 
## Summary of sample sizes: 247, 246, 247, 247, 247, 246, ... 
## Resampling results across tuning parameters:
## 
##   mtry  RMSE      Rsquared   MAE     
##    5    16.64326  0.1430733  13.47938
##    6    16.61381  0.1433864  13.44687
##    7    16.62315  0.1401251  13.45028
##    8    16.61360  0.1391500  13.43144
##    9    16.63913  0.1359562  13.45766
##   10    16.63912  0.1350297  13.45652
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was mtry = 8.
```

```
## Saving 7 x 7 in image
## Saving 7 x 7 in image
```

![figures/trainingModelY1.png](figures/trainingModelY1.png)


```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry, importance = TRUE,      nthreads = 8) 
##                Type of random forest: regression
##                      Number of trees: 500
## No. of variables tried at each split: 8
## 
##           Mean of squared residuals: 287.1884
##                     % Var explained: 7.3
```

```
## rf variable importance
## 
##   only 20 most important variables shown (out of 173)
## 
##                                             Overall
## childRaceWhite                               100.00
## parentRaceWhite                               96.75
## childAgeDichotomous3 or older                 87.49
## MAPS_POS                                      76.70
## parentEthnicityNot Hispanic/Latino            71.39
## MAPS_PR                                       70.66
## SEPTI_total                                   69.45
## MAPS_SP                                       68.82
## childRaceAsian                                66.56
## MAPS_LC                                       66.54
## parentEducationGraduate/professional school   64.44
## SEPTI_r_clinical_cutoff                       63.65
## SEPTI_routine                                 63.42
## SEPTI_d_clinical_cutoff                       61.59
## parentRaceAsian                               59.32
## zipcode97008                                  59.04
## zipcode97225                                  59.00
## MAPS_WM                                       58.06
## zipcode97741                                  57.85
## SEPTI_n_clinical_cutoff                       57.56
```

```
##            Y1       hat
## Y1  1.0000000 0.9730155
## hat 0.9730155 1.0000000
```

![plot of chunk trainingModelY1-predict](figures/trainingModelY1-predict-1.png)



