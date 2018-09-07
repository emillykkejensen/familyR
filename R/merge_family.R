#' Merge family data
#'
#' Use merge_family() to merge family data into one list.
#'
#' @param ... graph_dt; Graph_dt data.tables from get_children(), get_parents() or get_familytree()
#'
#' @return merge_family() will return the inputted graph_dt data.tables
#' merged together in one list (containing nodes and edges).
#'
#' @examples
#' my_network <- data.table::data.table(
#'   from = c("A", "A", "B", "C", "X", "Y"),
#'   to = c("B", "C", "D", "E", "Y", "Z")
#' )
#'
#' my_parents <- get_parents(my_network, "B")
#' my_children <- get_children(my_network, "B")
#'
#' merged_family <- merge_family(my_parents, my_children)
#'
#' @export
merge_family <- function(...){

  list_of_family <- list(...)

  list_of_nodes <- lapply(seq(list_of_family), function(x) list_of_family[[x]]$nodes)

  list_of_edges <- lapply(seq(list_of_family), function(x) list_of_family[[x]]$edges)

  merged_nodes <- data.table::rbindlist(list_of_nodes, use.names = TRUE, fill = TRUE)

  if(nrow(merged_nodes) > 0) merged_nodes <- unique(merged_nodes) %>% data.table::setorder(level)

  merged_edges <- data.table::rbindlist(list_of_edges, use.names = TRUE, fill = TRUE)

  return(list(nodes = merged_nodes, edges = merged_edges))

}
