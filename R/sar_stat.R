#' sar_stat
#'
#' @param as format to return
#' @inheritParams sar_exec_sadf
#'
#' @rdname sar_exec_sadf
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'  sar_stat()
#'  sar_stat(as = "json")
#'  sar_stat(server = "localhost")
#' }
#'
sar_stat <-
  function(
    statistic = c("cpu", "ram", "network", "io", "load"),
    as        = c("df", "json", "xml"),
    server    = NULL,
    day       = NULL,
    log_path  = NULL
  ){

    # process inputs
    as <- as[1]


    # gather data
    if ( as == "xml" ){
      return(
        sar_exec_sadf(
          format    = "xml",
          statistic = statistic,
          server    = server,
          day       = day,
          log_path  = log_path
        )
      )
    } else {
      json <-
        sar_exec_sadf(
          format    = "json",
          statistic = statistic,
          server    = server,
          day       = day,
          log_path  = log_path
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

    # add sar_df class and return
    class(df) <- c(class(df), "sar_df")
    df
  }


