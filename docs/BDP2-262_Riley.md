---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-05"
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





[https://uc-r.github.io/hc_clustering](https://uc-r.github.io/hc_clustering)
[http://www.sthda.com/english/wiki/factoextra-r-package-easy-multivariate-data-analyses-and-elegant-visualization](http://www.sthda.com/english/wiki/factoextra-r-package-easy-multivariate-data-analyses-and-elegant-visualization)


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




```
## [1] 345  63
```

```
## [1] 345  18
```

```
## [1] 345   8
```

```
## [1] 345  18
```

```
## NULL
```




## K-means clustering

![plot of chunk predictors_kmeans](figures/predictors_kmeans-1.png)![plot of chunk predictors_kmeans](figures/predictors_kmeans-2.png)

```
## Clustering k = 1,2,..., K.max (= 10): .. done
## Bootstrapping, b = 1,2,..., B (= 500)  [one "." per sample]:
## .................................................. 50 
## .................................................. 100 
## .................................................. 150 
## .................................................. 200 
## .................................................. 250 
## .................................................. 300 
## .................................................. 350 
## .................................................. 400 
## .................................................. 450 
## .................................................. 500
```

![plot of chunk predictors_kmeans](figures/predictors_kmeans-3.png)

```
## .
##   1   2 
## 206 139
```

![plot of chunk predictors_kmeans](figures/predictors_kmeans-4.png)

```
## Within cluster sum of squares, cluster 1: 2116.72
## Within cluster sum of squares, cluster 2: 2638.50
```

```
## Between SS / Total SS: 1436.78 / 6192.00 = 23.20%
```

```
## Total within SS: 4755.22
```



|                       |     1|     2|
|:----------------------|-----:|-----:|
|ECBI_intensity_T_score | -0.43|  0.63|
|ECBI_problem_T_score   | -0.42|  0.62|
|ECBI_Opp               | -0.43|  0.63|
|ECBI_Inatt             | -0.21|  0.31|
|ECBI_Cond              | -0.36|  0.53|
|MAPS_PP                |  0.33| -0.48|
|MAPS_PR                |  0.35| -0.52|
|MAPS_WM                |  0.34| -0.50|
|MAPS_SP                |  0.43| -0.64|
|MAPS_HS                | -0.43|  0.64|
|MAPS_LC                | -0.36|  0.54|
|MAPS_PC                | -0.30|  0.44|
|MAPS_POS               |  0.46| -0.68|
|MAPS_NEG               | -0.48|  0.71|
|SEPTI_nurturance       |  0.47| -0.69|
|SEPTI_discipline       |  0.45| -0.67|
|SEPTI_play             |  0.37| -0.55|
|SEPTI_routine          |  0.41| -0.61|


## Partitioning around medoids (PAM)

![plot of chunk predictors_pam](figures/predictors_pam-1.png)![plot of chunk predictors_pam](figures/predictors_pam-2.png)

```
## Clustering k = 1,2,..., K.max (= 10): .. done
## Bootstrapping, b = 1,2,..., B (= 500)  [one "." per sample]:
## .................................................. 50 
## .................................................. 100 
## .................................................. 150 
## .................................................. 200 
## .................................................. 250 
## .................................................. 300 
## .................................................. 350 
## .................................................. 400 
## .................................................. 450 
## .................................................. 500
```

![plot of chunk predictors_pam](figures/predictors_pam-3.png)

```
## .
##   1   2 
## 157 188
```

![plot of chunk predictors_pam](figures/predictors_pam-4.png)

| size| max_diss| av_diss| diameter| separation|
|----:|--------:|-------:|--------:|----------:|
|  157|    41.80|   14.97|    65.48|       6.16|
|  188|    23.96|   11.43|    36.86|       6.16|



|                       |   321|   298|
|:----------------------|-----:|-----:|
|ECBI_intensity_T_score |  0.19| -0.38|
|ECBI_problem_T_score   |  0.86| -0.71|
|ECBI_Opp               |  0.71| -0.06|
|ECBI_Inatt             | -0.60| -0.12|
|ECBI_Cond              | -0.09| -0.39|
|MAPS_PP                |  0.18|  0.77|
|MAPS_PR                |  0.01|  0.47|
|MAPS_WM                |  0.13|  0.78|
|MAPS_SP                | -0.63|  0.97|
|MAPS_HS                |  0.49| -0.42|
|MAPS_LC                |  0.43| -0.22|
|MAPS_PC                | -0.04| -0.74|
|MAPS_POS               | -0.12|  0.95|
|MAPS_NEG               |  0.38| -0.62|
|SEPTI_nurturance       | -0.35|  0.42|
|SEPTI_discipline       | -1.24|  0.90|
|SEPTI_play             | -1.11| -0.82|
|SEPTI_routine          | -0.51|  0.08|


## Agglomerative hierarchical clustering (AGNES)

![plot of chunk predictors_agnes](figures/predictors_agnes-1.png)

Correlation between cophenetic distance and the original distance is
0.417.

> The closer the value of the correlation coefficient is to 1, the more accurately the clustering solution reflects your data.
> Values above 0.75 are felt to be good.

Agglomerative coeffficient using the
Ward
method is
0.955.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  179          0.05
## 2       2  166          0.35
```

```
## .
##   1   2 
## 179 166
```

![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-1.png)![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-2.png)![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  142          0.06
## 2       2  166          0.26
## 3       3   37          0.14
```

```
## .
##   1   2   3 
## 142 166  37
```

![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-1.png)![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-2.png)![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-3.png)


## Divisive hierarchical clustering (DIANA)

![plot of chunk predictors_diana](figures/predictors_diana-1.png)

Divisive coefficient is
0.853.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  297          0.38
## 2       2   48          0.19
```

```
## .
##   1   2 
## 297  48
```

![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-1.png)![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-2.png)![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-3.png)

### $k = 3$ clusters


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

![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-1.png)![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-2.png)![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-3.png)

### $k = 4$ clusters


```
##   cluster size ave.sil.width
## 1       1  297          0.29
## 2       2   26          0.16
## 3       3    3          0.20
## 4       4   19          0.21
```

```
## .
##   1   2   3   4 
## 297  26   3  19
```

![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-1.png)![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-2.png)![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-3.png)

### $k = 5$ clusters


```
##   cluster size ave.sil.width
## 1       1  108          0.09
## 2       2  189          0.22
## 3       3   26          0.08
## 4       4    3          0.20
## 5       5   19          0.20
```

```
## .
##   1   2   3   4   5 
## 108 189  26   3  19
```

![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-1.png)![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-2.png)![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-3.png)


## Compare

Comparison between `agnes` and `diana` doesn't give much insight.

*Do not evaluate*




## Final cluster identification

Use DIANA, $k = 3$


```
## .
##   1   2   3 
## 297  45   3
```

![plot of chunk predictors_final_clustering](figures/predictors_final_clustering-1.png)![plot of chunk predictors_final_clustering](figures/predictors_final_clustering-2.png)![plot of chunk predictors_final_clustering](figures/predictors_final_clustering-3.png)



[https://uc-r.github.io/hc_clustering](https://uc-r.github.io/hc_clustering)
[http://www.sthda.com/english/wiki/factoextra-r-package-easy-multivariate-data-analyses-and-elegant-visualization](http://www.sthda.com/english/wiki/factoextra-r-package-easy-multivariate-data-analyses-and-elegant-visualization)


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




```
## [1] 345  63
```

```
## [1] 345  54
```

```
## [1] 345   6
```

```
## [1] 345   6
```

```
## NULL
```


## K-means clustering

![plot of chunk PCB_kmeans](figures/PCB_kmeans-1.png)![plot of chunk PCB_kmeans](figures/PCB_kmeans-2.png)

```
## Clustering k = 1,2,..., K.max (= 10): .. done
## Bootstrapping, b = 1,2,..., B (= 500)  [one "." per sample]:
## .................................................. 50 
## .................................................. 100 
## .................................................. 150 
## .................................................. 200 
## .................................................. 250 
## .................................................. 300 
## .................................................. 350 
## .................................................. 400 
## .................................................. 450 
## .................................................. 500
```

![plot of chunk PCB_kmeans](figures/PCB_kmeans-3.png)

```
## .
##  1  2  3  4  5 
## 67 96 19 76 87
```

![plot of chunk PCB_kmeans](figures/PCB_kmeans-4.png)

```
## Within cluster sum of squares, cluster 1: 232.49
## Within cluster sum of squares, cluster 2: 231.94
## Within cluster sum of squares, cluster 3: 72.29
## Within cluster sum of squares, cluster 4: 122.39
## Within cluster sum of squares, cluster 5: 237.95
```

```
## Between SS / Total SS: 1166.94 / 2064.00 = 56.54%
```

```
## Total within SS: 897.06
```



|              |     1|     2|     3|    4|     5|
|:-------------|-----:|-----:|-----:|----:|-----:|
|PCB1_CondEmot | -1.01| -0.10| -1.96| 0.90|  0.53|
|PCB1_DevHab   | -1.00| -0.14| -2.02| 0.96|  0.53|
|PCB2_Tot      | -0.66|  0.02| -2.36| 0.86|  0.26|
|PCB3_PCPonly  | -0.38| -0.14| -2.19| 0.62|  0.38|
|PCB3_Person   | -0.62|  0.48| -1.42| 0.80| -0.44|
|PCB3_Resource | -0.78|  0.66| -1.19| 0.89| -0.64|


## Partitioning around medoids (PAM)

![plot of chunk PCB_pam](figures/PCB_pam-1.png)![plot of chunk PCB_pam](figures/PCB_pam-2.png)

```
## Clustering k = 1,2,..., K.max (= 10): .. done
## Bootstrapping, b = 1,2,..., B (= 500)  [one "." per sample]:
## .................................................. 50 
## .................................................. 100 
## .................................................. 150 
## .................................................. 200 
## .................................................. 250 
## .................................................. 300 
## .................................................. 350 
## .................................................. 400 
## .................................................. 450 
## .................................................. 500
```

![plot of chunk PCB_pam](figures/PCB_pam-3.png)

```
## .
##   1   2 
## 193 152
```

![plot of chunk PCB_pam](figures/PCB_pam-4.png)

| size| max_diss| av_diss| diameter| separation|
|----:|--------:|-------:|--------:|----------:|
|  193|     7.04|    3.31|    13.49|       0.51|
|  152|    14.27|    4.48|    18.18|       0.51|



|              |  156|     4|
|:-------------|----:|-----:|
|PCB1_CondEmot | 0.59| -0.57|
|PCB1_DevHab   | 0.35| -0.33|
|PCB2_Tot      | 0.58| -0.52|
|PCB3_PCPonly  | 0.89| -0.09|
|PCB3_Person   | 0.22| -0.60|
|PCB3_Resource | 0.69| -0.81|


## Agglomerative hierarchical clustering (AGNES)

![plot of chunk PCB_agnes](figures/PCB_agnes-1.png)

Correlation between cophenetic distance and the original distance is
0.565.

> The closer the value of the correlation coefficient is to 1, the more accurately the clustering solution reflects your data.
> Values above 0.75 are felt to be good.

Agglomerative coeffficient using the
Ward
method is
0.980.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  265          0.39
## 2       2   80          0.25
```

```
## .
##   1   2 
## 265  80
```

![plot of chunk PCB_agnes_k2](figures/PCB_agnes_k2-1.png)![plot of chunk PCB_agnes_k2](figures/PCB_agnes_k2-2.png)![plot of chunk PCB_agnes_k2](figures/PCB_agnes_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  127          0.19
## 2       2  138          0.17
## 3       3   80          0.16
```

```
## .
##   1   2   3 
## 127 138  80
```

![plot of chunk PCB_agnes_k3](figures/PCB_agnes_k3-1.png)![plot of chunk PCB_agnes_k3](figures/PCB_agnes_k3-2.png)![plot of chunk PCB_agnes_k3](figures/PCB_agnes_k3-3.png)


## Divisive hierarchical clustering (DIANA)

![plot of chunk PCB_diana](figures/PCB_diana-1.png)

Divisive coefficient is
0.926.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  264          0.42
## 2       2   81          0.29
```

```
## .
##   1   2 
## 264  81
```

![plot of chunk PCB_diana_k2](figures/PCB_diana_k2-1.png)![plot of chunk PCB_diana_k2](figures/PCB_diana_k2-2.png)![plot of chunk PCB_diana_k2](figures/PCB_diana_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  264          0.30
## 2       2   59          0.28
## 3       3   22          0.23
```

```
## .
##   1   2   3 
## 264  59  22
```

![plot of chunk PCB_diana_k3](figures/PCB_diana_k3-1.png)![plot of chunk PCB_diana_k3](figures/PCB_diana_k3-2.png)![plot of chunk PCB_diana_k3](figures/PCB_diana_k3-3.png)

### $k = 4$ clusters


```
##   cluster size ave.sil.width
## 1       1  134          0.14
## 2       2  130          0.25
## 3       3   59          0.18
## 4       4   22          0.23
```

```
## .
##   1   2   3   4 
## 134 130  59  22
```

![plot of chunk PCB_diana_k4](figures/PCB_diana_k4-1.png)![plot of chunk PCB_diana_k4](figures/PCB_diana_k4-2.png)![plot of chunk PCB_diana_k4](figures/PCB_diana_k4-3.png)


## Final cluster identification

Use DIANA, $k = 2$


```
## .
##   1   2 
## 264  81
```

![plot of chunk PCB_final_clustering](figures/PCB_final_clustering-1.png)![plot of chunk PCB_final_clustering](figures/PCB_final_clustering-2.png)![plot of chunk PCB_final_clustering](figures/PCB_final_clustering-3.png)



