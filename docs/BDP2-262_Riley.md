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
## [1] 345  36
```

```
## [1] 345   8
```

```
## [1] 345 136
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
##  77 268
```

![plot of chunk predictors_kmeans](figures/predictors_kmeans-4.png)

```
## Within cluster sum of squares, cluster 1: 13573.82
## Within cluster sum of squares, cluster 2: 31702.60
```

```
## Between SS / Total SS: 1507.59 / 46784.00 = 3.22%
```

```
## Total within SS: 45276.41
```



|                                                                             |     1|     2|
|:----------------------------------------------------------------------------|-----:|-----:|
|languageSurveyEnglish                                                        |  0.05| -0.02|
|languageSurveySpanish                                                        | -0.05|  0.02|
|totalChildren                                                                | -0.16|  0.04|
|birthOrderOldest                                                             | -0.19|  0.05|
|birthOrderMiddle                                                             | -0.10|  0.03|
|birthOrderYoungest                                                           |  0.12| -0.03|
|childSexMale                                                                 | -0.12|  0.04|
|childAge                                                                     | -0.05|  0.02|
|childEthnicityNot Hispanic/Latino                                            | -0.72|  0.21|
|childEthnicityUnknown                                                        | -0.13|  0.04|
|childEthnicityPrefer not to respond                                          |  0.89| -0.26|
|childRaceWhite1                                                              | -1.67|  0.48|
|childRaceAsian1                                                              |  0.93| -0.27|
|childRaceAfrAm1                                                              |  0.21| -0.06|
|childRaceAIAN1                                                               | -0.07|  0.02|
|childRaceNHPI1                                                               |  0.04| -0.01|
|childRaceOther1                                                              |  0.55| -0.16|
|childRaceNoResp1                                                             |  0.95| -0.27|
|childRelationshipBiological or adoptive father                               |  0.11| -0.03|
|childRelationshipGrandparent                                                 | -0.05|  0.02|
|childRelationshipOther                                                       |  0.27| -0.08|
|parentGenderFemale                                                           | -0.18|  0.05|
|parentGenderTransgender                                                      | -0.05|  0.02|
|parentGenderOther                                                            |  0.19| -0.05|
|parentGenderPrefer not to respond                                            |  0.05| -0.01|
|parentSexMale                                                                |  0.14| -0.04|
|parentAge                                                                    |  0.19| -0.05|
|parentEthnicityNot Hispanic/Latino                                           | -0.82|  0.24|
|parentEthnicityUnknown                                                       |  0.07| -0.02|
|parentEthnicityPrefer not to respond                                         |  0.85| -0.25|
|parentRaceWhite1                                                             | -1.72|  0.50|
|parentRaceAsian1                                                             |  1.02| -0.29|
|parentRaceAfrAm1                                                             |  0.26| -0.08|
|parentRaceAIAN1                                                              | -0.07|  0.02|
|parentRaceNHPI1                                                              | -0.05|  0.01|
|parentRaceOther1                                                             |  0.66| -0.19|
|parentRaceNoResp1                                                            |  0.93| -0.27|
|parentMaritalStatusWidowed                                                   | -0.05|  0.02|
|parentMaritalStatusDivorced                                                  |  0.15| -0.04|
|parentMaritalStatusSeparated                                                 | -0.13|  0.04|
|parentMaritalStatusRemarried                                                 |  0.01|  0.00|
|parentMaritalStatusNever married                                             | -0.14|  0.04|
|parentSituationCouple parenting with spouse or partner in the same household |  0.11| -0.03|
|parentSituationCo-parenting in separate households                           |  0.01|  0.00|
|parentsNumber                                                                |  0.11| -0.03|
|parentChildRatio                                                             |  0.21| -0.06|
|zipcodeClass2                                                                | -0.38|  0.11|
|zipcode91020                                                                 |  0.19| -0.05|
|zipcode91204                                                                 |  0.19| -0.05|
|zipcode91206                                                                 |  0.19| -0.05|
|zipcode91210                                                                 |  0.19| -0.05|
|zipcode91402                                                                 |  0.19| -0.05|
|zipcode97003                                                                 | -0.09|  0.03|
|zipcode97006                                                                 |  0.21| -0.06|
|zipcode97007                                                                 |  0.09| -0.03|
|zipcode97008                                                                 |  0.07| -0.02|
|zipcode97023                                                                 | -0.05|  0.02|
|zipcode97027                                                                 |  0.27| -0.08|
|zipcode97032                                                                 | -0.05|  0.02|
|zipcode97034                                                                 | -0.08|  0.02|
|zipcode97035                                                                 | -0.05|  0.02|
|zipcode97045                                                                 | -0.05|  0.02|
|zipcode97056                                                                 | -0.05|  0.02|
|zipcode97060                                                                 | -0.05|  0.02|
|zipcode97062                                                                 |  0.19| -0.05|
|zipcode97068                                                                 | -0.05|  0.02|
|zipcode97071                                                                 | -0.08|  0.02|
|zipcode97078                                                                 | -0.08|  0.02|
|zipcode97086                                                                 | -0.05|  0.02|
|zipcode97089                                                                 |  0.09| -0.03|
|zipcode97101                                                                 | -0.05|  0.02|
|zipcode97116                                                                 |  0.09| -0.03|
|zipcode97123                                                                 | -0.09|  0.03|
|zipcode97124                                                                 |  0.10| -0.03|
|zipcode97140                                                                 |  0.09| -0.03|
|zipcode97141                                                                 | -0.05|  0.02|
|zipcode97201                                                                 |  0.13| -0.04|
|zipcode97202                                                                 |  0.06| -0.02|
|zipcode97203                                                                 |  0.19| -0.05|
|zipcode97206                                                                 | -0.14|  0.04|
|zipcode97209                                                                 |  0.19| -0.05|
|zipcode97210                                                                 | -0.05|  0.02|
|zipcode97211                                                                 |  0.13| -0.04|
|zipcode97212                                                                 |  0.01|  0.00|
|zipcode97213                                                                 | -0.09|  0.03|
|zipcode97214                                                                 | -0.12|  0.03|
|zipcode97215                                                                 | -0.05|  0.02|
|zipcode97217                                                                 |  0.19| -0.05|
|zipcode97219                                                                 |  0.04| -0.01|
|zipcode97220                                                                 | -0.08|  0.02|
|zipcode97221                                                                 |  0.09| -0.03|
|zipcode97222                                                                 |  0.05| -0.01|
|zipcode97223                                                                 |  0.20| -0.06|
|zipcode97224                                                                 | -0.08|  0.02|
|zipcode97225                                                                 | -0.01|  0.00|
|zipcode97227                                                                 |  0.19| -0.05|
|zipcode97229                                                                 |  0.35| -0.10|
|zipcode97230                                                                 |  0.09| -0.03|
|zipcode97232                                                                 | -0.08|  0.02|
|zipcode97233                                                                 |  0.27| -0.08|
|zipcode97236                                                                 | -0.05|  0.02|
|zipcode97239                                                                 |  0.04| -0.01|
|zipcode97266                                                                 |  0.19| -0.05|
|zipcode97267                                                                 | -0.09|  0.03|
|zipcode97321                                                                 | -0.05|  0.02|
|zipcode97325                                                                 | -0.05|  0.02|
|zipcode97429                                                                 | -0.05|  0.02|
|zipcode97527                                                                 | -0.08|  0.02|
|zipcode97701                                                                 | -0.21|  0.06|
|zipcode97702                                                                 | -0.21|  0.06|
|zipcode97703                                                                 | -0.10|  0.03|
|zipcode97707                                                                 | -0.05|  0.02|
|zipcode97734                                                                 |  0.05| -0.01|
|zipcode97738                                                                 | -0.05|  0.02|
|zipcode97741                                                                 | -0.17|  0.05|
|zipcode97753                                                                 | -0.09|  0.03|
|zipcode97754                                                                 | -0.15|  0.04|
|zipcode97756                                                                 | -0.21|  0.06|
|zipcode97759                                                                 | -0.08|  0.02|
|zipcode97760                                                                 |  0.05| -0.01|
|zipcode98632                                                                 | -0.05|  0.02|
|zipcode98660                                                                 | -0.05|  0.02|
|zipcode98683                                                                 | -0.05|  0.02|
|zipcode98685                                                                 |  0.19| -0.05|
|communitySuburban                                                            |  0.10| -0.03|
|communityRural                                                               | -0.35|  0.10|
|distance                                                                     | -0.16|  0.04|
|parentEducationVocational school/some college                                | -0.14|  0.04|
|parentEducationCollege                                                       |  0.06| -0.02|
|parentEducationGraduate/professional school                                  |  0.07| -0.02|
|income$25,001-$49,999                                                        | -0.05|  0.01|
|income$50,000-$79,999                                                        | -0.10|  0.03|
|income$80,000-$119,999                                                       | -0.16|  0.05|
|income$120,000-$149,999                                                      |  0.22| -0.06|
|income$150,000 or more                                                       |  0.16| -0.05|
|internet                                                                     |  0.00|  0.00|


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
## 161 184
```

