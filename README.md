
<!-- README.md is generated from README.Rmd. Please edit that file -->
Convenience Access to 'Sysstat', 'SAR', 'SADF' Data as Data.Frames, JSON, XML
-----------------------------------------------------------------------------

**Status**

*lines of R code:* 295, *lines of test code:* 0

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) <a href="https://travis-ci.org/petermeissner/sar"><img src="https://api.travis-ci.org/petermeissner/sar.svg?branch=master"><a/> [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/petermeissner/sar?branch=master&svg=true)](https://ci.appveyor.com/project/petermeissner/sar) <a href="https://codecov.io/gh/petermeissner/sar"><img src="https://codecov.io/gh/petermeissner/sar/branch/master/graph/badge.svg" alt="Codecov" /></a> <!--<a href="https://cran.r-project.org/package=sar"><img src="http://www.r-pkg.org/badges/version/sar"></a>
[![cran checks](https://cranchecks.info/badges/summary/reshape)](https://cran.r-project.org/web/checks/check_results_reshape.html)
<img src="http://cranlogs.r-pkg.org/badges/grand-total/sar">
<img src="http://cranlogs.r-pkg.org/badges/sar">
-->

**Development version**

0.1.0 - 2019-03-22 / 06:19:43

**Description**

Making available system statistics systems with commandline tool 'sar' and 'sadf' (a standard tool to collect system statistics on Unix like systems). The pacakge does provide the data collected by 'sar' and friends as an easily accessible and processable data.frame, JSON string, or XML string. Using the systems SSH client its possible to collect data from remote servers and return access in the local session.

**License**

    ## MIT + file LICENSE
    ## c(
    ##     person(
    ##       "virtual7 GmbH", 
    ##       role  = c("cph"),
    ##       email = "info@virtual7.de"
    ##     ),
    ##     person(
    ##       "Peter", 
    ##       "Meissner", 
    ##       role  = c("aut", "cre"),
    ##       email = "retep.meissner@gmail.com"
    ##     )
    ##   )

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

**simple usage**

``` r
sar_stat() %>% head()
##                    ts tspan_s    node device             stat category      value unit      name
## 1 2019-03-22 00:05:01     300 Server1   <NA> io_readwrite_tps       io        4.9  tps readwrite
## 2 2019-03-22 00:05:01     300 Server1   <NA>      io_read_tps       io       0.06  tps      read
## 3 2019-03-22 00:05:01     300 Server1   <NA>       io_read_mb       io 0.00000552   mb      read
## 4 2019-03-22 00:05:01     300 Server1   <NA>     io_write_tps       io       4.84  tps     write
## 5 2019-03-22 00:05:01     300 Server1   <NA>      io_write_mb       io 0.00010946   mb     write
## 6 2019-03-22 00:05:01     300 Server1   <NA>      ram_free_gb      ram   1.634284   gb      free
```

**simple usage to wide format**

``` r
sar_stat(to_wide = TRUE) %>% head()
##                     ts    node device tspan_s io_readwrite_tps io_read_tps io_read_mb io_write_tps
## 1  2019-03-22 00:05:01 Server1   <NA>     300              4.9        0.06 0.00000552         4.84
## 29 2019-03-22 00:05:01 Server1     lo     300             <NA>        <NA>       <NA>         <NA>
##    io_write_mb ram_free_gb ram_avail_gb ram_used_gb ram_used_pct ram_buffers_gb ram_cached_gb ram_commit_gb
## 1   0.00010946    1.634284     3.620328    6.532216        79.99       0.296360      1.481352      5.458944
## 29        <NA>        <NA>         <NA>        <NA>         <NA>           <NA>          <NA>          <NA>
##    ram_commit_pct ram_active_gb ram_inactive_gb ram_dirty_gb cpu_user_pct cpu_nice_pct cpu_system_pct
## 1           66.85      5.094232        0.787244     0.000376         33.8            0           4.81
## 29           <NA>          <NA>            <NA>         <NA>         <NA>         <NA>           <NA>
##    cpu_iowait_pct cpu_steal_pct cpu_idle_pct load_run_queue_n load_processes_n load_average_1_min
## 1            0.55          0.15        60.68                2              647               0.78
## 29           <NA>          <NA>         <NA>             <NA>             <NA>               <NA>
##    load_average_5_min load_average_15_min load_blocked_n net_read_pkg_n net_write_pkg_n net_read_kb
## 1                0.78                0.75              0           <NA>            <NA>        <NA>
## 29               <NA>                <NA>           <NA>          64.34           64.34       60.76
##    net_write_kb net_read_compressed_kb net_write_compressed_kb net_read_multicast_pkg_n net_utilization_pct
## 1          <NA>                   <NA>                    <NA>                     <NA>                <NA>
## 29        60.76                      0                       0                        0                   0
##  [ reached 'max' / getOption("max.print") -- omitted 4 rows ]
```

**get data for yesterday**

``` r
sar_stat(day = -1) %>% head()
##                    ts tspan_s    node device             stat category     value unit      name
## 1 2019-03-21 00:05:01     300 Server1   <NA> io_readwrite_tps       io      1.47  tps readwrite
## 2 2019-03-21 00:05:01     300 Server1   <NA>      io_read_tps       io         0  tps      read
## 3 2019-03-21 00:05:01     300 Server1   <NA>       io_read_mb       io 0.0000000   mb      read
## 4 2019-03-21 00:05:01     300 Server1   <NA>     io_write_tps       io      1.47  tps     write
## 5 2019-03-21 00:05:01     300 Server1   <NA>      io_write_mb       io 0.0000312   mb     write
## 6 2019-03-21 00:05:01     300 Server1   <NA>      ram_free_gb      ram  3.587180   gb      free
```

**get data for day before yesterday**

``` r
sar_stat(day = -2) %>% head()
##                    ts tspan_s    node device             stat category      value unit      name
## 1 2019-03-20 00:05:01     300 Server1   <NA> io_readwrite_tps       io       1.58  tps readwrite
## 2 2019-03-20 00:05:01     300 Server1   <NA>      io_read_tps       io          0  tps      read
## 3 2019-03-20 00:05:01     300 Server1   <NA>       io_read_mb       io 0.00000000   mb      read
## 4 2019-03-20 00:05:01     300 Server1   <NA>     io_write_tps       io       1.58  tps     write
## 5 2019-03-20 00:05:01     300 Server1   <NA>      io_write_mb       io 0.00003352   mb     write
## 6 2019-03-20 00:05:01     300 Server1   <NA>      ram_free_gb      ram   4.115168   gb      free
```

**get data for last 20th calender day**

``` r
sar_stat(day = 20) %>% head()
##                    ts tspan_s    node device             stat category      value unit      name
## 1 2019-03-20 00:05:01     300 Server1   <NA> io_readwrite_tps       io       1.58  tps readwrite
## 2 2019-03-20 00:05:01     300 Server1   <NA>      io_read_tps       io          0  tps      read
## 3 2019-03-20 00:05:01     300 Server1   <NA>       io_read_mb       io 0.00000000   mb      read
## 4 2019-03-20 00:05:01     300 Server1   <NA>     io_write_tps       io       1.58  tps     write
## 5 2019-03-20 00:05:01     300 Server1   <NA>      io_write_mb       io 0.00003352   mb     write
## 6 2019-03-20 00:05:01     300 Server1   <NA>      ram_free_gb      ram   4.115168   gb      free
```

**get data for remote server**

``` r
sar_stat(server = c("localhost", "localhost")) %>% head()
##                    ts tspan_s    node device             stat category      value unit      name
## 1 2019-03-22 00:05:01     300 Server1   <NA> io_readwrite_tps       io        4.9  tps readwrite
## 2 2019-03-22 00:05:01     300 Server1   <NA>      io_read_tps       io       0.06  tps      read
## 3 2019-03-22 00:05:01     300 Server1   <NA>       io_read_mb       io 0.00000552   mb      read
## 4 2019-03-22 00:05:01     300 Server1   <NA>     io_write_tps       io       4.84  tps     write
## 5 2019-03-22 00:05:01     300 Server1   <NA>      io_write_mb       io 0.00010946   mb     write
## 6 2019-03-22 00:05:01     300 Server1   <NA>      ram_free_gb      ram   1.634284   gb      free
```

**and now vectorized on server and day**

``` r
sar_stat(day = -c(1:5), server = c("localhost", "localhost")) %>% head()
##                    ts tspan_s    node device             stat category     value unit      name
## 1 2019-03-21 00:05:01     300 Server1   <NA> io_readwrite_tps       io      1.47  tps readwrite
## 2 2019-03-21 00:05:01     300 Server1   <NA>      io_read_tps       io         0  tps      read
## 3 2019-03-21 00:05:01     300 Server1   <NA>       io_read_mb       io 0.0000000   mb      read
## 4 2019-03-21 00:05:01     300 Server1   <NA>     io_write_tps       io      1.47  tps     write
## 5 2019-03-21 00:05:01     300 Server1   <NA>      io_write_mb       io 0.0000312   mb     write
## 6 2019-03-21 00:05:01     300 Server1   <NA>      ram_free_gb      ram  3.587180   gb      free
```

**but best of all is plotting**

``` r
# TBD #  sar_stat() %>% plot()
```
