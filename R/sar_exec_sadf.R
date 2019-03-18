#' sar_exec_sadf
#'
#' @param statistic Statistics to retreive.
#' @param format Only first item will be used. The format of data to produce.
#' @param server list of servers to ssh into and retrieve statistics
#'
#' @export
#'
#' @examples
#' \dontrun{
#' sar_exec_sadf()
#' sar_exec_sadf(server = "localhost")
#' sar_exec_sadf(format = "json")
#' }
#'
sar_exec_sadf <-
  function(
    statistic = c("cpu", "ram", "network", "io", "load"),
    format    = c("df", "csv", "json", "xml"),
    server    = NULL
  ){

    # # log path
    # if ( is.null(log_path) ){
    #   log_path <- "/var/log/sysstat/"
    # } else {
    #   # do nothing
    # }

    # server
    server_cmd   <-
      if ( length(server) > 0 ){
        glue::glue("ssh {server}")
      } else {
        ""
      }

    # statistic to commandline option
    stat_match <-
      data.frame(
        statistic = c("cpu", "ram", "network", "io", "load"),
        stat_cmd  = c("-u",  "-r",  "-n DEV",  "-b", "-q"  ),
        stringsAsFactors = FALSE
      )

    stat_cmd <-
      paste(
        stat_match[
          match(statistic, stat_match$statistic),
          "stat_cmd"
          ],
        collapse = " "
      )

    # format to commandline option
    format_match <-
      data.frame(
        format      = c("df", "json", "csv", "xml"),
        format_cmd  = c("j",  "j",    "d",   "x"),
        stringsAsFactors = FALSE
      )

    format_cmd <-
      paste(
        format_match[
          match(format[1], format_match$format),
          "format_cmd"
          ],
        collapse = " "
      )


    cmd <-
      glue::glue(
        "bash -c ",
        "'",
        "{server_cmd} sadf -h{format_cmd} -- {stat_cmd}",
        "'"
      )

    res <-
      tryCatch(
        expr = {
          R.utils::withTimeout(
            expr =
              {
                system(cmd, intern = TRUE)
              },
            timeout = 5,
            elapsed = 5,
            onTimeout = "error"
          )
        },
        error = function(e){
          warning(e$message)
          character(0)
        }
      )

    paste(res, collapse = "\n")

  }

