---
title: "Parent and Provider Perceptions of Behavioral Healthcare in Pediatric Primary Care (PI: Andrew Riley; BDP2-262)"
date: "2018-07-02"
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
## [1] 345   8
```

```
## [1] 345 154
```

```
## NULL
```




## K-means clustering

![plot of chunk kmeans](figures/kmeans-1.png)![plot of chunk kmeans](figures/kmeans-2.png)

```
## Clustering k = 1,2,..., K.max (= 10): .. done
## Bootstrapping, b = 1,2,..., B (= 500)  [one "." per sample]:
## ...................
```

```
## Warning: did not converge in 10 iterations
```

```
## ............................... 50 
## .................................................. 100 
## .................................................. 150 
## .................................................. 200 
## .................................................. 250 
## .................................................. 300 
## .................................................. 350 
## .................................................. 400 
## ......
```

```
## Warning: did not converge in 10 iterations
```

```
## ............................................ 450 
## .................................................. 500
```

![plot of chunk kmeans](figures/kmeans-3.png)

```
## .
##   1   2   3   4   5   6   7 
##  41  35  66 101  69   5  28
```

![plot of chunk kmeans](figures/kmeans-4.png)

|var                                                                          | cluster1| cluster2| cluster3| cluster4| cluster5| cluster6| cluster7|
|:----------------------------------------------------------------------------|--------:|--------:|--------:|--------:|--------:|--------:|--------:|
|birthOrderMiddle                                                             |    -0.01|    -0.03|     0.22|    -0.17|     0.11|    -0.38|    -0.05|
|birthOrderOldest                                                             |     0.36|    -0.17|     0.09|    -0.20|     0.25|    -0.62|    -0.30|
|birthOrderYoungest                                                           |    -0.12|     0.22|    -0.07|    -0.03|    -0.06|    -0.61|     0.43|
|childAge                                                                     |     0.21|     0.21|     0.11|    -0.45|     0.51|    -1.34|    -0.24|
|childEthnicityNot.Hispanic.Latino                                            |     0.43|    -0.47|     0.15|     0.31|     0.13|     0.07|    -1.83|
|childEthnicityPrefer.not.to.respond                                          |    -0.29|    -0.18|    -0.23|    -0.25|    -0.29|    -0.29|     2.82|
|childEthnicityUnknown                                                        |    -0.13|     0.52|    -0.13|     0.02|    -0.13|     1.39|    -0.13|
|childRaceAfrAm1                                                              |     0.31|     0.10|    -0.20|    -0.04|     0.11|    -0.20|    -0.20|
|childRaceAIAN1                                                               |    -0.15|     0.41|    -0.05|    -0.02|     0.04|    -0.15|    -0.15|
|childRaceAsian1                                                              |     0.14|    -0.25|    -0.34|    -0.02|     0.42|    -0.34|     0.01|
|childRaceNHPI1                                                               |     0.03|     0.06|     0.07|    -0.14|     0.16|    -0.14|    -0.14|
|childRaceNoResp1                                                             |    -0.18|    -0.27|    -0.27|    -0.23|    -0.27|    -0.27|     2.81|
|childRaceOther1                                                              |    -0.21|    -0.07|     0.01|    -0.02|     0.21|    -0.21|    -0.04|
|childRaceWhite1                                                              |     0.00|     0.42|     0.34|     0.24|    -0.17|     0.49|    -1.85|
|childRelationshipBiological.or.adoptive.father                               |     2.51|    -0.30|    -0.39|    -0.39|    -0.39|    -0.39|     0.04|
|childRelationshipGrandparent                                                 |    -0.05|     0.48|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|childRelationshipOther                                                       |    -0.08|    -0.08|    -0.08|    -0.08|     0.30|    -0.08|    -0.08|
|childSexMale                                                                 |     0.18|    -0.11|     0.04|    -0.03|    -0.01|    -0.28|    -0.01|
|communityRural                                                               |    -0.11|     0.10|     0.91|    -0.35|    -0.15|    -0.48|    -0.39|
|communitySuburban                                                            |     0.16|     0.06|    -0.37|     0.13|    -0.16|     0.28|     0.44|
|distance                                                                     |    -0.16|     0.01|     0.55|    -0.31|     0.10|    -0.20|    -0.19|
|ECBI_Cond                                                                    |    -0.11|     0.04|    -0.30|    -0.39|     0.85|    -0.76|     0.28|
|ECBI_Inatt                                                                   |    -0.20|    -0.14|    -0.37|    -0.07|     0.58|     0.36|     0.09|
|ECBI_intensity_T_score                                                       |    -0.04|     0.01|    -0.54|    -0.29|     0.88|    -0.41|     0.28|
|ECBI_Opp                                                                     |     0.05|     0.15|    -0.45|    -0.29|     0.71|    -0.85|     0.21|
|ECBI_problem_T_score                                                         |     0.04|     0.01|    -0.35|    -0.35|     0.89|    -0.81|    -0.03|
|income.120.000..149.999                                                      |     0.18|    -0.32|    -0.16|     0.06|     0.13|     0.37|    -0.07|
|income.150.000.or.more                                                       |    -0.12|    -0.40|    -0.31|     0.46|    -0.15|    -0.40|     0.22|
|income.25.001..49.999                                                        |    -0.05|     0.44|     0.08|    -0.40|     0.25|    -0.09|     0.19|
|income.50.000..79.999                                                        |     0.18|    -0.08|     0.36|    -0.15|    -0.11|    -0.60|    -0.11|
|income.80.000..119.999                                                       |    -0.04|    -0.44|     0.05|     0.31|    -0.16|     0.10|    -0.25|
|internet                                                                     |     0.16|    -0.37|    -0.12|     0.16|    -0.11|     0.16|     0.16|
|languageSurveyEnglish                                                        |     0.05|     0.05|     0.05|     0.05|     0.05|    -3.66|     0.05|
|languageSurveySpanish                                                        |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     3.66|    -0.05|
|MAPS_HS                                                                      |     0.10|    -0.33|    -0.18|    -0.43|     0.90|    -1.19|     0.23|
|MAPS_LC                                                                      |     0.24|     0.33|    -0.48|    -0.29|     0.53|    -0.82|     0.25|
|MAPS_NEG                                                                     |     0.16|    -0.03|    -0.22|    -0.49|     0.83|    -1.17|     0.25|
|MAPS_PC                                                                      |     0.02|    -0.07|     0.15|    -0.39|     0.47|    -0.67|     0.11|
|MAPS_POS                                                                     |    -0.44|    -0.01|     0.47|     0.41|    -0.56|    -0.06|    -0.56|
|MAPS_PP                                                                      |    -0.42|    -0.39|     0.48|     0.32|    -0.30|     0.12|    -0.44|
|MAPS_PR                                                                      |    -0.28|     0.17|     0.40|     0.20|    -0.37|    -0.46|    -0.48|
|MAPS_SP                                                                      |    -0.36|     0.04|     0.31|     0.39|    -0.49|     0.01|    -0.46|
|MAPS_WM                                                                      |    -0.31|     0.18|     0.28|     0.40|    -0.60|     0.13|    -0.40|
|parentAge                                                                    |     0.47|    -0.18|    -0.30|     0.14|    -0.16|    -0.89|     0.31|
|parentChildRatio                                                             |    -0.07|    -0.96|    -0.13|     0.48|    -0.12|     1.12|    -0.04|
|parentEducationCollege                                                       |    -0.12|    -0.35|    -0.07|     0.13|     0.04|    -0.41|     0.28|
|parentEducationGraduate.professional.school                                  |     0.35|    -0.31|    -0.32|     0.37|    -0.17|     0.26|    -0.31|
|parentEducationVocational.school.some.college                                |    -0.13|     0.37|     0.42|    -0.42|     0.12|    -0.49|     0.04|
|parentEthnicityNot.Hispanic.Latino                                           |     0.41|    -0.04|     0.17|     0.27|     0.03|    -0.04|    -2.00|
|parentEthnicityPrefer.not.to.respond                                         |    -0.26|    -0.26|    -0.26|    -0.22|    -0.26|    -0.26|     2.80|
|parentEthnicityUnknown                                                       |    -0.13|     0.09|    -0.13|    -0.06|    -0.02|     1.39|     0.41|
|parentGenderFemale                                                           |    -2.24|     0.29|     0.44|     0.44|     0.25|    -0.63|    -0.23|
|parentGenderOther                                                            |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|parentGenderPrefer.not.to.respond                                            |    -0.09|     0.21|    -0.09|    -0.09|     0.06|    -0.09|     0.29|
|parentGenderTransgender                                                      |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     3.66|    -0.05|
|parentMaritalStatusDivorced                                                  |    -0.10|     1.00|    -0.22|    -0.22|    -0.15|    -0.22|     0.63|
|parentMaritalStatusNever.married                                             |    -0.16|     0.90|    -0.10|    -0.10|    -0.11|     0.12|    -0.04|
|parentMaritalStatusRemarried                                                 |     0.35|    -0.11|    -0.11|    -0.11|     0.16|    -0.11|    -0.11|
|parentMaritalStatusSeparated                                                 |    -0.13|     0.74|    -0.13|    -0.13|    -0.02|     1.39|    -0.13|
|parentMaritalStatusWidowed                                                   |    -0.05|     0.48|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|parentRaceAfrAm1                                                             |     0.24|     0.09|    -0.13|     0.02|    -0.02|    -0.13|    -0.13|
|parentRaceAIAN1                                                              |    -0.15|     0.41|    -0.15|    -0.02|     0.04|    -0.15|     0.08|
|parentRaceAsian1                                                             |     0.12|    -0.26|    -0.30|     0.00|     0.39|    -0.35|    -0.01|
|parentRaceNHPI1                                                              |     0.20|     0.06|     0.07|    -0.07|    -0.04|    -0.14|    -0.14|
|parentRaceNoResp1                                                            |    -0.17|    -0.27|    -0.21|    -0.23|    -0.27|    -0.27|     2.59|
|parentRaceOther1                                                             |    -0.06|    -0.19|     0.06|    -0.08|     0.21|    -0.19|     0.01|
|parentRaceWhite1                                                             |    -0.04|     0.40|     0.32|     0.16|    -0.12|     0.54|    -1.59|
|parentSexMale                                                                |     2.36|    -0.33|    -0.41|    -0.38|    -0.33|     0.16|     0.10|
|parentSituationCo.parenting.in.separate.households                           |    -0.20|     1.30|    -0.20|    -0.20|    -0.20|    -0.20|     0.36|
|parentSituationCouple.parenting.with.spouse.or.partner.in.the.same.household |     0.31|    -2.61|     0.38|     0.38|     0.30|    -0.22|    -0.15|
|parentsNumber                                                                |     0.31|    -2.61|     0.38|     0.38|     0.30|    -0.22|    -0.15|
|SEPTI_discipline                                                             |    -0.07|    -0.13|     0.43|     0.30|    -0.78|     0.97|    -0.07|
|SEPTI_nurturance                                                             |    -0.38|     0.16|     0.37|     0.40|    -0.67|     0.62|    -0.43|
|SEPTI_play                                                                   |     0.20|     0.17|     0.15|     0.29|    -0.74|     0.64|    -0.20|
|SEPTI_routine                                                                |    -0.30|     0.09|     0.27|     0.47|    -0.65|    -0.12|    -0.40|
|totalChildren                                                                |     0.01|     0.10|     0.34|    -0.30|     0.14|    -0.99|    -0.03|
|zipcode91020                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode91204                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     0.61|
|zipcode91206                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode91210                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     0.61|
|zipcode91402                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97003                                                                 |    -0.09|    -0.09|    -0.09|    -0.09|     0.37|    -0.09|    -0.09|
|zipcode97006                                                                 |    -0.07|     0.10|    -0.20|    -0.04|     0.11|    -0.20|     0.36|
|zipcode97007                                                                 |    -0.08|    -0.08|    -0.08|     0.05|    -0.08|    -0.08|     0.39|
|zipcode97008                                                                 |     0.05|    -0.13|    -0.13|     0.09|     0.09|    -0.13|    -0.13|
|zipcode97023                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97027                                                                 |    -0.08|    -0.08|     0.32|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97032                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97034                                                                 |    -0.08|     0.30|    -0.08|     0.05|    -0.08|    -0.08|    -0.08|
|zipcode97035                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97045                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode97056                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97060                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97062                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97068                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode97071                                                                 |    -0.08|    -0.08|     0.32|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97078                                                                 |     0.24|     0.30|    -0.08|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97086                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97089                                                                 |    -0.08|    -0.08|    -0.08|    -0.08|     0.30|    -0.08|    -0.08|
|zipcode97101                                                                 |    -0.05|     0.48|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97116                                                                 |    -0.08|    -0.08|    -0.08|     0.05|     0.11|    -0.08|    -0.08|
|zipcode97123                                                                 |     0.17|    -0.09|    -0.09|    -0.09|     0.22|    -0.09|    -0.09|
|zipcode97124                                                                 |    -0.12|     0.12|    -0.12|    -0.12|     0.24|    -0.12|     0.18|
|zipcode97140                                                                 |    -0.08|     0.30|    -0.08|    -0.08|    -0.08|    -0.08|     0.39|
|zipcode97141                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97201                                                                 |     0.12|    -0.11|    -0.11|     0.08|    -0.11|    -0.11|     0.22|
|zipcode97202                                                                 |    -0.08|    -0.06|    -0.21|    -0.06|     0.31|    -0.21|     0.16|
|zipcode97203                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     0.61|
|zipcode97206                                                                 |     0.20|    -0.14|    -0.14|     0.14|    -0.04|    -0.14|    -0.14|
|zipcode97209                                                                 |    -0.09|    -0.09|    -0.09|     0.12|    -0.09|    -0.09|     0.29|
|zipcode97210                                                                 |    -0.05|     0.48|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97211                                                                 |     0.12|    -0.11|    -0.11|     0.08|     0.03|    -0.11|    -0.11|
|zipcode97212                                                                 |    -0.11|    -0.11|    -0.11|     0.08|     0.03|    -0.11|     0.22|
|zipcode97213                                                                 |     0.17|    -0.09|    -0.09|     0.12|    -0.09|    -0.09|    -0.09|
|zipcode97214                                                                 |    -0.12|    -0.12|    -0.12|    -0.04|     0.36|    -0.12|    -0.12|
|zipcode97215                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     3.66|    -0.05|
|zipcode97217                                                                 |    -0.09|    -0.09|    -0.09|    -0.09|     0.37|    -0.09|    -0.09|
|zipcode97219                                                                 |    -0.04|    -0.02|    -0.18|     0.04|     0.23|    -0.18|    -0.18|
|zipcode97220                                                                 |    -0.08|    -0.08|     0.32|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97221                                                                 |     0.24|    -0.08|    -0.08|    -0.08|    -0.08|    -0.08|     0.39|
|zipcode97222                                                                 |    -0.09|     0.21|    -0.09|     0.12|    -0.09|    -0.09|    -0.09|
|zipcode97223                                                                 |     0.29|    -0.12|    -0.12|     0.04|     0.00|    -0.12|    -0.12|
|zipcode97224                                                                 |    -0.08|    -0.08|    -0.08|    -0.08|     0.30|    -0.08|    -0.08|
|zipcode97225                                                                 |     0.29|     0.12|    -0.12|    -0.04|     0.00|    -0.12|    -0.12|
|zipcode97227                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|     0.61|
|zipcode97229                                                                 |     0.19|    -0.20|    -0.20|    -0.09|     0.03|    -0.20|     0.74|
|zipcode97230                                                                 |    -0.08|    -0.08|    -0.08|     0.05|    -0.08|    -0.08|     0.39|
|zipcode97232                                                                 |    -0.08|     0.30|    -0.08|     0.05|    -0.08|    -0.08|    -0.08|
|zipcode97233                                                                 |     0.24|    -0.08|    -0.08|    -0.08|     0.11|    -0.08|    -0.08|
|zipcode97236                                                                 |     0.40|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97239                                                                 |    -0.04|    -0.18|    -0.18|     0.27|    -0.10|     0.96|    -0.18|
|zipcode97266                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode97267                                                                 |    -0.09|    -0.09|    -0.09|    -0.09|    -0.09|     6.36|    -0.09|
|zipcode97321                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode97325                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcode97429                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode97527                                                                 |     0.24|    -0.08|     0.12|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97701                                                                 |     0.01|     0.25|    -0.37|     0.40|    -0.23|    -0.37|    -0.26|
|zipcode97702                                                                 |     0.14|    -0.26|    -0.20|     0.22|    -0.08|    -0.26|     0.03|
|zipcode97703                                                                 |    -0.03|    -0.17|    -0.17|     0.18|     0.00|    -0.17|     0.04|
|zipcode97707                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97734                                                                 |    -0.09|    -0.09|     0.40|    -0.09|    -0.09|    -0.09|    -0.09|
|zipcode97738                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode97741                                                                 |    -0.03|     0.34|     0.28|    -0.17|    -0.09|    -0.17|    -0.17|
|zipcode97753                                                                 |    -0.09|     0.21|     0.23|    -0.09|    -0.09|    -0.09|    -0.09|
|zipcode97754                                                                 |     0.17|     0.04|     0.25|    -0.15|    -0.06|    -0.15|    -0.15|
|zipcode97756                                                                 |    -0.16|     0.29|     0.96|    -0.34|    -0.35|    -0.43|    -0.23|
|zipcode97759                                                                 |    -0.08|    -0.08|     0.32|    -0.08|    -0.08|    -0.08|    -0.08|
|zipcode97760                                                                 |     0.17|    -0.09|     0.23|    -0.09|    -0.09|    -0.09|    -0.09|
|zipcode98632                                                                 |    -0.05|    -0.05|     0.23|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode98660                                                                 |    -0.05|    -0.05|    -0.05|    -0.05|     0.22|    -0.05|    -0.05|
|zipcode98683                                                                 |    -0.05|     0.48|    -0.05|    -0.05|    -0.05|    -0.05|    -0.05|
|zipcode98685                                                                 |    -0.05|    -0.05|    -0.05|     0.13|    -0.05|    -0.05|    -0.05|
|zipcodeClass2                                                                |    -0.12|     0.34|     1.38|    -0.53|    -0.42|    -0.62|    -0.46|


## Partitioning around medoids (PAM)

![plot of chunk pam](figures/pam-1.png)![plot of chunk pam](figures/pam-2.png)

```
## Clustering k = 1,2,..., K.max (= 25): .. done
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

