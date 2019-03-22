#' plot.sar_df
#'
#' @param x
#' @param y
#' @param ...
#'
#' @export
#'
#' @examples
plot.sar_df <- function(x, y, ...){
  net_read_pkg_n

  all     <-
  cpu     <- x[x$category == "cpu",]
  ram     <- x[x$category == "ram",]
  network <- x[x$category == "network",]
  io      <- x[x$category == "io",]
  load    <- x[x$category == "load",]
}
