#' sar_exec_sadf
#'
#' @param statistic Statistics to retreive.
#' @param format Only first item will be used. The format of data to produce.
#' @param server optional server to get statistics from - if set, function
#'   will try to ssh into server and retrieve statitics otherwise it will
#'   retrieve statistics from local machine
#' @param day optional; either a positive number indicating the calender day or a negative number indicating the number of days before today
#' @param log_path optional; a path to look for dat files
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
    server    = NULL,
    day       = NULL,
    log_path  = NULL
  ){

    # server
    server_cmd   <-
      if ( length(server) > 0 & !all(is.na(server)) ){
        glue::glue("ssh {server} ")
      } else {
        ""
      }

    # log path
    if ( !is.null(day)  & !all(is.na(day)) ){
      if ( day > 0  ){
        if ( is.null(log_path) ){
          if ( system(glue::glue("{server_cmd}ls /var/log/sysstat/"), wait = TRUE, ignore.stdout = TRUE) == 0 ) {
            log_path <- "/var/log/sysstat/"
          } else if ( system(glue::glue("{server_cmd}ls /var/log/sa"), wait = TRUE, ignore.stdout = TRUE) == 0 ) {
            log_path <- "/var/log/sa"
          } else {
            stop("I do not know which path to use.")
          }
        } else {
          # do nothing
        }
        day      <- substring(paste0("0", day), nchar(day), nchar(day)+1)
        path_cmd <- glue::glue("{log_path}/sa{day}")
      } else {
        path_cmd <- glue::glue("{day}")
      }

    } else {
      path_cmd <- ""
    }


    # statistic to commandline option
    stat_match <-
      data.frame(
        statistic = c("cpu", "ram", "network", "io", "load"),
        stat_cmd  = c("-u",  "-r",  "-n DEV",  "-b", "-q"  ),
        stringsAsFactors = FALSE
      )

    stat_matched <- stat_match[match(statistic, stat_match$statistic), "stat_cmd"]

    if ( any(is.na(stat_matched)) ){
      stop(
        "statistic could not be matched: \n\n",
        paste(statistic, collapse = ", "), " -->\n\n",
        paste(utils::capture.output(print(stat_match)), collapse = "\n")
      )
    }

    stat_cmd <- paste(stat_matched,collapse = " ")

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
        "{server_cmd}sadf -h{format_cmd} -- {stat_cmd} {path_cmd}",
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

    # return
    paste(res, collapse = "\n")
  }

