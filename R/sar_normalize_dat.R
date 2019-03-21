#' sar_normalize_dat
#'
#' @param dat single data item from parsed json
#' @param node node name
#'
#' @export
#'
sar_normalize_dat <-
  function(dat, node){

    ts       <- paste(dat$timestamp$date, dat$timestamp$time)
    tspan_s  <- dat$timestamp$interval

    cpu <-
      data.frame(
        ts,
        tspan_s,
        node,
        device   = NA,
        stat     = paste0("cpu_", names(dat$`cpu-load`[[1]])[-1], "_pct"),
        category = "cpu",
        value    = unlist(dat$`cpu-load`[[1]][-1]),
        stringsAsFactors = FALSE
      )

    io <-
      data.frame(
        ts,
        tspan_s,
        node,
        device   = NA,
        stat     = c("io_readwrite_tps", "io_read_tps", "io_read_mb", "io_write_tps", "io_write_mb"),
        category = "io",
        value    = unlist(dat$io),
        stringsAsFactors = FALSE
      )

    io[grepl("_mb", io$stat), "value"] <-
      format(io[grepl("_mb", io$stat), "value"] / 1000000, scientific = FALSE)

    ram <-
      data.frame(
        ts,
        tspan_s,
        node,
        device   = NA,
        stat     =
          gsub(
            "-percent_gb", "_pct",
            paste0(
              "ram_",
              gsub("^mem", "", names(dat$memory)), "_gb"
            )
          ),
        category = "ram",
        value    = unlist(dat$memory),
        stringsAsFactors = FALSE
      )

    ram[grepl("_gb", ram$stat), "value"] <-
      format(ram[grepl("_gb", ram$stat), "value"] / 1000000, scientific = FALSE)


    load <-
      data.frame(
        ts,
        tspan_s,
        node,
        device   = NA,
        stat     =
          c("load_run_queue_n", "load_processes_n",
            "load_average_1_min", "load_average_5_min",
            "load_average_15_min", "load_blocked_n"),
        category = "load",
        value    = unlist(dat$queue),
        stringsAsFactors = FALSE
      )

    network_df <-
      as.data.frame(
        do.call(
          rbind,
          lapply(dat$network[[1]], unlist)
        ),
        stringsAsFactors = FALSE
      )

    tmp_list <- list()
    for ( i in seq_len(nrow(network_df)) ){
      tmp_list[[length(tmp_list)+1]] <-
        data.frame(
          ts,
          tspan_s,
          node,
          device   = network_df[i, 1],
          stat     =
            paste0(
              "net_",
              c("read_pkg_n", "write_pkg_n", "read_kb",
                "write_kb", "read_compressed_kb", "write_compressed_kb",
                "read_multicast_pkg_n", "utilization_pct")
            ),
          category = "net",
          value    = as.vector(t(network_df[i, -1])),
          stringsAsFactors = FALSE
        )
    }

    net <- do.call(rbind, tmp_list)

    # combine data
    df      <- rbind(io, ram, cpu, load, net)
    df$unit <- stringb::text_extract(df$stat, "[a-z]+$")
    df$name <- stringb::text_replace(df$stat, "(^[a-z]+_)(.*?)(_[0-9a-z]+$)", "\\2")
    rownames(df) <- NULL

    df
  }
