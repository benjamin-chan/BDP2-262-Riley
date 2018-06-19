---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-06-19"
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
p <- 0.80
```

Split data set into 80:20 training:validation samples.


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
## Number of complete cases before imputation = 277
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
|languageSurvey  |  51.16667|     0.6389776|FALSE   |TRUE |
|childRaceAfrAm  |  25.00000|     0.6389776|FALSE   |TRUE |
|childRaceAIAN   |  33.66667|     0.6389776|FALSE   |TRUE |
|childRaceNHPI   |  43.57143|     0.6389776|FALSE   |TRUE |
|parentRaceAfrAm |  51.00000|     0.6389776|FALSE   |TRUE |
|parentRaceAIAN  |  38.00000|     0.6389776|FALSE   |TRUE |
|parentRaceNHPI  |  43.57143|     0.6389776|FALSE   |TRUE |
|parentRaceOther |  21.28571|     0.6389776|FALSE   |TRUE |
|internet        |  30.30000|     0.6389776|FALSE   |TRUE |

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
## Created from 277 samples and 55 variables
## 
## Pre-processing:
##   - centered (32)
##   - ignored (21)
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
## Number of complete cases after imputation = 309
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
## 313 samples
##  53 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 308, 308, 308, 308, 308, 308, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE      Rsquared     MAE     
##    2      1       15.92454  0.067032969  12.57080
##    2      2       15.98261  0.061142989  12.60581
##    2      3       16.60590  0.005985256  13.32830
##    2      4       16.27955  0.032994846  12.92910
##    2      5       16.14593  0.044617626  12.76228
##    3      1       16.22772  0.043434974  12.90386
##    3      2       16.72240  0.020324889  13.37143
##    3      3       16.16350  0.051675404  12.88117
##    3      4       16.40858  0.033663528  12.91014
##    3      5       16.20376  0.048328344  12.81658
##    4      1       15.93517  0.077326006  12.69682
##    4      2       17.34232  0.012069759  13.61665
##    4      3       16.29459  0.052206511  12.95805
##    4      4       16.39269  0.051087908  13.00684
##    4      5       16.52616  0.041142819  13.16052
##    5      1       16.22527  0.058623264  12.78749
##    5      2       17.47888  0.014710132  13.61606
##    5      3       16.26854  0.066063031  12.86387
##    5      4       16.28360  0.068004343  12.78995
##    5      5       16.44680  0.058925808  12.91775
##    6      1       16.20984  0.061938939  12.75561
##    6      2       17.58815  0.013036231  13.66124
##    6      3       16.27076  0.073506275  12.83615
##    6      4       16.38123  0.067936697  12.91430
##    6      5       16.45692  0.063394152  12.97206
##    7      1       16.27937  0.055851572  12.93318
##    7      2       17.69850  0.010541366  13.82404
##    7      3       16.36701  0.073601367  12.89371
##    7      4       16.46731  0.067794504  12.88343
##    7      5       16.60302  0.065619287  13.01537
##    8      1       16.35725  0.059111881  12.99098
##    8      2       17.97157  0.007325150  14.04395
##    8      3       15.97962  0.103859773  12.54691
##    8      4       16.72423  0.059812029  13.11586
##    8      5       16.61063  0.074707619  12.95977
##    9      1       16.45512  0.058751735  13.03884
##    9      2       17.87752  0.013210542  14.10384
##    9      3       16.28512  0.087609826  12.71058
##    9      4       16.84538  0.058749075  13.26841
##    9      5       16.84138  0.068921643  13.06360
##   10      1       16.49050  0.054281687  13.06064
##   10      2       18.28572  0.006084533  14.32249
##   10      3       21.08677  0.024426272  13.54579
##   10      4       17.22752  0.055227234  13.35687
##   10      5       17.01691  0.066771949  13.19732
##   20      1       16.94695  0.050531558  13.34467
##   20      2       20.37148  0.005000100  14.96142
##   20      3       24.93887  0.008710402  15.70629
##   20      4       18.47468  0.054510349  14.20702
##   20      5       19.08868  0.041620062  14.29436
##   30      1       17.13939  0.050877046  13.42179
##   30      2       21.82702  0.007297141  15.95886
##   30      3       24.94432  0.015777705  16.74826
##   30      4       19.23653  0.058563203  14.59940
##   30      5       19.79548  0.046854881  15.34046
##   40      1       17.14524  0.051032381  13.42997
##   40      2       22.10216  0.008112406  16.08216
##   40      3       25.41509  0.015539509  17.37367
##   40      4       20.64084  0.052171121  15.34168
##   40      5       20.90740  0.040092914  16.09541
##   50      1       17.21433  0.047869323  13.45636
##   50      2       22.16303  0.008480110  16.09318
##   50      3       25.57217  0.016734570  17.58460
##   50      4       22.27896  0.030227127  16.24107
##   50      5       21.04516  0.052501191  16.09417
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 2 and degree = 1.
```

