
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tutiempo

<!-- badges: start -->

[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/epix-project/tutiempo?branch=master&svg=true)](https://ci.appveyor.com/project/epix-project/tutiempo)
[![Travis build
status](https://travis-ci.org/epix-project/tutiempo.svg?branch=master)](https://travis-ci.org/epix-project/tutiempo)
<!-- badges: end -->

The `tutiempo` package provides meteorological data from
[Tutiempo.net](https://en.tutiempo.net) for

  - Cambodia
  - Lao PDR
  - Malaysia
  - Myanmar
  - Philippines
  - Thailand
  - Vietnam

Until the 31st of December, 2016.

## Installation

You can install the development version from
[GitHub](https://github.com/epix-project/tutiempo) with:

``` r
# install.packages("devtools")
devtools::install_github("epix-project/tutiempo")
```

## Example

The package contains 2 data frames:

  - `meteo` contains de meteorological data;
  - `stations` contains information about the climatic stations.

<!-- end list -->

``` r
library(tutiempo)
data(meteo)
data(stations)
```

The common key between these two packages is the `station` variable.
