#' sar_stat
#'
#' @param statistic list of categories to report statistics on
#' @param as format to return
#' @param server optional server to get statistics from - if set, function
#'   will try to ssh into server and retrieve statitics otherwise it will
#'   retrieve statistics from local machine
#'
#' @export
#'
sar_stat <-
  function(
    statistic = c("cpu", "ram", "network", "io", "load"),
    as        = c("df", "json", "xml"),
    server    = NULL
  ){

    # process inputs
    as <- as[1]


    # gather data
    if ( as == "xml" ){
      return(
        sar_exec_sadf(
          format    = "xml",
          statistic = statistic,
          server    = server
        )
      )
    } else {
      json <-
        sar_exec_sadf(
          format    = "json",
          statistic = statistic,
          server    = server
        )

      if( as == "json" ){
        return(json)
      }
    }

    # parse data
    json_parsed <-
      jsonlite::fromJSON(
        json,
        simplifyVector = FALSE,
        flatten        = FALSE
      )


    # put data into data.frame
    df <- sar_normalize_json(json_parsed)

    # return
    df
  }


