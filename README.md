
<!-- README.md is generated from README.Rmd. Please edit that file -->

# process published nhs data

<!-- badges: start -->
<!-- badges: end -->

Since 2012, the City Intelligence Unit’s Demography Team made has use of
extracts of patient register data as part of its ongoing analysis of
population change. These extracts were provided under license by the NHS
and consisted of aggregate counts of persons registered with a GP by
age, sex, and area of residence.

In recent years, NHS Digital has regularly published data about the
numbers of persons present on GP patient registers. Two datasets are
available:

-   Counts of patients by practice attended x sex x LSOA of residence -
    published quarterly

-   Counts of patients by practice attended x sex x age - published
    monthly

These data are published on the [NHS Digital
website](https://digital.nhs.uk/data-and-information/publications/statistical/patients-registered-at-a-gp-practice).
Each month’s extracts are published on their own pages, which mostly
follow the naming convention:

    .../patients-registered-at-a-gp-practice/<month>-<year>

The purpose of the code in this repository is to take these published
data and consolidate them into an approximation of patient counts by sex
x age x Local Authority District of residence that can be used as the
basis for demographic analysis.

Modelled counts of patients by age, sex, and local authority of
residence are created by a simple process of apportioning the data for
each GP practice in (1) by the distribution for each practice in (2).

## Installation

## Example

This is a basic example which shows you how to solve a common problem:

``` r

## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
