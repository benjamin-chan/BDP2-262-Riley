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
method <- "bagEarthGCV"
modelLookup(method) %>% kable()
```



|model       |parameter |label          |forReg |forClass |probModel |
|:-----------|:---------|:--------------|:------|:--------|:---------|
|bagEarthGCV |degree    |Product Degree |TRUE   |TRUE     |TRUE      |

```r
grid <- expand.grid(degree = seq(3))
grid %>% kable()
```



| degree|
|------:|
|      1|
|      2|
|      3|



# Model PCB1


## PCB1 Total

Prediction model for `PCB1`.

Train model over the tuning parameters.


```
## Bagged MARS using gCV Pruning 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 261, 263, 263, 261, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   degree  RMSE          Rsquared    MAE         
##   1       1.821749e+01  0.06013124  1.430473e+01
##   2       1.309577e+13  0.05276993  2.390950e+12
##   3       2.482500e+12  0.05203416  4.532125e+11
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was degree = 1.
```

```
## Error in FUN(X[[i]], ...): object 'nprune' not found
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)

![plot of chunk PCB1_Total_Training-varImp](figures/PCB1_Total_Training-varImp-1.png)

|variable                                    |     Overall|
|:-------------------------------------------|-----------:|
|zipcode97702                                | 100.0000000|
|ECBI_Opp                                    |  95.1423362|
|MAPS_WM                                     |  92.4490111|
|MAPS_HS                                     |  89.4297151|
|MAPS_POS                                    |  87.1489061|
|ECBI_intensity_clinical_cutoff              |  85.1863429|
|MAPS_LC                                     |  83.1627467|
|MAPS_SP                                     |  82.0550661|
|parentAge                                   |  79.7473137|
|MAPS_PR                                     |  78.8376960|
|zipcode97008                                |  76.7331070|
|SEPTI_discipline                            |  74.3887637|
|ECBI_problem_T_score                        |  72.4667590|
|MAPS_PP                                     |  70.9275620|
|zipcode97267                                |  69.4107696|
|childAge                                    |  68.2812084|
|SEPTI_total                                 |  67.3097773|
|totalChildren                               |  65.9981372|
|parentMaritalStatusWidowed                  |  64.9578470|
|distance                                    |  64.2898984|
|SEPTI_play                                  |  63.1540406|
|SEPTI_routine                               |  62.0105772|
|SEPTI_r_clinical_cutoff                     |  61.4179495|
|zipcode97213                                |  60.9031193|
|parentMaritalStatusDivorced                 |  59.4652257|
|zipcode97034                                |  58.3724419|
|parentRaceWhite1                            |  57.3063930|
|zipcode97701                                |  56.1720885|
|childRelationshipBiologicaloradoptivefather |  55.5863526|
|MAPS_PC                                     |  54.8113188|
|childRaceAsian1                             |  52.4017507|
|parentRaceAsian1                            |  51.6165790|
|parentEducationVocationalschool/somecollege |  50.1993797|
|income$25,001-$49,999                       |  47.9269638|
|parentMaritalStatusSeparated                |  46.6740546|
|zipcode97217                                |  45.4044035|
|ECBI_Inatt                                  |  42.1588746|
|zipcode97209                                |  41.8974155|
|zipcode97321                                |  37.9988214|
|income$150,000ormore                        |  37.2586678|
|zipcode97123                                |  35.4440682|
|zipcode97007                                |  32.3387929|
|communityRural                              |  29.5192926|
|ECBI_Cond                                   |  27.8254979|
|SEPTI_nurturance                            |  24.4732610|
|ECBI_intensity_T_score                      |  23.1568006|
|zipcode97741                                |  20.3365841|
|income$120,000-$149,999                     |  16.8509702|
|zipcode91204                                |  13.4967078|
|zipcode97325                                |  10.2749457|
|zipcode97202                                |  10.9584923|
|parentGenderPrefernottorespond              |   7.1701510|
|birthOrderOldest                            |   5.3182053|
|birthOrderMiddle                            |   4.6201480|
|birthOrderYoungest                          |   2.6401363|
|childSexMale                                |   2.8809568|
|childEthnicityNotHispanic/Latino            |   1.6331270|
|childEthnicityUnknown                       |   1.0338433|
|childEthnicityPrefernottorespond            |   0.1082749|




