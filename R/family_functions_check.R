family_functions_check <- function(graph_dt, is_family_data = FALSE, verbose = FALSE){

  if(is_family_data){

    if(!all(names(graph_dt) %in% c("nodes", "edges"))) stop("You need to add a list of two data.tables called nodes and edges")

    if(!all(names(graph_dt$nodes) %in% c("name", "level"))) stop("Nodes data.tables needs to have both name and level")

    graph_dt$edges <- family_functions_check(graph_dt$edges, is_family_data = FALSE, verbose = verbose)

  } else {

    if(!is.data.table(graph_dt)){
      graph_dt <- as.data.table(graph_dt)
      if(verbose) warning("I feel the need... The need for speed! Set graph_dt as data.table by default and we won't have to do it.")
    }

    if(any(!(c("source", "target") %in% names(graph_dt)))) stop("You nedd to include source and target in colnames")

    if(!("id" %in% names(graph_dt))) graph_dt[, id := .I]

    if(uniqueN(graph_dt, by = "id") != nrow(graph_dt)) stop("id needs to be unique")

  }

  return(graph_dt)

}
