---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-12"
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

* Cluster 1 ($n = 253$) has high PCB scores on all domains
* Cluster 2 ($n = 92$) has low PCB scores on all domains


## Cluster on ECBI metrics


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

**Clustering on ECBI alone is good**

* Cluster 1 ($n = 258$) has low ECBI scores
* Cluster 2 ($n = 87$) has high ECBI scores


## Cluster on MAPS metrics


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

**Clustering on MAPS alone is good**

* Cluster 1 ($n = 305$) has high *positive* MAPS scores
* Cluster 2 ($n = 39$) has high *negative* MAPS scores
* Cluster 3 ($n = 1$) is an outlier with low positive and low negative MAPS scores


## Cluster on SEPTI metrics


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

**Clustering on ECBI, MAPS, and SEPTI metrics isn't terrible.**

* Cluster 1 ($n = 185$) has high SEPTI scores
* Cluster 2 ($n = 160$) has low SEPTI scores


## Cluster on ECBI, MAPS, SEPTI metrics and demographics


```
## [1] 345  28
```

```
##  [1] "parentRaceWhite0"                             
##  [2] "parentRaceWhite1"                             
##  [3] "parentEducationVocational school/some college"
##  [4] "parentEducationCollege"                       
##  [5] "parentEducationGraduate/professional school"  
##  [6] "income$25,001-$49,999"                        
##  [7] "income$50,000-$79,999"                        
##  [8] "income$80,000-$119,999"                       
##  [9] "income$120,000-$149,999"                      
## [10] "income$150,000 or more"                       
## [11] "ECBI_intensity_T_score"                       
## [12] "ECBI_problem_T_score"                         
## [13] "ECBI_Opp"                                     
## [14] "ECBI_Inatt"                                   
## [15] "ECBI_Cond"                                    
## [16] "MAPS_PP"                                      
## [17] "MAPS_PR"                                      
## [18] "MAPS_WM"                                      
## [19] "MAPS_SP"                                      
## [20] "MAPS_HS"                                      
## [21] "MAPS_LC"                                      
## [22] "MAPS_PC"                                      
## [23] "MAPS_POS"                                     
## [24] "MAPS_NEG"                                     
## [25] "SEPTI_nurturance"                             
## [26] "SEPTI_discipline"                             
## [27] "SEPTI_play"                                   
## [28] "SEPTI_routine"
```

```
##   cluster size ave.sil.width
## 1       1  305          0.30
## 2       2   37          0.18
## 3       3    3          0.32
```

* Hopkins statistic is 0.311
* Analysis identified $k = 3$ clusters
* Divisive coefficient is 0.809
* Average silhouette width is 0.290

