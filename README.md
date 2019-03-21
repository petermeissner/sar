
<!-- README.md is generated from README.Rmd. Please edit that file -->
Convenience Access to 'Sysstat', 'SAR', 'SADF' Data as Data.Frames, JSON, XML
-----------------------------------------------------------------------------

**Status**

*lines of R code:* 244, *lines of test code:* 0

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) <a href="https://travis-ci.org/petermeissner/sar"><img src="https://api.travis-ci.org/petermeissner/sar.svg?branch=master"><a/> [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/petermeissner/sar?branch=master&svg=true)](https://ci.appveyor.com/project/petermeissner/sar) <a href="https://codecov.io/gh/petermeissner/sar"><img src="https://codecov.io/gh/petermeissner/sar/branch/master/graph/badge.svg" alt="Codecov" /></a> <!--<a href="https://cran.r-project.org/package=sar"><img src="http://www.r-pkg.org/badges/version/sar"></a>
[![cran checks](https://cranchecks.info/badges/summary/reshape)](https://cran.r-project.org/web/checks/check_results_reshape.html)
<img src="http://cranlogs.r-pkg.org/badges/grand-total/sar">
<img src="http://cranlogs.r-pkg.org/badges/sar">
-->

**Development version**

0.1.0 - 2019-03-21 / 17:37:06

**Description**

Making available system statistics systems with commandline tool 'sar' and 'sadf' (a standard tool to collect system statistics on Unix like systems). The pacakge does provide the data collected by 'sar' and friends as an easily accessible and processable data.frame, JSON string, or XML string. Using the systems SSH client its possible to collect data from remote servers and return access in the local session.

**License**

    #> MIT + file LICENSE
    #> c(
    #>     person(
    #>       "virtual7 GmbH", 
    #>       role  = c("cph"),
    #>       email = "info@virtual7.de"
    #>     ),
    #>     person(
    #>       "Peter", 
    #>       "Meissner", 
    #>       role  = c("aut", "cre"),
    #>       email = "retep.meissner@gmail.com"
    #>     )
    #>   )

**Citation**

``` r
citation("sar")
```

**BibTex for citing**

``` r
toBibtex(citation("sar"))
```

Installation
------------

**Installation and start - development version**

``` r
devtools::install_github("petermeissner/sar")
library(sar)
```

Usage
-----

``` r
library(sar)
```

``` r
sar_stat() %>% head()
```

    #>                    ts tspan_s         node device             stat category     value unit      name
    #> 1 2019-03-21 00:05:01     300 my_server_#1   <NA> io_readwrite_tps       io      1.47  tps readwrite
    #> 2 2019-03-21 00:05:01     300 my_server_#1   <NA>      io_read_tps       io         0  tps      read
    #> 3 2019-03-21 00:05:01     300 my_server_#1   <NA>       io_read_mb       io 0.0000000   mb      read
    #> 4 2019-03-21 00:05:01     300 my_server_#1   <NA>     io_write_tps       io      1.47  tps     write
    #> 5 2019-03-21 00:05:01     300 my_server_#1   <NA>      io_write_mb       io 0.0000312   mb     write
    #> 6 2019-03-21 00:05:01     300 my_server_#1   <NA>      ram_free_gb      ram  3.587180   gb      free