```
##      RMSE  Rsquared       MAE 
## 8.2604775 0.7443193 6.3972102
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.6004739
## hat      0.6004739 1.0000000
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
## 21.10605401  0.04110692 16.48863797
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.2027484
## hat         0.2027484 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Bagged MARS using gCV Pruning 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 261, 262, 262, 263, 261, 262, ... 
## Resampling results across tuning parameters:
## 
##   degree  RMSE          Rsquared    MAE         
##   1       5.203604e+00  0.04784954  4.011785e+00
##   2       5.749949e+12  0.05354628  1.159846e+12
##   3       2.571461e+13  0.04490828  6.047834e+12
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was degree = 1.
```

```
## Error in FUN(X[[i]], ...): object 'nprune' not found
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)

![plot of chunk PCB2_Total_Training-varImp](figures/PCB2_Total_Training-varImp-1.png)

|variable                                        |     Overall|
|:-----------------------------------------------|-----------:|
|zipcode97210                                    | 100.0000000|
|zipcode97702                                    |  94.2770055|
|zipcode97123                                    |  90.0791049|
|MAPS_POS                                        |  86.4804346|
|MAPS_HS                                         |  83.4947988|
|ECBI_intensity_T_score                          |  80.7756726|
|MAPS_LC                                         |  78.8423767|
|ECBI_Cond                                       |  76.7020680|
|SEPTI_nurturance                                |  75.0327444|
|SEPTI_play                                      |  72.2944827|
|SEPTI_discipline                                |  70.0485301|
|SEPTI_total                                     |  67.7753444|
|SEPTI_routine                                   |  65.1535846|
|zipcodeClass2                                   |  63.5829490|
|parentEthnicityNotHispanic/Latino               |  61.5363124|
|parentMaritalStatusDivorced                     |  60.6728621|
|childRelationshipGrandparent                    |  59.8079635|
|ECBI_problem_T_score                            |  58.9293405|
|MAPS_PC                                         |  58.0230895|
|parentAge                                       |  57.2415328|
|zipcode97219                                    |  56.8178257|
|parentGenderTransgender                         |  55.6132741|
|parentEthnicityPrefernottorespond               |  54.7559882|
|parentEducationCollege                          |  53.6997873|
|totalChildren                                   |  52.2738312|
|childRaceNoResp1                                |  51.3895271|
|distance                                        |  50.5564658|
|zipcode97051                                    |  49.7238935|
|parentsNumber                                   |  48.7170190|
|zipcode98683                                    |  47.4458389|
|ECBI_Inatt                                      |  46.3317957|
|MAPS_PP                                         |  45.2684518|
|income$120,000-$149,999                         |  44.0542834|
|MAPS_SP                                         |  42.8167100|
|zipcode97202                                    |  41.5936568|
|zipcode97760                                    |  39.9734729|
|childRelationshipOther                          |  37.8928306|
|zipcode97223                                    |  37.0629124|
|zipcode97214                                    |  35.6678819|
|zipcode97006                                    |  33.4299173|
|zipcode97089                                    |  31.4163919|
|MAPS_PR                                         |  29.3262442|
|childAge                                        |  28.4863545|
|zipcode97221                                    |  24.3200830|
|zipcode97321                                    |  23.8481316|
|parentSituationCo-parentinginseparatehouseholds |  22.0287152|
|zipcode97023                                    |  19.3600558|
|ECBI_Opp                                        |  17.0328955|
|zipcode97224                                    |  12.6819585|
|zipcode97008                                    |  12.2500076|
|income$50,000-$79,999                           |  11.8281168|
|communitySuburban                               |   9.0349903|
|zipcode97741                                    |   6.6044786|
|parentMaritalStatusSeparated                    |   4.4790082|
|zipcode97034                                    |   3.9249143|
|parentSexMale                                   |   3.8487219|
|birthOrderOldest                                |   1.8346305|
|birthOrderMiddle                                |   2.3619344|
|birthOrderYoungest                              |   1.3983158|
|childSexMale                                    |   0.6393080|
|childEthnicityNotHispanic/Latino                |   0.3877540|
|childEthnicityUnknown                           |   0.1531885|




```
##     RMSE Rsquared      MAE 
## 2.438999 0.704847 1.823458
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.8395517
## hat      0.8395517 1.0000000
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
## 6.13500929 0.01165006 4.32610263
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.1079355
## hat      0.1079355 1.0000000
```

![plot of chunk PCB2_Tot_Validation-predict](figures/PCB2_Tot_Validation-predict-1.png)



# Model PCB3


## Total PCB3

Prediction model for `PCB3_Total`.

Train model over the tuning parameters.


```
## Bagged MARS using gCV Pruning 
## 
## 293 samples
##  52 predictor
## 
## No pre-processing
## Resampling: Cross-Validated (10 fold, repeated 20 times) 
## Summary of sample sizes: 262, 263, 260, 262, 261, 261, ... 
## Resampling results across tuning parameters:
## 
##   degree  RMSE          Rsquared    MAE         
##   1       1.377037e+01  0.05950812  1.093594e+01
##   2       1.635159e+13  0.06762401  3.065754e+12
##   3       3.425513e+13  0.05969303  8.591612e+12
## 
## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was degree = 1.
```

```
## Error in FUN(X[[i]], ...): object 'nprune' not found
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)

