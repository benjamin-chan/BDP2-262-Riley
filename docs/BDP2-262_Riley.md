---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-06"
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


```
##    PCB1_Total       PCB2_Tot       PCB3_Total   
##  Min.   :18.00   Min.   : 6.00   Min.   :15.00  
##  1st Qu.:58.00   1st Qu.:22.00   1st Qu.:39.00  
##  Median :71.00   Median :25.00   Median :48.00  
##  Mean   :67.85   Mean   :24.53   Mean   :47.58  
##  3rd Qu.:81.00   3rd Qu.:28.00   3rd Qu.:57.00  
##  Max.   :90.00   Max.   :30.00   Max.   :75.00
```

![figures/flowChart.png](figures/flowChart.png)





# Cluster analysis

Use divisive hierarchical clustering (DIANA).
See [Divisive Hierarchical Clustering Essentials](http://www.sthda.com/english/articles/28-hierarchical-clustering-essentials/94-divisive-hierarchical-clustering-essentials/).


```
## Warning: package 'cluster' was built under R version 3.4.4
```

```
## Warning: package 'ggdendro' was built under R version 3.4.4
```

```
## Warning: package 'factoextra' was built under R version 3.4.4
```

```
## Welcome! Related Books: `Practical Guide To Cluster Analysis in R` at https://goo.gl/13EFCZ
```

```
## Warning: package 'dendextend' was built under R version 3.4.4
```

```
## 
## ---------------------
## Welcome to dendextend version 1.8.0
## Type citation('dendextend') for how to cite the package.
## 
## Type browseVignettes(package = 'dendextend') for the package vignette.
## The github page is: https://github.com/talgalili/dendextend/
## 
## Suggestions and bug-reports can be submitted at: https://github.com/talgalili/dendextend/issues
## Or contact: <tal.galili@gmail.com>
## 
## 	To suppress this message use:  suppressPackageStartupMessages(library(dendextend))
## ---------------------
```

```
## 
## Attaching package: 'dendextend'
```

```
## The following object is masked from 'package:ggdendro':
## 
##     theme_dendro
```

```
## The following object is masked from 'package:stats':
## 
##     cutree
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


```
## [1] 345   8
```

```
## NULL
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

```
## .
##   1   2 
## 253  92
```

![plot of chunk clusterYPCB](figures/clusterYPCB-1.png)![plot of chunk clusterYPCB](figures/clusterYPCB-2.png)![plot of chunk clusterYPCB](figures/clusterYPCB-3.png)

* Hopkins statistic is 0.254
* Analysis identified $k = 2$ clusters
* Divisive coefficient is 0.929
* Average silhouette width is 0.394


## Cluster on ECBI, MAPS, SEPTI metrics


```
## [1] 345  18
```

```
## NULL
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

```
## .
##   1   2   3 
## 297  45   3
```

![plot of chunk clusterXMetrics](figures/clusterXMetrics-1.png)![plot of chunk clusterXMetrics](figures/clusterXMetrics-2.png)![plot of chunk clusterXMetrics](figures/clusterXMetrics-3.png)

* Hopkins statistic is 0.288
* Analysis identified $k = 3$ clusters
* Divisive coefficient is 0.853
* Average silhouette width is 0.340


## Cluster on parent/child factors


```
## [1] 345  48
```

```
## NULL
```

```
##  [1] "totalChildren"                                                               
##  [2] "birthOrderOnly child"                                                        
##  [3] "birthOrderOldest"                                                            
##  [4] "birthOrderMiddle"                                                            
##  [5] "birthOrderYoungest"                                                          
##  [6] "childSexMale"                                                                
##  [7] "childAge"                                                                    
##  [8] "childEthnicityNot Hispanic/Latino"                                           
##  [9] "childEthnicityUnknown"                                                       
## [10] "childEthnicityPrefer not to respond"                                         
## [11] "childRaceWhite1"                                                             
## [12] "childRaceAsian1"                                                             
## [13] "childRaceAfrAm1"                                                             
## [14] "childRaceAIAN1"                                                              
## [15] "childRaceNHPI1"                                                              
## [16] "childRaceOther1"                                                             
## [17] "childRaceNoResp1"                                                            
## [18] "childRelationshipBiological or adoptive father"                              
## [19] "childRelationshipGrandparent"                                                
## [20] "childRelationshipOther"                                                      
## [21] "parentGenderFemale"                                                          
## [22] "parentGenderTransgender"                                                     
## [23] "parentGenderOther"                                                           
## [24] "parentGenderPrefer not to respond"                                           
## [25] "parentSexMale"                                                               
## [26] "parentAge"                                                                   
## [27] "parentEthnicityNot Hispanic/Latino"                                          
## [28] "parentEthnicityUnknown"                                                      
## [29] "parentEthnicityPrefer not to respond"                                        
## [30] "parentRaceWhite1"                                                            
## [31] "parentRaceAsian1"                                                            
## [32] "parentRaceAfrAm1"                                                            
## [33] "parentRaceAIAN1"                                                             
## [34] "parentRaceNHPI1"                                                             
## [35] "parentRaceOther1"                                                            
## [36] "parentRaceNoResp1"                                                           
## [37] "parentMaritalStatusWidowed"                                                  
## [38] "parentMaritalStatusDivorced"                                                 
## [39] "parentMaritalStatusSeparated"                                                
## [40] "parentMaritalStatusRemarried"                                                
## [41] "parentMaritalStatusNever married"                                            
## [42] "parentSituationCouple parenting with spouse or partner in the same household"
## [43] "parentSituationCo-parenting in separate households"                          
## [44] "parentsNumber"                                                               
## [45] "parentChildRatio"                                                            
## [46] "parentEducationVocational school/some college"                               
## [47] "parentEducationCollege"                                                      
## [48] "parentEducationGraduate/professional school"
```

```
##   cluster size ave.sil.width
## 1       1  281          0.36
## 2       2   37          0.11
## 3       3   26          0.27
## 4       4    1          0.00
```

```
## .
##   1   2   3   4 
## 281  37  26   1
```

![plot of chunk clusterXParentChild](figures/clusterXParentChild-1.png)![plot of chunk clusterXParentChild](figures/clusterXParentChild-2.png)![plot of chunk clusterXParentChild](figures/clusterXParentChild-3.png)

* Hopkins statistic is 0.109
* Analysis identified $k = 4$ clusters
* Divisive coefficient is 0.904
* Average silhouette width is 0.329



|cluster | totalChildren|birthOrder |  n|
|:-------|-------------:|:----------|--:|
|1       |             1|Only child | 92|
|1       |             2|Oldest     | 70|
|1       |             2|Middle     |  3|
|1       |             2|Youngest   | 49|
|1       |             3|Oldest     | 14|
|1       |             3|Middle     | 18|
|1       |             3|Youngest   | 10|
|1       |             4|Middle     |  9|
|1       |             4|Youngest   |  6|
|1       |             5|Middle     |  6|
|1       |             5|Youngest   |  1|
|1       |             6|Middle     |  2|
|1       |             7|Youngest   |  1|
|2       |             1|Only child | 11|
|2       |             2|Oldest     |  8|
|2       |             2|Youngest   |  6|
|2       |             3|Oldest     |  1|
|2       |             3|Middle     |  2|
|2       |             3|Youngest   |  5|
|2       |             4|Middle     |  2|
|2       |             4|Youngest   |  1|
|2       |             6|Youngest   |  1|
|3       |             1|Only child |  9|
|3       |             2|Oldest     |  2|
|3       |             2|Middle     |  1|
|3       |             2|Youngest   | 11|
|3       |             3|Youngest   |  1|
|3       |             5|Oldest     |  1|
|3       |             5|Youngest   |  1|
|4       |             5|Youngest   |  1|


## Cluster on demographic factors


```
## [1] 345  88
```

```
## NULL
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

```
## .
##   1   2   3   4 
## 249  93   2   1
```

![plot of chunk clusterXDemog](figures/clusterXDemog-1.png)![plot of chunk clusterXDemog](figures/clusterXDemog-2.png)![plot of chunk clusterXDemog](figures/clusterXDemog-3.png)

* Hopkins statistic is 0.041
* Analysis identified $k = 4$ clusters
* Divisive coefficient is 0.878
* Average silhouette width is 0.231


|cluster |zipcodeClass |community |distanceLong |   n|
|:-------|:------------|:---------|:------------|---:|
|1       |1            |Urban     |FALSE        | 109|
|1       |1            |Suburban  |FALSE        | 128|
|1       |1            |Rural     |FALSE        |  12|
|2       |2            |Urban     |FALSE        |  13|
|2       |2            |Suburban  |FALSE        |  29|
|2       |2            |Suburban  |TRUE         |   1|
|2       |2            |Rural     |FALSE        |  50|
|3       |2            |Rural     |TRUE         |   2|
|4       |1            |Rural     |FALSE        |   1|



|cluster |zipcodeClass |income            |  n|
|:-------|:------------|:-----------------|--:|
|1       |1            |$25,000 or less   | 25|
|1       |1            |$25,001-$49,999   | 57|
|1       |1            |$50,000-$79,999   | 58|
|1       |1            |$80,000-$119,999  | 38|
|1       |1            |$120,000-$149,999 | 27|
|1       |1            |$150,000 or more  | 44|
|2       |2            |$25,000 or less   | 10|
|2       |2            |$25,001-$49,999   | 26|
|2       |2            |$50,000-$79,999   | 31|
|2       |2            |$80,000-$119,999  | 17|
|2       |2            |$120,000-$149,999 |  5|
|2       |2            |$150,000 or more  |  4|
|3       |2            |$50,000-$79,999   |  1|
|3       |2            |$80,000-$119,999  |  1|
|4       |1            |$50,000-$79,999   |  1|



|cluster |zipcodeClass | internet|   n|
|:-------|:------------|--------:|---:|
|1       |1            |        0|   4|
|1       |1            |        1| 245|
|2       |2            |        0|   4|
|2       |2            |        1|  89|
|3       |2            |        1|   2|
|4       |1            |        0|   1|


## Save objects


```
##                                          size isdir mode
## data/processed/clusterAnalysis.RData 10004125 FALSE  666
##                                                    mtime
## data/processed/clusterAnalysis.RData 2018-07-06 15:36:38
##                                                    ctime
## data/processed/clusterAnalysis.RData 2018-07-06 12:14:44
##                                                    atime exe
## data/processed/clusterAnalysis.RData 2018-07-06 12:14:44  no
```



