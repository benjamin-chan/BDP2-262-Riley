---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-11"
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




```
## Warning: package 'bindrcpp' was built under R version 3.4.4
```

Remove certain predictor variables:

* Clinical cutoffs
* Raw scores
* Total scores


```
##  [1] "ECBI_intensity_raw_score"       "ECBI_intensity_clinical_cutoff"
##  [3] "ECBI_problem_raw_score"         "ECBI_problem_clinical_cutoff"  
##  [5] "SEPTI_n_clinical_cutoff"        "SEPTI_d_clinical_cutoff"       
##  [7] "SEPTI_p_clinical_cutoff"        "SEPTI_r_clinical_cutoff"       
##  [9] "SEPTI_total"                    "SEPTI_total_clin_cutoff"
```



Build analysis data set.
Exclude if missing any dependent variable, `PCB1_Total`, `PCB2_Tot`, `PCB3_Total`.
Exclude rows if there are a high proportion of row-wise `NA`.





![figures/flowChart.png](figures/flowChart.png)





# Cluster analysis

Use divisive hierarchical clustering (DIANA).
See [Divisive Hierarchical Clustering Essentials](http://www.sthda.com/english/articles/28-hierarchical-clustering-essentials/94-divisive-hierarchical-clustering-essentials/).


```
## Warning: package 'cluster' was built under R version 3.4.4
```

```
## Warning: package 'factoextra' was built under R version 3.4.4
```

```
## Welcome! Related Books: `Practical Guide To Cluster Analysis in R` at https://goo.gl/13EFCZ
```

```
## 
## To cite package 'factoextra' in publications use:
## 
##   Alboukadel Kassambara and Fabian Mundt (2017). factoextra:
##   Extract and Visualize the Results of Multivariate Data Analyses.
##   R package version 1.0.5.
##   https://CRAN.R-project.org/package=factoextra
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {factoextra: Extract and Visualize the Results of Multivariate Data Analyses},
##     author = {Alboukadel Kassambara and Fabian Mundt},
##     year = {2017},
##     note = {R package version 1.0.5},
##     url = {https://CRAN.R-project.org/package=factoextra},
##   }
```



Use the **manhattan** metric.




## Cluster on PCB metrics

**Clustering on PCB metrics isn't terrible.**

* Cluster 1 ($n = 253$) has high PCB scores on all domains
* Cluster 2 ($n = 92$) has low PCB scores on all domains


```
## [1] 345   8
```

```
## [1] "PCB1_Total"    "PCB1_CondEmot" "PCB1_DevHab"   "PCB2_Tot"     
## [5] "PCB3_Total"    "PCB3_PCPonly"  "PCB3_Person"   "PCB3_Resource"
```

```
##   cluster size ave.sil.width
## 1       1  253          0.43
## 2       2   92          0.31
```

* Hopkins statistic is 0.254
* Analysis identified $k = 2$ clusters
* Divisive coefficient is 0.929
* Average silhouette width is 0.394

![plot of chunk clusterYPCB](figures/clusterYPCB-1.png)![plot of chunk clusterYPCB](figures/clusterYPCB-2.png)![plot of chunk clusterYPCB](figures/clusterYPCB-3.png)


|cluster |   n| PCB1_Total_mean| PCB1_CondEmot_mean| PCB1_DevHab_mean|
|:-------|---:|---------------:|------------------:|----------------:|
|1       | 253|            74.0|               53.7|             20.3|
|2       |  92|            47.1|               33.6|             13.5|



|cluster |   n| PCB2_Tot_mean|
|:-------|---:|-------------:|
|1       | 253|          25.9|
|2       |  92|          20.0|



|cluster |   n| PCB3_Total_mean| PCB3_PCPonly_mean| PCB3_Person_mean| PCB3_Resource_mean|
|:-------|---:|---------------:|-----------------:|----------------:|------------------:|
|1       | 253|            51.7|               4.4|             17.4|                 30|
|2       |  92|            34.2|               3.3|             11.9|                 19|


## Cluster on ECBI metrics

**Clustering on ECBI alone is good**

* Cluster 1 ($n = 260$) has low ECBI scores
* Cluster 2 ($n = 85$) has high ECBI scores


```
## [1] 345   5
```

```
## [1] "ECBI_intensity_T_score" "ECBI_problem_T_score"  
## [3] "ECBI_Opp"               "ECBI_Inatt"            
## [5] "ECBI_Cond"
```

```
##   cluster size ave.sil.width
## 1       1  258          0.45
## 2       2   87          0.33
```

* Hopkins statistic is 0.197
* Analysis identified $k = 2$ clusters
* Divisive coefficient is 0.950
* Average silhouette width is 0.419

![plot of chunk clusterXECBI](figures/clusterXECBI-1.png)![plot of chunk clusterXECBI](figures/clusterXECBI-2.png)![plot of chunk clusterXECBI](figures/clusterXECBI-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 258|                        50.7|                      49.8|          30.1|            12.4|           13.4|
|2       |  87|                        62.4|                      65.4|          43.7|            16.9|           21.9|


## Cluster on MAPS metrics

**Clustering on MAPS alone is good**

* Cluster 1 ($n = 305$) has high *positive* MAPS scores
* Cluster 2 ($n = 39$) has high *negative* MAPS scores
* Cluster 3 ($n = 1$) is an outlier with low positive and low negative MAPS scores


```
## [1] 345   9
```

```
## [1] "MAPS_PP"  "MAPS_PR"  "MAPS_WM"  "MAPS_SP"  "MAPS_HS"  "MAPS_LC" 
## [7] "MAPS_PC"  "MAPS_POS" "MAPS_NEG"
```

```
##   cluster size ave.sil.width
## 1       1  305          0.45
## 2       2   39          0.30
## 3       3    1          0.00
```

* Hopkins statistic is 0.213
* Analysis identified $k = 3$ clusters
* Divisive coefficient is 0.923
* Average silhouette width is 0.436

![plot of chunk clusterXMAPS](figures/clusterXMAPS-1.png)![plot of chunk clusterXMAPS](figures/clusterXMAPS-2.png)![plot of chunk clusterXMAPS](figures/clusterXMAPS-3.png)


|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 305|          4.1|          4.6|          4.7|          4.5|            2|          1.9|          1.4|           4.5|           1.8|
|2       |  39|          3.4|          3.7|          4.0|          3.4|            3|          2.6|          2.6|           3.7|           2.7|
|3       |   1|          2.3|          3.0|          1.7|          1.0|            1|          1.0|          1.0|           2.0|           1.0|


## Cluster on SEPTI metrics

**Clustering on ECBI, MAPS, and SEPTI metrics isn't terrible.**

* Cluster 1 ($n = 193$) has high SEPTI scores
* Cluster 2 ($n = 152$) has low SEPTI scores


```
## [1] 345   4
```

```
## [1] "SEPTI_nurturance" "SEPTI_discipline" "SEPTI_play"      
## [4] "SEPTI_routine"
```

```
##   cluster size ave.sil.width
## 1       1  185          0.38
## 2       2  160          0.29
```

* Hopkins statistic is 0.285
* Analysis identified $k = 2$ clusters
* Divisive coefficient is 0.929
* Average silhouette width is 0.339

![plot of chunk clusterXSEPTI](figures/clusterXSEPTI-1.png)![plot of chunk clusterXSEPTI](figures/clusterXSEPTI-2.png)![plot of chunk clusterXSEPTI](figures/clusterXSEPTI-3.png)


|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 185|                  39.6|                  26.8|            35.8|               31.5|
|2       | 160|                  34.8|                  19.8|            27.0|               25.3|


## Cluster on ECBI, MAPS, SEPTI metrics

Attempt to identify clusters using all metrics.

**Clustering on ECBI, MAPS, and SEPTI metrics isn't terrible.**

* Cluster 1 ($n = 297$) has
  * Low ECBI scores
  * High *positive* MAPS scores
  * High SEPTI scores
* Cluster 2 ($n = 45$) has
  * High ECBI scores
  * High *negative* MAPS scores
  * Low SEPTI scores
* Cluster 3 ($n = 3$) is the outlier; have low positive and low negative MAPS scores


```
## [1] 345  18
```

```
##  [1] "ECBI_intensity_T_score" "ECBI_problem_T_score"  
##  [3] "ECBI_Opp"               "ECBI_Inatt"            
##  [5] "ECBI_Cond"              "MAPS_PP"               
##  [7] "MAPS_PR"                "MAPS_WM"               
##  [9] "MAPS_SP"                "MAPS_HS"               
## [11] "MAPS_LC"                "MAPS_PC"               
## [13] "MAPS_POS"               "MAPS_NEG"              
## [15] "SEPTI_nurturance"       "SEPTI_discipline"      
## [17] "SEPTI_play"             "SEPTI_routine"
```

```
##   cluster size ave.sil.width
## 1       1  297          0.36
## 2       2   45          0.23
## 3       3    3          0.28
```

* Hopkins statistic is 0.288
* Analysis identified $k = 3$ clusters
* Divisive coefficient is 0.853
* Average silhouette width is 0.340

![plot of chunk clusterXMetrics](figures/clusterXMetrics-1.png)![plot of chunk clusterXMetrics](figures/clusterXMetrics-2.png)![plot of chunk clusterXMetrics](figures/clusterXMetrics-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 297|                        52.5|                      52.2|          32.3|            13.2|           14.3|
|2       |  45|                        62.3|                      64.6|          43.2|            15.8|           24.4|
|3       |   3|                        37.7|                      44.3|          17.7|             5.3|            8.0|



|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 297|          4.1|          4.6|          4.7|          4.5|          2.0|          1.9|          1.4|           4.5|           1.8|
|2       |  45|          3.6|          4.0|          4.1|          3.6|          3.0|          2.7|          2.5|           3.8|           2.7|
|3       |   3|          2.4|          2.9|          3.2|          2.1|          1.5|          1.9|          1.9|           2.7|           1.8|



|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 297|                  38.1|                  24.3|            32.8|               29.4|
|2       |  45|                  33.4|                  18.8|            25.0|               23.5|
|3       |   3|                  26.3|                  19.3|            25.7|               24.0|


## Cluster on ECBI, MAPS, SEPTI metrics and demographics

**Clustering on ECBI, MAPS, and SEPTI metrics isn't terrible.**

* `languageSurvey` dropped from consideration; $n = 1$
* Cluster 1 ($n = 297$) has high positive MAPS scores and high SEPTI scores
* Cluster 2 ($n = 45$) has high negative MAPS scores and high ECBI scores
* Cluster 3 ($n = 3$) has low ECBI scores


```
## [1] 345  29
```

```
##  [1] "zipcodeClass1"           "zipcodeClass2"          
##  [3] "communitySuburban"       "communityRural"         
##  [5] "distance"                "income$25,001-$49,999"  
##  [7] "income$50,000-$79,999"   "income$80,000-$119,999" 
##  [9] "income$120,000-$149,999" "income$150,000 or more" 
## [11] "internet"                "ECBI_intensity_T_score" 
## [13] "ECBI_problem_T_score"    "ECBI_Opp"               
## [15] "ECBI_Inatt"              "ECBI_Cond"              
## [17] "MAPS_PP"                 "MAPS_PR"                
## [19] "MAPS_WM"                 "MAPS_SP"                
## [21] "MAPS_HS"                 "MAPS_LC"                
## [23] "MAPS_PC"                 "MAPS_POS"               
## [25] "MAPS_NEG"                "SEPTI_nurturance"       
## [27] "SEPTI_discipline"        "SEPTI_play"             
## [29] "SEPTI_routine"
```

```
##   cluster size ave.sil.width
## 1       1  280          0.25
## 2       2   64          0.15
## 3       3    1          0.00
```

* Hopkins statistic is 0.272
* Analysis identified $k = 3$ clusters
* Divisive coefficient is 0.816
* Average silhouette width is 0.230

![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-1.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-2.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 280|                        52.2|                      51.8|          31.9|            13.1|           14.1|
|2       |  64|                        59.7|                      61.8|          40.6|            15.2|           21.7|
|3       |   1|                        78.0|                      84.0|          53.0|            23.0|           41.0|



|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 280|          4.2|          4.6|          4.7|          4.5|          2.0|          1.9|          1.3|           4.5|           1.7|
|2       |  64|          3.6|          4.0|          4.1|          3.8|          2.8|          2.6|          2.3|           3.9|           2.6|
|3       |   1|          4.3|          5.0|          3.0|          4.7|          3.6|          3.9|          1.8|           4.2|           3.1|



|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 280|                  38.3|                  24.6|            33.2|               29.7|
|2       |  64|                  33.5|                  19.2|            25.8|               23.7|
|3       |   1|                  29.0|                  13.0|            11.0|               20.0|


|cluster |   n| distance_mean| distance_median|distance_range |
|:-------|---:|-------------:|---------------:|:--------------|
|1       | 280|           9.4|               5|0.4-130.0      |
|2       |  64|          12.3|               9|1.0-150.0      |
|3       |   1|          10.0|              10|10.0-10.0      |



|cluster |zipcodeClass |   n|  pct|
|:-------|:------------|---:|----:|
|1       |1            | 196| 0.70|
|1       |2            |  84| 0.30|
|2       |1            |  53| 0.83|
|2       |2            |  11| 0.17|
|3       |1            |   1| 1.00|



|cluster |community |   n|  pct|
|:-------|:---------|---:|----:|
|1       |Urban     |  95| 0.34|
|1       |Suburban  | 129| 0.46|
|1       |Rural     |  56| 0.20|
|2       |Urban     |  27| 0.42|
|2       |Suburban  |  29| 0.45|
|2       |Rural     |   8| 0.12|
|3       |Rural     |   1| 1.00|



|cluster |income            |  n|  pct|
|:-------|:-----------------|--:|----:|
|1       |$25,000 or less   | 27| 0.10|
|1       |$25,001-$49,999   | 57| 0.20|
|1       |$50,000-$79,999   | 79| 0.28|
|1       |$80,000-$119,999  | 50| 0.18|
|1       |$120,000-$149,999 | 24| 0.09|
|1       |$150,000 or more  | 43| 0.15|
|2       |$25,000 or less   |  7| 0.11|
|2       |$25,001-$49,999   | 26| 0.41|
|2       |$50,000-$79,999   | 12| 0.19|
|2       |$80,000-$119,999  |  6| 0.09|
|2       |$120,000-$149,999 |  8| 0.12|
|2       |$150,000 or more  |  5| 0.08|
|3       |$25,000 or less   |  1| 1.00|



|cluster | internet|   n|  pct|
|:-------|--------:|---:|----:|
|1       |        0|   6| 0.02|
|1       |        1| 274| 0.98|
|2       |        0|   2| 0.03|
|2       |        1|  62| 0.97|
|3       |        0|   1| 1.00|


## Cluster on parent factors

**Clustering on parent factors is terrible.**

* First split, with $k = 2$, produces one very small cluster ($n = 8$).


```
## [1] 345  30
```

```
##  [1] "totalChildren"                                                               
##  [2] "parentGenderMale"                                                            
##  [3] "parentGenderFemale"                                                          
##  [4] "parentGenderTransgender"                                                     
##  [5] "parentGenderOther"                                                           
##  [6] "parentGenderPrefer not to respond"                                           
##  [7] "parentSexMale"                                                               
##  [8] "parentAge"                                                                   
##  [9] "parentEthnicityNot Hispanic/Latino"                                          
## [10] "parentEthnicityUnknown"                                                      
## [11] "parentEthnicityPrefer not to respond"                                        
## [12] "parentRaceWhite1"                                                            
## [13] "parentRaceAsian1"                                                            
## [14] "parentRaceAfrAm1"                                                            
## [15] "parentRaceAIAN1"                                                             
## [16] "parentRaceNHPI1"                                                             
## [17] "parentRaceOther1"                                                            
## [18] "parentRaceNoResp1"                                                           
## [19] "parentMaritalStatusWidowed"                                                  
## [20] "parentMaritalStatusDivorced"                                                 
## [21] "parentMaritalStatusSeparated"                                                
## [22] "parentMaritalStatusRemarried"                                                
## [23] "parentMaritalStatusNever married"                                            
## [24] "parentSituationCouple parenting with spouse or partner in the same household"
## [25] "parentSituationCo-parenting in separate households"                          
## [26] "parentsNumber"                                                               
## [27] "parentChildRatio"                                                            
## [28] "parentEducationVocational school/some college"                               
## [29] "parentEducationCollege"                                                      
## [30] "parentEducationGraduate/professional school"
```

```
##   cluster size ave.sil.width
## 1       1  330          0.44
## 2       2    6          0.48
## 3       3    7          0.22
## 4       4    1          0.00
## 5       5    1          0.00
```

* Hopkins statistic is 0.078
* Analysis identified $k = 5$ clusters
* Divisive coefficient is 0.945
* Average silhouette width is 0.435

![plot of chunk clusterXParent](figures/clusterXParent-1.png)![plot of chunk clusterXParent](figures/clusterXParent-2.png)![plot of chunk clusterXParent](figures/clusterXParent-3.png)


|cluster |   n| totalChildren_mean| totalChildren_median| parentAge_mean| parentAge_median|
|:-------|---:|------------------:|--------------------:|--------------:|----------------:|
|1       | 330|                2.0|                  2.0|           33.6|             33.0|
|2       |   6|                1.7|                  1.5|           30.0|             27.5|
|3       |   7|                3.4|                  3.0|           39.3|             36.0|
|4       |   1|                5.0|                  5.0|           31.0|             31.0|
|5       |   1|                2.0|                  2.0|           43.0|             43.0|



|cluster |parentGender          |   n|  pct|
|:-------|:---------------------|---:|----:|
|1       |Male                  |  51| 0.15|
|1       |Female                | 278| 0.84|
|1       |Transgender           |   1| 0.00|
|2       |Female                |   4| 0.67|
|2       |Prefer not to respond |   2| 0.33|
|3       |Male                  |   1| 0.14|
|3       |Female                |   5| 0.71|
|3       |Prefer not to respond |   1| 0.14|
|4       |Other                 |   1| 1.00|
|5       |Female                |   1| 1.00|



|cluster |parentSituation                                               |   n|  pct|
|:-------|:-------------------------------------------------------------|---:|----:|
|1       |Single parenting                                              |  24| 0.07|
|1       |Couple parenting with spouse or partner in the same household | 299| 0.91|
|1       |Co-parenting in separate households                           |   7| 0.02|
|2       |Single parenting                                              |   5| 0.83|
|2       |Couple parenting with spouse or partner in the same household |   1| 0.17|
|3       |Single parenting                                              |   1| 0.14|
|3       |Co-parenting in separate households                           |   6| 0.86|
|4       |Couple parenting with spouse or partner in the same household |   1| 1.00|
|5       |Single parenting                                              |   1| 1.00|



|cluster |parentEducation                |   n|  pct|
|:-------|:------------------------------|---:|----:|
|1       |High school or less            |  38| 0.12|
|1       |Vocational school/some college |  62| 0.19|
|1       |College                        | 135| 0.41|
|1       |Graduate/professional school   |  95| 0.29|
|2       |High school or less            |   3| 0.50|
|2       |Vocational school/some college |   2| 0.33|
|2       |Graduate/professional school   |   1| 0.17|
|3       |Vocational school/some college |   3| 0.43|
|3       |College                        |   3| 0.43|
|3       |Graduate/professional school   |   1| 0.14|
|4       |High school or less            |   1| 1.00|
|5       |Vocational school/some college |   1| 1.00|



|cluster |parentEthnicity       |   n|  pct|
|:-------|:---------------------|---:|----:|
|1       |Hispanic/Latino       |  35| 0.11|
|1       |Not Hispanic/Latino   | 272| 0.82|
|1       |Unknown               |   4| 0.01|
|1       |Prefer not to respond |  19| 0.06|
|2       |Not Hispanic/Latino   |   6| 1.00|
|3       |Not Hispanic/Latino   |   2| 0.29|
|3       |Unknown               |   2| 0.29|
|3       |Prefer not to respond |   3| 0.43|
|4       |Hispanic/Latino       |   1| 1.00|
|5       |Not Hispanic/Latino   |   1| 1.00|



|cluster |parentRaceWhite |   n|  pct|
|:-------|:---------------|---:|----:|
|1       |0               |  73| 0.22|
|1       |1               | 257| 0.78|
|2       |1               |   6| 1.00|
|3       |0               |   4| 0.57|
|3       |1               |   3| 0.43|
|4       |0               |   1| 1.00|
|5       |1               |   1| 1.00|


## Cluster on child factors

**Clustering on child factors is terrible.**
First split, with $k = 2$, produces one very small cluster.


```
## [1] 345  19
```

```
##  [1] "birthOrderOnly child"                          
##  [2] "birthOrderOldest"                              
##  [3] "birthOrderMiddle"                              
##  [4] "birthOrderYoungest"                            
##  [5] "childSexMale"                                  
##  [6] "childAge"                                      
##  [7] "childEthnicityNot Hispanic/Latino"             
##  [8] "childEthnicityUnknown"                         
##  [9] "childEthnicityPrefer not to respond"           
## [10] "childRaceWhite1"                               
## [11] "childRaceAsian1"                               
## [12] "childRaceAfrAm1"                               
## [13] "childRaceAIAN1"                                
## [14] "childRaceNHPI1"                                
## [15] "childRaceOther1"                               
## [16] "childRaceNoResp1"                              
## [17] "childRelationshipBiological or adoptive father"
## [18] "childRelationshipGrandparent"                  
## [19] "childRelationshipOther"
```

```
##   cluster size ave.sil.width
## 1       1  329          0.43
## 2       2    7          0.41
## 3       3    6          0.50
## 4       4    2          0.90
## 5       5    1          0.00
```

* Hopkins statistic is 0.065
* Analysis identified $k = 5$ clusters
* Divisive coefficient is 0.967
* Average silhouette width is 0.432

![plot of chunk clusterXChild](figures/clusterXChild-1.png)![plot of chunk clusterXChild](figures/clusterXChild-2.png)![plot of chunk clusterXChild](figures/clusterXChild-3.png)


|cluster |   n| childAge_mean| childAge_median|
|:-------|---:|-------------:|---------------:|
|1       | 329|           3.5|             3.4|
|2       |   7|           4.5|             4.9|
|3       |   6|           4.0|             4.2|
|4       |   2|           4.7|             4.7|
|5       |   1|           4.8|             4.8|



|cluster |birthOrder |   n|  pct|
|:-------|:----------|---:|----:|
|1       |Only child | 109| 0.33|
|1       |Oldest     |  90| 0.27|
|1       |Middle     |  38| 0.12|
|1       |Youngest   |  92| 0.28|
|2       |Only child |   1| 0.14|
|2       |Oldest     |   4| 0.57|
|2       |Middle     |   2| 0.29|
|3       |Only child |   2| 0.33|
|3       |Oldest     |   2| 0.33|
|3       |Middle     |   1| 0.17|
|3       |Youngest   |   1| 0.17|
|4       |Middle     |   2| 1.00|
|5       |Youngest   |   1| 1.00|



|cluster |childSex |   n|  pct|
|:-------|:--------|---:|----:|
|1       |Female   | 149| 0.45|
|1       |Male     | 180| 0.55|
|2       |Female   |   4| 0.57|
|2       |Male     |   3| 0.43|
|3       |Female   |   4| 0.67|
|3       |Male     |   2| 0.33|
|4       |Male     |   2| 1.00|
|5       |Female   |   1| 1.00|



|cluster |childEthnicity        |   n|  pct|
|:-------|:---------------------|---:|----:|
|1       |Hispanic/Latino       |  42| 0.13|
|1       |Not Hispanic/Latino   | 261| 0.79|
|1       |Prefer not to respond |  26| 0.08|
|2       |Hispanic/Latino       |   4| 0.57|
|2       |Not Hispanic/Latino   |   3| 0.43|
|3       |Unknown               |   6| 1.00|
|4       |Hispanic/Latino       |   1| 0.50|
|4       |Not Hispanic/Latino   |   1| 0.50|
|5       |Not Hispanic/Latino   |   1| 1.00|



|cluster |childRaceWhite |   n|  pct|
|:-------|:--------------|---:|----:|
|1       |0              |  63| 0.19|
|1       |1              | 266| 0.81|
|2       |0              |   2| 0.29|
|2       |1              |   5| 0.71|
|3       |1              |   6| 1.00|
|4       |0              |   2| 1.00|
|5       |1              |   1| 1.00|



|cluster |childRelationship             |   n|  pct|
|:-------|:-----------------------------|---:|----:|
|1       |Biological or adoptive mother | 285| 0.87|
|1       |Biological or adoptive father |  44| 0.13|
|2       |Biological or adoptive mother |   6| 0.86|
|2       |Biological or adoptive father |   1| 0.14|
|3       |Biological or adoptive mother |   6| 1.00|
|4       |Other                         |   2| 1.00|
|5       |Grandparent                   |   1| 1.00|


## Cluster on demographic factors

**Clustering on demographic factors is terrible.**

* `languageSurvey` dropped from consideration; $n = 1$
* First two splits, with $k = 3$, produces two very small clusters
* The next split, at $k = 4$, produces a good sized cluster
* The clustering between clusters 1 ($n = 249$) and 2 ($n = 93$) appears to have to do more with geography (distance, zipcode class, urban/rural)


```
## [1] 345  88
```

```
##  [1] "zipcodeClass1"           "zipcodeClass2"          
##  [3] "zipcode91020"            "zipcode91204"           
##  [5] "zipcode91206"            "zipcode91210"           
##  [7] "zipcode91402"            "zipcode97003"           
##  [9] "zipcode97006"            "zipcode97007"           
## [11] "zipcode97008"            "zipcode97023"           
## [13] "zipcode97027"            "zipcode97032"           
## [15] "zipcode97034"            "zipcode97035"           
## [17] "zipcode97045"            "zipcode97056"           
## [19] "zipcode97060"            "zipcode97062"           
## [21] "zipcode97068"            "zipcode97071"           
## [23] "zipcode97078"            "zipcode97086"           
## [25] "zipcode97089"            "zipcode97101"           
## [27] "zipcode97116"            "zipcode97123"           
## [29] "zipcode97124"            "zipcode97140"           
## [31] "zipcode97141"            "zipcode97201"           
## [33] "zipcode97202"            "zipcode97203"           
## [35] "zipcode97206"            "zipcode97209"           
## [37] "zipcode97210"            "zipcode97211"           
## [39] "zipcode97212"            "zipcode97213"           
## [41] "zipcode97214"            "zipcode97215"           
## [43] "zipcode97217"            "zipcode97219"           
## [45] "zipcode97220"            "zipcode97221"           
## [47] "zipcode97222"            "zipcode97223"           
## [49] "zipcode97224"            "zipcode97225"           
## [51] "zipcode97227"            "zipcode97229"           
## [53] "zipcode97230"            "zipcode97232"           
## [55] "zipcode97233"            "zipcode97236"           
## [57] "zipcode97239"            "zipcode97266"           
## [59] "zipcode97267"            "zipcode97321"           
## [61] "zipcode97325"            "zipcode97429"           
## [63] "zipcode97527"            "zipcode97701"           
## [65] "zipcode97702"            "zipcode97703"           
## [67] "zipcode97707"            "zipcode97734"           
## [69] "zipcode97738"            "zipcode97741"           
## [71] "zipcode97753"            "zipcode97754"           
## [73] "zipcode97756"            "zipcode97759"           
## [75] "zipcode97760"            "zipcode98632"           
## [77] "zipcode98660"            "zipcode98683"           
## [79] "zipcode98685"            "communitySuburban"      
## [81] "communityRural"          "distance"               
## [83] "income$25,001-$49,999"   "income$50,000-$79,999"  
## [85] "income$80,000-$119,999"  "income$120,000-$149,999"
## [87] "income$150,000 or more"  "internet"
```

```
##   cluster size ave.sil.width
## 1       1  249          0.19
## 2       2   93          0.34
## 3       3    2         -0.11
## 4       4    1          0.00
```

* Hopkins statistic is 0.041
* Analysis identified $k = 4$ clusters
* Divisive coefficient is 0.878
* Average silhouette width is 0.231

![plot of chunk clusterXDemog](figures/clusterXDemog-1.png)![plot of chunk clusterXDemog](figures/clusterXDemog-2.png)![plot of chunk clusterXDemog](figures/clusterXDemog-3.png)


|cluster |   n| distance_mean| distance_median|distance_range |
|:-------|---:|-------------:|---------------:|:--------------|
|1       | 249|           6.7|               5|0.4-30.0       |
|2       |  93|          15.1|              12|1.0-100.0      |
|3       |   2|         140.0|             140|130.0-150.0    |
|4       |   1|          75.0|              75|75.0-75.0      |



|cluster |zipcodeClass |   n| pct|
|:-------|:------------|---:|---:|
|1       |1            | 249|   1|
|2       |2            |  93|   1|
|3       |2            |   2|   1|
|4       |1            |   1|   1|



|cluster |community |   n|  pct|
|:-------|:---------|---:|----:|
|1       |Urban     | 109| 0.44|
|1       |Suburban  | 128| 0.51|
|1       |Rural     |  12| 0.05|
|2       |Urban     |  13| 0.14|
|2       |Suburban  |  30| 0.32|
|2       |Rural     |  50| 0.54|
|3       |Rural     |   2| 1.00|
|4       |Rural     |   1| 1.00|



|cluster |income            |  n|  pct|
|:-------|:-----------------|--:|----:|
|1       |$25,000 or less   | 25| 0.10|
|1       |$25,001-$49,999   | 57| 0.23|
|1       |$50,000-$79,999   | 58| 0.23|
|1       |$80,000-$119,999  | 38| 0.15|
|1       |$120,000-$149,999 | 27| 0.11|
|1       |$150,000 or more  | 44| 0.18|
|2       |$25,000 or less   | 10| 0.11|
|2       |$25,001-$49,999   | 26| 0.28|
|2       |$50,000-$79,999   | 31| 0.33|
|2       |$80,000-$119,999  | 17| 0.18|
|2       |$120,000-$149,999 |  5| 0.05|
|2       |$150,000 or more  |  4| 0.04|
|3       |$50,000-$79,999   |  1| 0.50|
|3       |$80,000-$119,999  |  1| 0.50|
|4       |$50,000-$79,999   |  1| 1.00|



|cluster | internet|   n|  pct|
|:-------|--------:|---:|----:|
|1       |        0|   4| 0.02|
|1       |        1| 245| 0.98|
|2       |        0|   4| 0.04|
|2       |        1|  89| 0.96|
|3       |        1|   2| 1.00|
|4       |        0|   1| 1.00|


## Save objects


```
##                                          size isdir mode
## data/processed/clusterAnalysis.RData 11981880 FALSE  666
##                                                    mtime
## data/processed/clusterAnalysis.RData 2018-07-11 14:15:05
##                                                    ctime
## data/processed/clusterAnalysis.RData 2018-07-06 12:14:44
##                                                    atime exe
## data/processed/clusterAnalysis.RData 2018-07-06 12:14:44  no
```