![plot of chunk PCB3_Total_Training-varImp](figures/PCB3_Total_Training-varImp-1.png)

|variable                                    |     Overall|
|:-------------------------------------------|-----------:|
|MAPS_LC                                     | 100.0000000|
|SEPTI_discipline                            |  94.7698039|
|childAge                                    |  90.3350188|
|ECBI_Inatt                                  |  87.3059386|
|ECBI_Opp                                    |  85.1910836|
|SEPTI_routine                               |  82.5497646|
|MAPS_PR                                     |  80.1544259|
|zipcode97202                                |  78.4746759|
|SEPTI_total                                 |  76.0143511|
|MAPS_PP                                     |  74.4211925|
|MAPS_POS                                    |  72.7445423|
|ECBI_intensity_T_score                      |  68.6770592|
|ECBI_Cond                                   |  66.8087703|
|MAPS_NEG                                    |  66.4242894|
|zipcode97266                                |  65.1194527|
|parentAge                                   |  64.5093317|
|zipcode97209                                |  63.4821848|
|parentEthnicityNotHispanic/Latino           |  62.6936089|
|zipcode97201                                |  62.2175955|
|zipcode97703                                |  61.2644158|
|distance                                    |  59.8924751|
|communitySuburban                           |  58.7696829|
|parentChildRatio                            |  58.0976540|
|parentRaceAsian1                            |  57.3629138|
|income$80,000-$119,999                      |  56.5102117|
|zipcode97003                                |  55.6086620|
|zipcode91204                                |  54.6050507|
|ECBI_problem_T_score                        |  53.3552243|
|zipcode97233                                |  51.9360304|
|zipcode97203                                |  51.3454445|
|parentEducationCollege                      |  49.5358292|
|zipcode98660                                |  48.3502390|
|SEPTI_nurturance                            |  45.8499052|
|zipcode97232                                |  44.6735622|
|zipcode97123                                |  43.5845863|
|zipcode97325                                |  43.0615160|
|zipcode97219                                |  41.1219460|
|MAPS_WM                                     |  41.0191994|
|parentMaritalStatusDivorced                 |  38.2216714|
|zipcode91205                                |  37.0512783|
|SEPTI_play                                  |  35.1243533|
|SEPTI_r_clinical_cutoff                     |  32.6905957|
|ECBI_intensity_clinical_cutoff              |  29.0039060|
|zipcode97008                                |  28.4338639|
|zipcode97213                                |  24.5179857|
|zipcode97741                                |  23.8154752|
|zipcode97825                                |  22.0631724|
|zipcode97734                                |  17.6372818|
|zipcode97760                                |  16.1195880|
|childRelationshipGrandparent                |  14.0174338|
|zipcode97321                                |   9.8484310|
|income$50,000-$79,999                       |   8.1574550|
|totalChildren                               |   6.6001494|
|birthOrderOldest                            |   3.4549929|
|birthOrderMiddle                            |   2.6835196|
|birthOrderYoungest                          |   1.7058454|
|childSexMale                                |   1.2787802|
|childEthnicityNotHispanic/Latino            |   1.0535724|
|childEthnicityUnknown                       |   0.6330885|
|childEthnicityPrefernottorespond            |   0.5533964|
|childRelationshipBiologicaloradoptivefather |   0.0876785|




```
##      RMSE  Rsquared       MAE 
## 6.1983649 0.7443709 4.8424723
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.4498716
## hat      0.4498716 1.0000000
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
##        RMSE    Rsquared         MAE 
## 15.01872645  0.02567384 11.48049500
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.1602306
## hat         0.1602306 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