![plot of chunk predictors_pam](figures/predictors_pam-4.png)

| size| max_diss| av_diss| diameter| separation|
|----:|--------:|-------:|--------:|----------:|
|  161|    76.69|   31.48|   120.59|       3.26|
|  184|    84.86|   31.77|   128.89|       3.26|



|                                                                             |    50|   194|
|:----------------------------------------------------------------------------|-----:|-----:|
|languageSurveyEnglish                                                        |  0.05|  0.05|
|languageSurveySpanish                                                        | -0.05| -0.05|
|totalChildren                                                                | -0.99| -0.06|
|birthOrderOldest                                                             | -0.62|  1.61|
|birthOrderMiddle                                                             | -0.38| -0.38|
|birthOrderYoungest                                                           | -0.61| -0.61|
|childSexMale                                                                 |  0.92| -1.09|
|childAge                                                                     | -1.00| -0.31|
|childEthnicityNot Hispanic/Latino                                            |  0.54|  0.54|
|childEthnicityUnknown                                                        | -0.13| -0.13|
|childEthnicityPrefer not to respond                                          | -0.29| -0.29|
|childRaceWhite1                                                              |  0.49|  0.49|
|childRaceAsian1                                                              | -0.34| -0.34|
|childRaceAfrAm1                                                              | -0.20| -0.20|
|childRaceAIAN1                                                               | -0.15| -0.15|
|childRaceNHPI1                                                               | -0.14| -0.14|
|childRaceOther1                                                              | -0.21| -0.21|
|childRaceNoResp1                                                             | -0.27| -0.27|
|childRelationshipBiological or adoptive father                               | -0.39| -0.39|
|childRelationshipGrandparent                                                 | -0.05| -0.05|
|childRelationshipOther                                                       | -0.08| -0.08|
|parentGenderFemale                                                           |  0.44|  0.44|
|parentGenderTransgender                                                      | -0.05| -0.05|
|parentGenderOther                                                            | -0.05| -0.05|
|parentGenderPrefer not to respond                                            | -0.09| -0.09|
|parentSexMale                                                                | -0.41| -0.41|
|parentAge                                                                    | -1.09| -1.09|
|parentEthnicityNot Hispanic/Latino                                           |  0.48|  0.48|
|parentEthnicityUnknown                                                       | -0.13| -0.13|
|parentEthnicityPrefer not to respond                                         | -0.26| -0.26|
|parentRaceWhite1                                                             |  0.54|  0.54|
|parentRaceAsian1                                                             | -0.35| -0.35|
|parentRaceAfrAm1                                                             | -0.13| -0.13|
|parentRaceAIAN1                                                              | -0.15| -0.15|
|parentRaceNHPI1                                                              | -0.14| -0.14|
|parentRaceOther1                                                             | -0.19| -0.19|
|parentRaceNoResp1                                                            | -0.27| -0.27|
|parentMaritalStatusWidowed                                                   | -0.05| -0.05|
|parentMaritalStatusDivorced                                                  | -0.22| -0.22|
|parentMaritalStatusSeparated                                                 | -0.13| -0.13|
|parentMaritalStatusRemarried                                                 | -0.11| -0.11|
|parentMaritalStatusNever married                                             | -0.43| -0.43|
|parentSituationCouple parenting with spouse or partner in the same household |  0.38|  0.38|
|parentSituationCo-parenting in separate households                           | -0.20| -0.20|
|parentsNumber                                                                |  0.38|  0.38|
|parentChildRatio                                                             |  1.47| -0.26|
|zipcodeClass2                                                                |  1.62| -0.62|
|zipcode91020                                                                 | -0.05| -0.05|
|zipcode91204                                                                 | -0.05| -0.05|
|zipcode91206                                                                 | -0.05| -0.05|
|zipcode91210                                                                 | -0.05| -0.05|
|zipcode91402                                                                 | -0.05| -0.05|
|zipcode97003                                                                 | -0.09| -0.09|
|zipcode97006                                                                 | -0.20| -0.20|
|zipcode97007                                                                 | -0.08| -0.08|
|zipcode97008                                                                 | -0.13| -0.13|
|zipcode97023                                                                 | -0.05| -0.05|
|zipcode97027                                                                 | -0.08| -0.08|
|zipcode97032                                                                 | -0.05| -0.05|
|zipcode97034                                                                 | -0.08| -0.08|
|zipcode97035                                                                 | -0.05| -0.05|
|zipcode97045                                                                 | -0.05| -0.05|
|zipcode97056                                                                 | -0.05| -0.05|
|zipcode97060                                                                 | -0.05| -0.05|
|zipcode97062                                                                 | -0.05| -0.05|
|zipcode97068                                                                 | -0.05| -0.05|
|zipcode97071                                                                 | -0.08| -0.08|
|zipcode97078                                                                 | -0.08| -0.08|
|zipcode97086                                                                 | -0.05| -0.05|
|zipcode97089                                                                 | -0.08| -0.08|
|zipcode97101                                                                 | -0.05| -0.05|
|zipcode97116                                                                 | -0.08| -0.08|
|zipcode97123                                                                 | -0.09| -0.09|
|zipcode97124                                                                 | -0.12| -0.12|
|zipcode97140                                                                 | -0.08| -0.08|
|zipcode97141                                                                 | -0.05| -0.05|
|zipcode97201                                                                 | -0.11| -0.11|
|zipcode97202                                                                 | -0.21| -0.21|
|zipcode97203                                                                 | -0.05| -0.05|
|zipcode97206                                                                 | -0.14| -0.14|
|zipcode97209                                                                 | -0.09| -0.09|
|zipcode97210                                                                 | -0.05| -0.05|
|zipcode97211                                                                 | -0.11| -0.11|
|zipcode97212                                                                 | -0.11| -0.11|
|zipcode97213                                                                 | -0.09| -0.09|
|zipcode97214                                                                 | -0.12| -0.12|
|zipcode97215                                                                 | -0.05| -0.05|
|zipcode97217                                                                 | -0.09| -0.09|
|zipcode97219                                                                 | -0.18| -0.18|
|zipcode97220                                                                 | -0.08| -0.08|
|zipcode97221                                                                 | -0.08| -0.08|
|zipcode97222                                                                 | -0.09| -0.09|
|zipcode97223                                                                 | -0.12| -0.12|
|zipcode97224                                                                 | -0.08| -0.08|
|zipcode97225                                                                 | -0.12| -0.12|
|zipcode97227                                                                 | -0.05| -0.05|
|zipcode97229                                                                 | -0.20| -0.20|
|zipcode97230                                                                 | -0.08| -0.08|
|zipcode97232                                                                 | -0.08| -0.08|
|zipcode97233                                                                 | -0.08| -0.08|
|zipcode97236                                                                 | -0.05| -0.05|
|zipcode97239                                                                 | -0.18| -0.18|
|zipcode97266                                                                 | -0.05| -0.05|
|zipcode97267                                                                 | -0.09| -0.09|
|zipcode97321                                                                 | -0.05| -0.05|
|zipcode97325                                                                 | -0.05| -0.05|
|zipcode97429                                                                 | -0.05| -0.05|
|zipcode97527                                                                 | -0.08| -0.08|
|zipcode97701                                                                 | -0.37|  2.72|
|zipcode97702                                                                 | -0.26| -0.26|
|zipcode97703                                                                 | -0.17| -0.17|
|zipcode97707                                                                 | -0.05| -0.05|
|zipcode97734                                                                 | -0.09| -0.09|
|zipcode97738                                                                 | -0.05| -0.05|
|zipcode97741                                                                 | -0.17| -0.17|
|zipcode97753                                                                 | -0.09| -0.09|
|zipcode97754                                                                 | -0.15| -0.15|
|zipcode97756                                                                 |  2.34| -0.43|
|zipcode97759                                                                 | -0.08| -0.08|
|zipcode97760                                                                 | -0.09| -0.09|
|zipcode98632                                                                 | -0.05| -0.05|
|zipcode98660                                                                 | -0.05| -0.05|
|zipcode98683                                                                 | -0.05| -0.05|
|zipcode98685                                                                 | -0.05| -0.05|
|communitySuburban                                                            |  1.09|  1.09|
|communityRural                                                               | -0.48| -0.48|
|distance                                                                     | -0.20| -0.34|
|parentEducationVocational school/some college                                | -0.49| -0.49|
|parentEducationCollege                                                       | -0.82|  1.22|
|parentEducationGraduate/professional school                                  | -0.62| -0.62|
|income$25,001-$49,999                                                        | -0.56|  1.77|
|income$50,000-$79,999                                                        |  1.67| -0.60|
|income$80,000-$119,999                                                       | -0.44| -0.44|
|income$120,000-$149,999                                                      | -0.32| -0.32|
|income$150,000 or more                                                       | -0.40| -0.40|
|internet                                                                     |  0.16|  0.16|