![plot of chunk pam](figures/pam-3.png)

```
## .
##   1   2   3 
## 140 120  85
```

![plot of chunk pam](figures/pam-4.png)

|var                                                                          | cluster1| cluster2| cluster3|
|:----------------------------------------------------------------------------|--------:|--------:|--------:|
|birthOrderMiddle                                                             |    -0.38|    -0.38|    -0.38|
|birthOrderOldest                                                             |    -0.62|     1.61|    -0.62|
|birthOrderYoungest                                                           |    -0.61|    -0.61|     1.63|
|childAge                                                                     |    -1.25|    -0.25|    -0.10|
|childEthnicityNot.Hispanic.Latino                                            |     0.54|     0.54|     0.54|
|childEthnicityPrefer.not.to.respond                                          |    -0.29|    -0.29|    -0.29|
|childEthnicityUnknown                                                        |    -0.13|    -0.13|    -0.13|
|childRaceAfrAm1                                                              |    -0.20|    -0.20|    -0.20|
|childRaceAIAN1                                                               |    -0.15|    -0.15|    -0.15|
|childRaceAsian1                                                              |    -0.34|    -0.34|    -0.34|
|childRaceNHPI1                                                               |    -0.14|    -0.14|    -0.14|
|childRaceNoResp1                                                             |    -0.27|    -0.27|    -0.27|
|childRaceOther1                                                              |    -0.21|    -0.21|    -0.21|
|childRaceWhite1                                                              |     0.49|     0.49|     0.49|
|childRelationshipBiological.or.adoptive.father                               |    -0.39|    -0.39|    -0.39|
|childRelationshipGrandparent                                                 |    -0.05|    -0.05|    -0.05|
|childRelationshipOther                                                       |    -0.08|    -0.08|    -0.08|
|childSexMale                                                                 |     0.92|    -1.09|     0.92|
|communityRural                                                               |    -0.48|    -0.48|    -0.48|
|communitySuburban                                                            |     1.09|    -0.92|     1.09|
|distance                                                                     |     0.01|     0.01|    -0.34|
|ECBI_Cond                                                                    |    -0.54|     0.83|    -0.39|
|ECBI_Inatt                                                                   |     0.36|     0.60|    -0.12|
|ECBI_intensity_T_score                                                       |     0.47|     0.61|    -0.38|
|ECBI_Opp                                                                     |     0.49|     0.71|    -0.06|
|ECBI_problem_T_score                                                         |     0.23|     0.44|    -0.71|
|income.120.000..149.999                                                      |    -0.32|    -0.32|    -0.32|
|income.150.000.or.more                                                       |    -0.40|    -0.40|    -0.40|
|income.25.001..49.999                                                        |    -0.56|    -0.56|    -0.56|
|income.50.000..79.999                                                        |     1.67|     1.67|    -0.60|
|income.80.000..119.999                                                       |    -0.44|    -0.44|     2.27|
|internet                                                                     |     0.16|     0.16|     0.16|
|languageSurveyEnglish                                                        |     0.05|     0.05|     0.05|
|languageSurveySpanish                                                        |    -0.05|    -0.05|    -0.05|
|MAPS_HS                                                                      |    -0.42|     0.27|    -0.42|
|MAPS_LC                                                                      |     0.21|    -0.65|    -0.22|
|MAPS_NEG                                                                     |    -0.43|    -0.53|    -0.62|
|MAPS_PC                                                                      |    -0.74|    -0.74|    -0.74|
|MAPS_POS                                                                     |    -0.26|     0.81|     0.95|
|MAPS_PP                                                                      |    -0.70|    -0.11|     0.77|
|MAPS_PR                                                                      |     0.47|     0.94|     0.47|
|MAPS_SP                                                                      |    -0.10|     0.97|     0.97|
|MAPS_WM                                                                      |    -0.52|     0.78|     0.78|
|parentAge                                                                    |    -0.76|     0.72|     0.39|
|parentChildRatio                                                             |     1.47|    -0.26|    -0.83|
|parentEducationCollege                                                       |     1.22|    -0.82|    -0.82|
|parentEducationGraduate.professional.school                                  |    -0.62|     1.60|    -0.62|
|parentEducationVocational.school.some.college                                |    -0.49|    -0.49|     2.02|
|parentEthnicityNot.Hispanic.Latino                                           |     0.48|     0.48|     0.48|
|parentEthnicityPrefer.not.to.respond                                         |    -0.26|    -0.26|    -0.26|
|parentEthnicityUnknown                                                       |    -0.13|    -0.13|    -0.13|
|parentGenderFemale                                                           |     0.44|     0.44|     0.44|
|parentGenderOther                                                            |    -0.05|    -0.05|    -0.05|
|parentGenderPrefer.not.to.respond                                            |    -0.09|    -0.09|    -0.09|
|parentGenderTransgender                                                      |    -0.05|    -0.05|    -0.05|
|parentMaritalStatusDivorced                                                  |    -0.22|    -0.22|    -0.22|
|parentMaritalStatusNever.married                                             |    -0.43|    -0.43|    -0.43|
|parentMaritalStatusRemarried                                                 |    -0.11|    -0.11|    -0.11|
|parentMaritalStatusSeparated                                                 |    -0.13|    -0.13|    -0.13|
|parentMaritalStatusWidowed                                                   |    -0.05|    -0.05|    -0.05|
|parentRaceAfrAm1                                                             |    -0.13|    -0.13|    -0.13|
|parentRaceAIAN1                                                              |    -0.15|    -0.15|    -0.15|
|parentRaceAsian1                                                             |    -0.35|    -0.35|    -0.35|
|parentRaceNHPI1                                                              |    -0.14|    -0.14|    -0.14|
|parentRaceNoResp1                                                            |    -0.27|    -0.27|    -0.27|
|parentRaceOther1                                                             |    -0.19|    -0.19|    -0.19|
|parentRaceWhite1                                                             |     0.54|     0.54|     0.54|
|parentSexMale                                                                |    -0.41|    -0.41|    -0.41|
|parentSituationCo.parenting.in.separate.households                           |    -0.20|    -0.20|    -0.20|
|parentSituationCouple.parenting.with.spouse.or.partner.in.the.same.household |     0.38|     0.38|     0.38|
|parentsNumber                                                                |     0.38|     0.38|     0.38|
|SEPTI_discipline                                                             |    -0.42|     0.08|     0.90|
|SEPTI_nurturance                                                             |    -0.60|     0.67|     0.42|
|SEPTI_play                                                                   |     0.46|     0.18|    -0.82|
|SEPTI_routine                                                                |    -0.71|     0.87|     0.08|
|totalChildren                                                                |    -0.99|    -0.06|     0.87|
|zipcode91020                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode91204                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode91206                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode91210                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode91402                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97003                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97006                                                                 |    -0.20|    -0.20|    -0.20|
|zipcode97007                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97008                                                                 |    -0.13|    -0.13|    -0.13|
|zipcode97023                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97027                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97032                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97034                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97035                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97045                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97056                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97060                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97062                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97068                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97071                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97078                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97086                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97089                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97101                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97116                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97123                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97124                                                                 |    -0.12|    -0.12|    -0.12|
|zipcode97140                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97141                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97201                                                                 |    -0.11|    -0.11|    -0.11|
|zipcode97202                                                                 |    -0.21|    -0.21|    -0.21|
|zipcode97203                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97206                                                                 |    -0.14|    -0.14|    -0.14|
|zipcode97209                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97210                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97211                                                                 |    -0.11|    -0.11|    -0.11|
|zipcode97212                                                                 |    -0.11|    -0.11|    -0.11|
|zipcode97213                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97214                                                                 |    -0.12|    -0.12|    -0.12|
|zipcode97215                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97217                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97219                                                                 |    -0.18|    -0.18|    -0.18|
|zipcode97220                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97221                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97222                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97223                                                                 |    -0.12|    -0.12|    -0.12|
|zipcode97224                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97225                                                                 |    -0.12|    -0.12|    -0.12|
|zipcode97227                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97229                                                                 |    -0.20|    -0.20|    -0.20|
|zipcode97230                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97232                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97233                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97236                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97239                                                                 |    -0.18|    -0.18|    -0.18|
|zipcode97266                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97267                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97321                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97325                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97429                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97527                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97701                                                                 |     2.72|     2.72|    -0.37|
|zipcode97702                                                                 |    -0.26|    -0.26|    -0.26|
|zipcode97703                                                                 |    -0.17|    -0.17|    -0.17|
|zipcode97707                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97734                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97738                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode97741                                                                 |    -0.17|    -0.17|    -0.17|
|zipcode97753                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode97754                                                                 |    -0.15|    -0.15|    -0.15|
|zipcode97756                                                                 |    -0.43|    -0.43|     2.34|
|zipcode97759                                                                 |    -0.08|    -0.08|    -0.08|
|zipcode97760                                                                 |    -0.09|    -0.09|    -0.09|
|zipcode98632                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode98660                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode98683                                                                 |    -0.05|    -0.05|    -0.05|
|zipcode98685                                                                 |    -0.05|    -0.05|    -0.05|
|zipcodeClass2                                                                |    -0.62|    -0.62|     1.62|