![plot of chunk PCB1_Total_Training](figures/PCB1_Total_Training-1.png)


```
## Selected 2 of 125 terms, and 1 of 160 predictors
## Termination condition: Reached nk 201
## Importance: childRaceWhite1, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 253.6025    RSS 76848.95    GRSq 0.07198711    RSq 0.0840001
```

```
## Call: earth(x=matrix[309,160], y=c(73,77,76,65,3...), keepxy=TRUE,
##             degree=1, nprune=2)
## 
##                 coefficients
## (Intercept)         75.76316
## childRaceWhite1    -11.08934
## 
## Selected 2 of 125 terms, and 1 of 160 predictors
## Termination condition: Reached nk 201
## Importance: childRaceWhite1, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 1 (additive model)
## GCV 253.6025    RSS 76848.95    GRSq 0.07198711    RSq 0.0840001
```

![plot of chunk PCB1_Total_Training-finalModel](figures/PCB1_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 160)
## 
##                                Overall
## childRaceWhite1                    100
## zipcode98632                         0
## zipcode98685                         0
## zipcode98660                         0
## zipcode97760                         0
## parentGenderPrefernottorespond       0
## childSexMale                         0
## zipcode91020                         0
## zipcode97211                         0
## SEPTI_p_clinical_cutoff              0
## childAge                             0
## zipcode97825                         0
## zipcode97233                         0
## zipcode97757                         0
## zipcode97236                         0
## zipcode97140                         0
## zipcode97035                         0
## SEPTI_r_clinical_cutoff              0
## totalChildren                        0
## zipcode97056                         0
```


```
##        RMSE    Rsquared         MAE 
## 15.73554153  0.08274256 12.40064886
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.1524043
## hat      0.1524043 1.0000000
```

![plot of chunk PCB1_Total_Training-predict](figures/PCB1_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##        RMSE    Rsquared         MAE 
## 16.96490359  0.01250969 14.15213131
```

```
##            PCB1_Total       hat
## PCB1_Total  1.0000000 0.1118467
## hat         0.1118467 1.0000000
```

![plot of chunk PCB1_Total_Validation-predict](figures/PCB1_Total_Validation-predict-1.png)



# Model PCB2


## Total PCB2

Prediction model for `PCB2_Total`.

Train model over the tuning parameters.