![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-1.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-2.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 305|                        52.9|                      52.9|          32.7|            13.4|           14.7|
|2       |  37|                        61.3|                      62.0|          42.2|            15.1|           23.6|
|3       |   3|                        37.7|                      44.3|          17.7|             5.3|            8.0|



|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 305|          4.1|          4.6|          4.7|          4.5|          2.0|          1.9|          1.4|           4.5|           1.8|
|2       |  37|          3.5|          3.8|          3.9|          3.6|          3.0|          2.8|          2.4|           3.7|           2.7|
|3       |   3|          2.4|          2.9|          3.2|          2.1|          1.5|          1.9|          1.9|           2.7|           1.8|



|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 305|                  38.1|                  24.2|            32.6|               29.4|
|2       |  37|                  32.2|                  17.9|            25.1|               22.7|
|3       |   3|                  26.3|                  19.3|            25.7|               24.0|


|cluster |income            |  n|  pct|
|:-------|:-----------------|--:|----:|
|1       |$25,000 or less   | 29| 0.10|
|1       |$25,001-$49,999   | 72| 0.24|
|1       |$50,000-$79,999   | 82| 0.27|
|1       |$80,000-$119,999  | 53| 0.17|
|1       |$120,000-$149,999 | 24| 0.08|
|1       |$150,000 or more  | 45| 0.15|
|2       |$25,000 or less   |  4| 0.11|
|2       |$25,001-$49,999   | 11| 0.30|
|2       |$50,000-$79,999   |  9| 0.24|
|2       |$80,000-$119,999  |  2| 0.05|
|2       |$120,000-$149,999 |  8| 0.22|
|2       |$150,000 or more  |  3| 0.08|
|3       |$25,000 or less   |  2| 0.67|
|3       |$80,000-$119,999  |  1| 0.33|



|cluster |parentEducation                |   n|  pct|
|:-------|:------------------------------|---:|----:|
|1       |High school or less            |  37| 0.12|
|1       |Vocational school/some college |  57| 0.19|
|1       |College                        | 124| 0.41|
|1       |Graduate/professional school   |  87| 0.29|
|2       |High school or less            |   4| 0.11|
|2       |Vocational school/some college |  11| 0.30|
|2       |College                        |  12| 0.32|
|2       |Graduate/professional school   |  10| 0.27|
|3       |High school or less            |   1| 0.33|
|3       |College                        |   2| 0.67|



|cluster |parentRaceWhite |   n|  pct|
|:-------|:---------------|---:|----:|
|1       |0               |  54| 0.18|
|1       |1               | 251| 0.82|
|2       |0               |  24| 0.65|
|2       |1               |  13| 0.35|
|3       |1               |   3| 1.00|

**Clustering on ECBI, MAPS, and SEPTI metrics and a limited set of demographic factors is good.**

* Demographic factors considered
  * Income
  * Parent education level
  * Parent race, White/Non-White
* Cluster 1 ($n = 305$)
  * Majority White
  * Lower ECBI scores than Cluster 2
  * Higher positive MAPS scores than Cluster 2, lower negative MAPS scores than Cluster 2
  * Higher SEPTI scores than Cluster 2
* Cluster 2 ($n = 37$)
  * Majority non-White
  * High ECBI scores
  * Low positive MAPS scores, high negative MAPS scores
  * Low SEPTI scores
* Cluster 3 ($n = 3$)
  * Is a small outlier cluster
  * Middle income
  * Low ECBI scores
  * Low positive MAPS scores, low negative MAPS scores
* Removing income and parent education level produces better defined clusters
  * **See further analysis below**


```
## [1] 345  20
```

```
##  [1] "parentRaceWhite0"       "parentRaceWhite1"      
##  [3] "ECBI_intensity_T_score" "ECBI_problem_T_score"  
##  [5] "ECBI_Opp"               "ECBI_Inatt"            
##  [7] "ECBI_Cond"              "MAPS_PP"               
##  [9] "MAPS_PR"                "MAPS_WM"               
## [11] "MAPS_SP"                "MAPS_HS"               
## [13] "MAPS_LC"                "MAPS_PC"               
## [15] "MAPS_POS"               "MAPS_NEG"              
## [17] "SEPTI_nurturance"       "SEPTI_discipline"      
## [19] "SEPTI_play"             "SEPTI_routine"
```

```
##   cluster size ave.sil.width
## 1       1  306          0.31
## 2       2   14          0.17
## 3       3    3          0.28
## 4       4   22          0.21
```

* Hopkins statistic is 0.289
* Analysis identified $k = 4$ clusters
* Divisive coefficient is 0.848
* Average silhouette width is 0.297

![plot of chunk clusterXMetricsDemog2](figures/clusterXMetricsDemog2-1.png)![plot of chunk clusterXMetricsDemog2](figures/clusterXMetricsDemog2-2.png)![plot of chunk clusterXMetricsDemog2](figures/clusterXMetricsDemog2-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 306|                        52.9|                      53.0|          32.7|            13.4|           14.7|
|2       |  14|                        63.9|                      68.8|          46.3|            16.6|           22.4|
|3       |   3|                        37.7|                      44.3|          17.7|             5.3|            8.0|
|4       |  22|                        59.5|                      56.0|          39.0|            14.4|           24.4|



|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 306|          4.1|          4.6|          4.7|          4.5|          2.0|          1.9|          1.4|           4.5|           1.8|
|2       |  14|          4.0|          4.1|          4.1|          3.9|          3.2|          2.6|          2.4|           4.0|           2.7|
|3       |   3|          2.4|          2.9|          3.2|          2.1|          1.5|          1.9|          1.9|           2.7|           1.8|
|4       |  22|          3.2|          3.6|          3.8|          3.4|          2.8|          2.9|          2.3|           3.5|           2.7|



|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 306|                  38.1|                  24.2|            32.6|               29.3|
|2       |  14|                  34.1|                  15.9|            21.8|               21.6|
|3       |   3|                  26.3|                  19.3|            25.7|               24.0|
|4       |  22|                  30.8|                  18.9|            27.0|               23.5|


|cluster |parentRaceWhite |   n|  pct|
|:-------|:---------------|---:|----:|
|1       |0               |  53| 0.17|
|1       |1               | 253| 0.83|
|2       |0               |   4| 0.29|
|2       |1               |  10| 0.71|
|3       |1               |   3| 1.00|
|4       |0               |  21| 0.95|
|4       |1               |   1| 0.05|


|cluster |   n| PCB1_Total_mean| PCB1_CondEmot_mean| PCB1_DevHab_mean|
|:-------|---:|---------------:|------------------:|----------------:|
|1       | 306|            66.0|               47.7|             18.2|
|2       |  14|            73.1|               53.3|             19.8|
|3       |   3|            85.3|               62.3|             23.0|
|4       |  22|            71.8|               51.8|             20.0|



|cluster |   n| PCB2_Tot_mean|
|:-------|---:|-------------:|
|1       | 306|          24.4|
|2       |  14|          24.4|
|3       |   3|          27.3|
|4       |  22|          23.9|



|cluster |   n| PCB3_Total_mean| PCB3_PCPonly_mean| PCB3_Person_mean| PCB3_Resource_mean|
|:-------|---:|---------------:|-----------------:|----------------:|------------------:|
|1       | 306|            46.3|               4.1|             15.7|               26.6|
|2       |  14|            50.9|               4.1|             17.1|               29.6|
|3       |   3|            65.7|               4.7|             23.3|               37.7|
|4       |  22|            52.5|               4.1|             18.1|               30.2|

* Demographic factors considered
  * Parent race, White/Non-White
* Cluster 1 ($n = 306$)
  * Majority White
  * Lower ECBI scores than Clusters 2/4
  * Higher positive MAPS scores than Clusters 2/4, lower negative MAPS scores than Clusters 2/4
  * Higher SEPTI scores than Clusters 2/4
* Cluster 2 ($n = 14$)
  * Majority White, *more similar to Cluster 1*
  * High ECBI scores, *more similar to Cluster 4*
  * Low positive MAPS scores, high negative MAPS scores, *more similar to Cluster 4*
  * Low SEPTI scores, *more similar to Cluster 4*
* Cluster 3 ($n = 3$)
  * Is a small outlier cluster
  * Middle income
  * Low ECBI scores
  * Low positive MAPS scores, low negative MAPS scores
* Cluster 4 ($n = 14$)
  * Majority non-White
  * High ECBI scores
  * Low positive MAPS scores, high negative MAPS scores
  * Low SEPTI scores


## Cluster on PCB, ECBI, MAPS, SEPTI metrics and demographics


```
## [1] 345  28
```

```
##  [1] "parentRaceWhite0"       "parentRaceWhite1"      
##  [3] "ECBI_intensity_T_score" "ECBI_problem_T_score"  
##  [5] "ECBI_Opp"               "ECBI_Inatt"            
##  [7] "ECBI_Cond"              "MAPS_PP"               
##  [9] "MAPS_PR"                "MAPS_WM"               
## [11] "MAPS_SP"                "MAPS_HS"               
## [13] "MAPS_LC"                "MAPS_PC"               
## [15] "MAPS_POS"               "MAPS_NEG"              
## [17] "SEPTI_nurturance"       "SEPTI_discipline"      
## [19] "SEPTI_play"             "SEPTI_routine"         
## [21] "PCB1_Total"             "PCB1_CondEmot"         
## [23] "PCB1_DevHab"            "PCB2_Tot"              
## [25] "PCB3_Total"             "PCB3_PCPonly"          
## [27] "PCB3_Person"            "PCB3_Resource"
```

```
##   cluster size ave.sil.width
## 1       1  296          0.27
## 2       2   49          0.17
```

* Hopkins statistic is 0.314
* Analysis identified $k = 2$ clusters
* Divisive coefficient is 0.802
* Average silhouette width is 0.258

![plot of chunk clusterXY](figures/clusterXY-1.png)![plot of chunk clusterXY](figures/clusterXY-2.png)![plot of chunk clusterXY](figures/clusterXY-3.png)


|cluster |   n| ECBI_intensity_T_score_mean| ECBI_problem_T_score_mean| ECBI_Opp_mean| ECBI_Inatt_mean| ECBI_Cond_mean|
|:-------|---:|---------------------------:|-------------------------:|-------------:|---------------:|--------------:|
|1       | 296|                        52.8|                      52.6|          32.6|            13.3|           14.6|
|2       |  49|                        59.0|                      60.7|          39.5|            14.6|           21.8|



|cluster |   n| MAPS_PP_mean| MAPS_PR_mean| MAPS_WM_mean| MAPS_SP_mean| MAPS_HS_mean| MAPS_LC_mean| MAPS_PC_mean| MAPS_POS_mean| MAPS_NEG_mean|
|:-------|---:|------------:|------------:|------------:|------------:|------------:|------------:|------------:|-------------:|-------------:|
|1       | 296|          4.2|          4.6|          4.7|          4.5|          2.0|          1.9|          1.4|           4.5|           1.8|
|2       |  49|          3.5|          3.8|          4.0|          3.5|          2.8|          2.6|          2.3|           3.7|           2.6|



|cluster |   n| SEPTI_nurturance_mean| SEPTI_discipline_mean| SEPTI_play_mean| SEPTI_routine_mean|
|:-------|---:|---------------------:|---------------------:|---------------:|------------------:|
|1       | 296|                  38.2|                  24.3|            32.8|               29.5|
|2       |  49|                  32.3|                  18.6|            25.4|               22.9|


|cluster |parentRaceWhite |   n|  pct|
|:-------|:---------------|---:|----:|
|1       |0               |  52| 0.18|
|1       |1               | 244| 0.82|
|2       |0               |  26| 0.53|
|2       |1               |  23| 0.47|


|cluster |   n| PCB1_Total_mean| PCB1_CondEmot_mean| PCB1_DevHab_mean|
|:-------|---:|---------------:|------------------:|----------------:|
|1       | 296|            65.4|               47.3|             18.1|
|2       |  49|            75.0|               54.5|             20.5|



|cluster |   n| PCB2_Tot_mean|
|:-------|---:|-------------:|
|1       | 296|          24.3|
|2       |  49|          24.9|



|cluster |   n| PCB3_Total_mean| PCB3_PCPonly_mean| PCB3_Person_mean| PCB3_Resource_mean|
|:-------|---:|---------------:|-----------------:|----------------:|------------------:|
|1       | 296|            45.9|               4.1|             15.6|               26.3|
|2       |  49|            54.0|               4.3|             18.3|               31.4|


## Save objects


```
##                                          size isdir mode
## data/processed/clusterAnalysis.RData 15330777 FALSE  666
##                                                    mtime
## data/processed/clusterAnalysis.RData 2018-07-12 23:41:15
##                                                    ctime
## data/processed/clusterAnalysis.RData 2018-07-06 20:22:46
##                                                    atime exe
## data/processed/clusterAnalysis.RData 2018-07-12 21:54:36  no
```