## Agglomerative hierarchical clustering (AGNES)

![plot of chunk agnes](figures/agnes-1.png)

Correlation between cophenetic distance and the original distance is
0.383.

> The closer the value of the correlation coefficient is to 1, the more accurately the clustering solution reflects your data.
> Values above 0.75 are felt to be good.

Agglomerative coeffficient using the
Ward
method is
0.887.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  324          0.27
## 2       2   21          0.14
```

```
## .
##   1   2 
## 324  21
```

![plot of chunk agnes_k2](figures/agnes_k2-1.png)![plot of chunk agnes_k2](figures/agnes_k2-2.png)![plot of chunk agnes_k2](figures/agnes_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  190          0.08
## 2       2  134          0.03
## 3       3   21          0.12
```

```
## .
##   1   2   3 
## 190 134  21
```

![plot of chunk agnes_k3](figures/agnes_k3-1.png)![plot of chunk agnes_k3](figures/agnes_k3-2.png)![plot of chunk agnes_k3](figures/agnes_k3-3.png)

### $k = 4$ clusters


```
##   cluster size ave.sil.width
## 1       1  144          0.14
## 2       2  134         -0.01
## 3       3   46         -0.03
## 4       4   21          0.10
```

```
## .
##   1   2   3   4 
## 144 134  46  21
```