```
## Multivariate Adaptive Regression Spline 
## 
## 313 samples
##  53 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 308, 308, 308, 308, 308, 308, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE       Rsquared      MAE     
##    2      1        4.541548  1.396504e-02  3.426615
##    2      2        4.637935  8.452845e-04  3.519539
##    2      3        4.750177  4.781843e-04  3.529885
##    2      4        4.562875  1.240557e-02  3.451474
##    2      5        4.588554  6.681589e-03  3.466323
##    3      1        4.532558  2.361673e-02  3.365478
##    3      2        4.710308  1.992027e-04  3.554124
##    3      3        4.992101  1.447914e-04  3.678783
##    3      4        4.704550  2.622016e-03  3.540420
##    3      5        4.701059  4.114792e-03  3.532774
##    4      1        4.606159  1.489942e-02  3.448684
##    4      2        4.800496  4.285049e-05  3.635268
##    4      3        5.103694  1.016126e-03  3.672405
##    4      4        4.715807  7.826099e-03  3.531888
##    4      5        4.725192  5.400989e-03  3.530732
##    5      1        4.623701  1.721193e-02  3.457980
##    5      2        4.821411  2.759087e-03  3.618525
##    5      3        5.204580  1.669632e-03  3.734422
##    5      4        4.874476  3.709290e-03  3.663735
##    5      5        4.918105  1.533043e-03  3.673539
##    6      1        4.669942  1.344937e-02  3.465731
##    6      2        4.808147  8.873673e-03  3.604688
##    6      3        5.271222  1.285406e-03  3.826329
##    6      4        5.139545  3.155278e-03  3.762903
##    6      5        5.222027  7.609215e-04  3.808545
##    7      1        4.703869  1.314780e-02  3.505094
##    7      2        4.947454  3.211666e-03  3.680416
##    7      3        5.292187  1.634157e-03  3.806235
##    7      4        5.316946  1.079626e-04  3.829426
##    7      5        5.382165  1.283387e-03  3.886538
##    8      1        4.720125  1.249062e-02  3.534380
##    8      2        5.071139  2.651665e-03  3.776318
##    8      3        5.346644  1.977755e-03  3.807814
##    8      4        5.418488  2.498601e-04  3.898916
##    8      5        5.480134  1.768147e-03  3.946997
##    9      1        4.841929  4.003909e-03  3.629280
##    9      2        8.740583  4.059007e-03  4.156616
##    9      3        9.174076  2.462897e-03  4.292693
##    9      4        5.500612  7.753725e-04  3.948766
##    9      5        5.460352  7.498433e-04  3.911295
##   10      1        4.840991  4.126671e-03  3.642904
##   10      2        8.829655  4.648527e-03  4.181106
##   10      3        9.255737  2.721047e-03  4.321060
##   10      4        9.208065  1.431053e-03  4.366942
##   10      5        9.184084  1.130391e-03  4.323448
##   20      1        5.231573  1.235985e-05  3.951361
##   20      2       10.157052  8.050955e-03  4.654752
##   20      3        9.338299  4.796533e-03  4.640762
##   20      4        9.435887  2.880728e-03  4.615030
##   20      5        9.519402  2.572026e-03  4.623567
##   30      1        5.322654  7.672353e-05  4.036974
##   30      2       10.988753  8.628361e-03  4.969097
##   30      3        9.199658  4.307881e-03  4.911792
##   30      4        9.433274  4.621801e-03  4.913158
##   30      5        8.952169  2.290344e-03  4.919107
##   40      1        5.318651  1.039074e-04  4.037430
##   40      2       10.972254  9.666619e-03  4.997250
##   40      3        9.311729  4.229222e-03  4.997687
##   40      4        9.062478  3.932921e-03  5.062360
##   40      5        9.115903  3.296651e-03  5.157283
##   50      1        5.318651  1.039074e-04  4.037430
##   50      2       10.985409  9.910723e-03  5.020748
##   50      3        9.380144  5.476386e-03  5.098890
##   50      4        9.463634  2.647927e-03  5.328032
##   50      5        9.398406  1.108209e-03  5.397391
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 3 and degree = 1.
```

![plot of chunk PCB2_Tot_Training](figures/PCB2_Tot_Training-1.png)


```
## Selected 3 of 125 terms, and 2 of 160 predictors
## Termination condition: Reached nk 201
## Importance: zipcode97702, MAPS_POS, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 2 (additive model)
## GCV 19.60483    RSS 5863.43    GRSq 0.058535    RSq 0.08282984
```

```
## Call: earth(x=matrix[309,160], y=c(25,29,25,24,2...), keepxy=TRUE,
##             degree=1, nprune=3)
## 
##                      coefficients
## (Intercept)             24.308053
## zipcode97702            -5.103619
## h(MAPS_POS-0.540427)     3.469822
## 
## Selected 3 of 125 terms, and 2 of 160 predictors
## Termination condition: Reached nk 201
## Importance: zipcode97702, MAPS_POS, totalChildren-unused, ...
## Number of terms at each degree of interaction: 1 2 (additive model)
## GCV 19.60483    RSS 5863.43    GRSq 0.058535    RSq 0.08282984
```

