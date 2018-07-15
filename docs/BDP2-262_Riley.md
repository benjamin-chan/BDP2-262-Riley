---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-14"
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




## Cluster on ECBI, MAPS, SEPTI metrics and parent's race


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

![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-1.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-2.png)![plot of chunk clusterXMetricsDemog](figures/clusterXMetricsDemog-3.png)


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


## Save objects

Bind study ID, `id`, to cluster ID, `cluster`.




```
##                                                    mtime    size
## data/processed/clusterAnalysis.RData 2018-07-14 23:11:12 2599485
```

```
##                                                   mtime size
## data/processed/clusterCrosswalk.csv 2018-07-14 23:11:12 3062
```

```
##                                                   mtime size
## data/processed/clusterCrosswalk.sav 2018-07-14 23:11:12 6016
```