![plot of chunk agnes_k4](figures/agnes_k4-1.png)![plot of chunk agnes_k4](figures/agnes_k4-2.png)![plot of chunk agnes_k4](figures/agnes_k4-3.png)

### $k = 5$ clusters


```
##   cluster size ave.sil.width
## 1       1  144          0.09
## 2       2  106          0.02
## 3       3   46         -0.04
## 4       4   28          0.00
## 5       5   21          0.09
```

```
## .
##   1   2   3   4   5 
## 144 106  46  28  21
```

![plot of chunk agnes_k5](figures/agnes_k5-1.png)![plot of chunk agnes_k5](figures/agnes_k5-2.png)![plot of chunk agnes_k5](figures/agnes_k5-3.png)


## Divisive hierarchical clustering (DIANA)

![plot of chunk diana](figures/diana-1.png)

Divisive coeffficient is
0.727.



### $k = 2$ clusters


```
##   cluster size ave.sil.width
## 1       1  330          0.30
## 2       2   15          0.11
```

```
## .
##   1   2 
## 330  15
```

![plot of chunk diana_k2](figures/diana_k2-1.png)![plot of chunk diana_k2](figures/diana_k2-2.png)![plot of chunk diana_k2](figures/diana_k2-3.png)

### $k = 3$ clusters


