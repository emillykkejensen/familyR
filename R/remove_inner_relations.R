#' Remove all inner relations in a network
#'
#' remove_inner_relations() removes all inner relations in a network - see examples for more...
#'
#' The function takes as its input a graph_dt from either get_parents() or get_children() with at least three columns called "source", "target" and "level" potentially many more.
#'
#'
#' @param graph_dt data.table; A data.table with a "source", a "target" and a "level" column. See details for more.
#'
#' @return It will return the inputted graph_dt data.table but with all
#' inner relations removed. See examples.
#'
#' @examples
#'
#' my_network <- data.table::data.table(
#'   source = c("A", "B", "B", "C", "C", "E"),
#'   target = c("B", "C", "D", "E", "B", "A")
#' )
#'
#' # -------------------------------
#' my_children <- get_children(my_network, "A")
#'
#' remove_inner_relations(my_children)
#'
#'
#' # -------------------------------
#' my_parents <- get_parents(my_network, "E")
#'
#' remove_inner_relations(my_parents)
#'
#'
#' @export
remove_inner_relations <- function(graph_dt){

  graph_dt <- family_functions_check(graph_dt, is_family_data = TRUE, verbose = TRUE)

  edges <- copy(graph_dt$edges)
  nodes <- copy(graph_dt$nodes)

  edges <- edges[source != target]

  for(col in unique(nodes$level)){
    col_ids <- nodes[level == col, name]
    edges <- edges[!((source %in% col_ids) & (target %in% col_ids))]
  }

  for(col in -1:min(nodes$level)){
    col_ids <- nodes[level == col, name]
    exclude_cols <- nodes[level %in% c((col-1):min(nodes$level)), name]
    edges <- edges[!((source %in% col_ids) & (target %in% exclude_cols))]
  }

  for(col in 1:max(nodes$level)){
    col_ids <- nodes[level == col, name]
    exclude_cols <- nodes[level %in% c((col+1):max(nodes$level)), name]
    edges <- edges[!((source %in% exclude_cols) & (target %in% col_ids))]
  }

  edges[, id := NULL]

  return(list(nodes = nodes, edges = edges))

}