## Agglomerative hierarchical clustering (AGNES)

![plot of chunk predictors_agnes](figures/predictors_agnes-1.png)

Correlation between cophenetic distance and the original distance is
0.452.

> The closer the value of the correlation coefficient is to 1, the more accurately the clustering solution reflects your data.
> Values above 0.75 are felt to be good.

Agglomerative coeffficient using the
Ward
method is
0.922.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  303          0.27
## 2       2   42          0.06
```

```
## .
##   1   2 
## 303  42
```

![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-1.png)![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-2.png)![plot of chunk predictors_agnes_k2](figures/predictors_agnes_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  196          0.10
## 2       2  107          0.06
## 3       3   42          0.04
```

```
## .
##   1   2   3 
## 196 107  42
```

![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-1.png)![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-2.png)![plot of chunk predictors_agnes_k3](figures/predictors_agnes_k3-3.png)


## Divisive hierarchical clustering (DIANA)

![plot of chunk predictors_diana](figures/predictors_diana-1.png)

Divisive coefficient is
0.809.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  344          0.51
## 2       2    1          0.00
```

```
## .
##   1   2 
## 344   1
```

![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-1.png)![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-2.png)![plot of chunk predictors_diana_k2](figures/predictors_diana_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  308          0.31
## 2       2   36          0.07
## 3       3    1          0.00
```

```
## .
##   1   2   3 
## 308  36   1
```

![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-1.png)![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-2.png)![plot of chunk predictors_diana_k3](figures/predictors_diana_k3-3.png)

### $k = 4$ clusters


```
##   cluster size ave.sil.width
## 1       1  308          0.27
## 2       2   12          0.14
## 3       3   24          0.23
## 4       4    1          0.00
```

```
## .
##   1   2   3   4 
## 308  12  24   1
```

![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-1.png)![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-2.png)![plot of chunk predictors_diana_k4](figures/predictors_diana_k4-3.png)

### $k = 5$ clusters


```
##   cluster size ave.sil.width
## 1       1  299          0.27
## 2       2    9          0.07
## 3       3   12          0.13
## 4       4   24          0.22
## 5       5    1          0.00
```

```
## .
##   1   2   3   4   5 
## 299   9  12  24   1
```

![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-1.png)![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-2.png)![plot of chunk predictors_diana_k5](figures/predictors_diana_k5-3.png)


## Compare

Comparison between `agnes` and `diana` doesn't give much insight.

*Do not evaluate*




## Final cluster identification

Use DIANA, $k = 2$


```
## .
##   1   2 
## 344   1
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