```
##   cluster size ave.sil.width
## 1       1  329          0.30
## 2       2   15          0.11
## 3       3    1          0.00
```

```
## .
##   1   2   3 
## 329  15   1
```

![plot of chunk diana_k3](figures/diana_k3-1.png)![plot of chunk diana_k3](figures/diana_k3-2.png)![plot of chunk diana_k3](figures/diana_k3-3.png)

### $k = 4$ clusters


```
##   cluster size ave.sil.width
## 1       1  307          0.22
## 2       2   15          0.06
## 3       3   22          0.16
## 4       4    1          0.00
```

```
## .
##   1   2   3   4 
## 307  15  22   1
```

![plot of chunk diana_k4](figures/diana_k4-1.png)![plot of chunk diana_k4](figures/diana_k4-2.png)![plot of chunk diana_k4](figures/diana_k4-3.png)

### $k = 5$ clusters


```
##   cluster size ave.sil.width
## 1       1  289          0.20
## 2       2   18          0.05
## 3       3   15          0.05
## 4       4   22          0.15
## 5       5    1          0.00
```

```
## .
##   1   2   3   4   5 
## 289  18  15  22   1
```

![plot of chunk diana_k5](figures/diana_k5-1.png)![plot of chunk diana_k5](figures/diana_k5-2.png)![plot of chunk diana_k5](figures/diana_k5-3.png)


## Compare

Comparison between `agnes` and `diana` doesn't give much insight.

*Do not evaluate*



## Examine clusters

* $k = 2$ clusters seems optimal using AGNES
* $k = 3$ clusters seems optimal using DIANA


```
##    
##       1   2   3
##   1 315   8   1
##   2  14   7   0
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![plot of chunk PCB](figures/PCB-1.png)

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![plot of chunk PCB](figures/PCB-2.png)

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![plot of chunk PCB](figures/PCB-3.png)



