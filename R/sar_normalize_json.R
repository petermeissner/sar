#' sar_normalize_json
#'
#' @param json_parsed json parsed to list via jsonlite::fromJSON()
#'
#' @export
#'
sar_normalize_json <-
  function(json_parsed){

    node <- json_parsed$sysstat$hosts[[1]]$nodename
    dats <- json_parsed$sysstat$hosts[[1]]$statistics

    # make worker safe
    worker <-
      purrr::possibly(
        .f        = sar_normalize_dat,
        otherwise = NULL,
        quiet     = FALSE
      )

    # execute on each data item
    df <-
      purrr::map_df(.x = dats, .f = worker, node = node)

    # return
    df
  }