![plot of chunk PCB2_Tot_Training-finalModel](figures/PCB2_Tot_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 160)
## 
##                                   Overall
## zipcode97702                       100.00
## MAPS_POS                            58.98
## totalChildren                        0.00
## zipcode97760                         0.00
## childRelationshipStepparent          0.00
## zipcode97738                         0.00
## income$150,000ormore                 0.00
## zipcode97734                         0.00
## SEPTI_total                          0.00
## zipcode97703                         0.00
## ECBI_intensity_T_score               0.00
## zipcode91020                         0.00
## MAPS_WM                              0.00
## zipcode97213                         0.00
## zipcode97032                         0.00
## zipcode97068                         0.00
## MAPS_NEG                             0.00
## parentEthnicityPrefernottorespond    0.00
## SEPTI_discipline                     0.00
## zipcode97089                         0.00
```


```
##       RMSE   Rsquared        MAE 
## 4.34406578 0.08294009 3.27903612
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2879932
## hat      0.2879932 1.0000000
```

```
## Warning: Removed 2 rows containing non-finite values (stat_smooth).

## Warning: Removed 2 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 2 rows containing missing values (geom_point).
```

![plot of chunk PCB2_Tot_Training-predict](figures/PCB2_Tot_Training-predict-1.png)

Evaluate model on the validation sample.


```
##        RMSE    Rsquared         MAE 
## 4.751960997 0.006793934 3.387031794
```

```
##            PCB2_Tot        hat
## PCB2_Tot 1.00000000 0.08242532
## hat      0.08242532 1.00000000
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
## 313 samples
##  53 predictor
## 
## No pre-processing
## Resampling: Leave-One-Out Cross-Validation 
## Summary of sample sizes: 308, 308, 308, 308, 308, 308, ... 
## Resampling results across tuning parameters:
## 
##   nprune  degree  RMSE       Rsquared     MAE      
##    7      1        12.25809  0.032861943   9.765868
##    7      2        12.57304  0.053111917   9.782459
##    7      3        13.23303  0.017085486   9.926078
##    7      4        12.54847  0.036799663   9.797720
##    7      5        12.55646  0.046180451   9.858850
##    8      1        12.29530  0.032501173   9.784480
##    8      2        12.64184  0.051491778   9.784639
##    8      3        13.08942  0.023189558   9.906610
##    8      4        12.41917  0.047417832   9.714098
##    8      5        12.56283  0.048466052   9.827087
##    9      1        12.30662  0.033424297   9.817277
##    9      2        12.79154  0.047248316   9.881404
##    9      3        13.18005  0.027751942   9.897018
##    9      4        12.53848  0.045876434   9.794338
##    9      5        12.69643  0.048171446   9.937693
##   10      1        12.47259  0.031615272  10.004555
##   10      2        12.73206  0.050573858   9.830126
##   10      3        13.45884  0.025774869   9.897238
##   10      4        13.26012  0.031090985  10.026267
##   10      5        12.73985  0.045392039   9.948808
##   11      1        12.53084  0.035036386  10.065840
##   11      2        12.98769  0.041308548  10.023772
##   11      3        13.34721  0.030389835   9.884660
##   11      4        13.34790  0.030197492  10.104084
##   11      5        12.74606  0.047804977   9.994599
##   12      1        12.64403  0.036142719  10.103660
##   12      2        13.10650  0.038759679  10.041388
##   12      3        13.30184  0.034022123   9.917948
##   12      4        13.35860  0.030694835   9.995172
##   12      5        12.87767  0.045596761  10.004254
##   13      1        12.70745  0.038239506  10.193649
##   13      2        13.12632  0.033710672  10.035960
##   13      3        13.24654  0.042525134   9.859018
##   13      4        13.38773  0.035986123   9.909382
##   13      5        12.92645  0.046611979  10.016671
##   14      1        12.73360  0.039270176  10.293989
##   14      2        13.12369  0.039393245   9.972609
##   14      3        13.27647  0.042818532   9.781081
##   14      4        31.82487  0.004814939  11.645913
##   14      5        31.65046  0.004891614  11.787915
##   15      1        12.83376  0.036029041  10.358566
##   15      2        13.09317  0.042990551   9.991400
##   15      3        13.24331  0.045520656   9.758137
##   15      4        32.11659  0.004551526  11.714862
##   15      5       212.78487  0.005721525  23.806491
##   20      1        13.04934  0.036120007  10.374992
##   20      2        13.19741  0.051391497  10.139349
##   20      3        13.94730  0.030112474  10.393658
##   20      4       176.12804  0.005306590  21.642973
##   20      5       219.40073  0.005832624  24.414292
##   30      1        13.19958  0.039196918  10.545087
##   30      2        15.12577  0.029942074  10.674887
##   30      3        15.33600  0.016111128  10.945001
##   30      4       193.29108  0.005517351  23.209361
##   30      5       217.53164  0.005855084  24.715147
##   40      1        13.29884  0.042195926  10.627378
##   40      2        15.13838  0.029766245  10.691327
##   40      3        16.07038  0.013978861  11.184455
##   40      4       201.17879  0.005292169  23.907106
##   40      5       201.55602  0.005413242  24.048149
##   50      1        13.29554  0.043066379  10.614669
##   50      2        15.13838  0.029766245  10.691327
##   50      3        16.07363  0.014638455  11.224486
##   50      4       210.52203  0.005311185  24.534087
##   50      5       231.06804  0.005542658  26.184926
## 
## RMSE was used to select the optimal model using the smallest value.
## The final values used for the model were nprune = 7 and degree = 1.
```

![plot of chunk PCB3_Total_Training](figures/PCB3_Total_Training-1.png)


```
## Selected 6 of 125 terms, and 4 of 160 predictors
## Termination condition: Reached nk 201
## Importance: SEPTI_discipline, SEPTI_nurturance, zipcode97702, ...
## Number of terms at each degree of interaction: 1 5 (additive model)
## GCV 126.1607    RSS 36257.51    GRSq 0.1200511    RSq 0.1762631
```

```
## Call: earth(x=matrix[309,160], y=c(58,54,64,53,4...), keepxy=TRUE,
##             degree=1, nprune=7)
## 
##                                      coefficients
## (Intercept)                             37.563743
## zipcode97702                            -8.786946
## h(ECBI_intensity_T_score- -0.101729)     2.171136
## h(SEPTI_nurturance- -1.51673)            5.624786
## h(-0.0841729-SEPTI_nurturance)           6.901875
## h(SEPTI_discipline-0.794477)           -10.933372
## 
## Selected 6 of 125 terms, and 4 of 160 predictors
## Termination condition: Reached nk 201
## Importance: SEPTI_discipline, SEPTI_nurturance, zipcode97702, ...
## Number of terms at each degree of interaction: 1 5 (additive model)
## GCV 126.1607    RSS 36257.51    GRSq 0.1200511    RSq 0.1762631
```

![plot of chunk PCB3_Total_Training-finalModel](figures/PCB3_Total_Training-finalModel-1.png)

```
## earth variable importance
## 
##   only 20 most important variables shown (out of 160)
## 
##                                             Overall
## SEPTI_discipline                            100.000
## SEPTI_nurturance                             73.094
## zipcode97702                                 35.829
## ECBI_intensity_T_score                        6.116
## ECBI_Inatt                                    0.000
## zipcode97220                                  0.000
## zipcode97225                                  0.000
## zipcode97034                                  0.000
## childRelationshipStepparent                   0.000
## SEPTI_n_clinical_cutoff                       0.000
## communitySuburban                             0.000
## zipcode97741                                  0.000
## childRelationshipBiologicaloradoptivefather   0.000
## MAPS_PR                                       0.000
## zipcode97759                                  0.000
## zipcode97027                                  0.000
## parentEthnicityUnknown                        0.000
## MAPS_HS                                       0.000
## SEPTI_p_clinical_cutoff                       0.000
## childAge                                      0.000
```


```
##       RMSE   Rsquared        MAE 
## 10.8579992  0.1793122  8.7998279
```

```
##           PCB2_Tot       hat
## PCB2_Tot 1.0000000 0.2262749
## hat      0.2262749 1.0000000
```

```
## Warning: Removed 2 rows containing non-finite values (stat_smooth).

## Warning: Removed 2 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 2 rows containing missing values (geom_point).
```

![plot of chunk PCB3_Total_Training-predict](figures/PCB3_Total_Training-predict-1.png)

Evaluate model on the validation sample.


```
##       RMSE   Rsquared        MAE 
## 11.9215783  0.1123261  9.7539097
```

```
##            PCB3_Total       hat
## PCB3_Total  1.0000000 0.3351509
## hat         0.3351509 1.0000000
```

![plot of chunk PCB3_TotalValidation-predict](figures/PCB3_TotalValidation-predict-1.png)



