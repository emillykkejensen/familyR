family_functions_check <- function(graph_dt, verbose = FALSE){

  library(data.table)
  library(magrittr)

  if(!is.data.table(graph_dt)){
    graph_dt <- as.data.table(graph_dt)
    if(verbose) warning("I feel the need... The need for speed! Set graph_dt as data.table by default and we won't have to do it.")
  }

  if(any(!(c("source", "target") %in% names(graph_dt)))) stop("You nedd to include source and target in colnames")

  if(!("id" %in% names(graph_dt))) graph_dt[, id := .I]

  if(uniqueN(graph_dt, by = "id") != nrow(graph_dt)) stop("id needs to be unique")

  return(graph_dt)

}
