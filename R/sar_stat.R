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
    log_path  = NULL,
    to_wide   = FALSE
  ){

    # Recursion / Vectorization
    if ( length(day) > 1 | length(server) > 1 ){
      if ( length(day) == 0 ){
        day <- NA
      }

      if ( length(server) == 0 ){
        server <- NA
      }

      param <- expand.grid(server = server, day = day)

      res <-
        purrr::map2_df(
          .x = param$server,
          .y = param$day,
          .f =
            function(
              server,
              day,
              log_path,
              statistic
            ){
              sar_stat(
                server    = server,
                day       = day,
                log_path  = log_path,
                statistic = statistic
              )
            },
          log_path  = log_path,
          statistic = statistic
        )
      return(res)
    }

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

    # wide or long format?
    if ( to_wide == TRUE ){
      df <-
        reshape(
          df[, c("ts", "node", "device", "tspan_s", "stat", "value")],
          idvar = c("ts", "node", "device", "tspan_s"),
          timevar = "stat",
          direction = "wide"
        )

      names(df) <- stringb::text_replace(names(df), "value.", "")
    }



    # add sar_df class and return
    class(df) <- c("sar_df", class(df))
    df
  }


