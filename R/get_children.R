#' Get all parrents of a node
#'
#' get_children() returns all children, grandchildren, grand grandchildren, etc. of your input node.
#'
#' The function takes as its input a data.table (graph_dt) with at least two columns called "from" and "to" and potentially many more.
#'
#'
#' @param graph_dt data.table; A data.table with a "from" and a "to" column. See details for more.
#' @param get_node character; The name of the node(s) who's children you are looking for
#' @param return_nodes logical; If TRUE (default) the function will return both
#' the inputted graph_dt along with a nodes data.table. See return for more.
#'
#' @return It will return the inputtet graph_dt data.table but only with children
#' included.
#' If return_nodes is TRUE it will also retun a data.table with node ids including a
#' column called level showing you how many generations there are between the diffent nodes
#' and the inputted node (get_node).
#' When return_nodes is TRUE it returns both data.tables in a list called nodes and edges.
#'
#' @examples
#' my_network <- data.table::data.table(
#'   from = c("A", "A", "B", "C", "X", "Y", "D"),
#'   to = c("B", "C", "D", "E", "Y", "Z", "E")
#' )
#'
#' my_children <- get_children(my_network, "B")
#'
#' my_children <- get_children(my_network, "X", return_nodes = FALSE)
#'
#' @import data.table
#'
#' @export
get_children <- function(graph_dt, get_node, return_nodes = TRUE){

  graph_dt <- family_functions_check(graph_dt, verbose = TRUE)

  inhouse_get_children <- function(graph_dt, get_node, level = 1, exclude_id = NULL){

    relation_ids <- if(!is.null(exclude_id)){

      graph_dt[(from %in% get_node) & !(id %in% exclude_id$id)]

    } else {

      graph_dt[(from %in% get_node)]

    }

    if(nrow(relation_ids) == 0){

      return(exclude_id)

    } else {

      nodes <- list(nodes = unique(relation_ids$to),
                    ids = data.table(id = relation_ids$id, level = level))

      new_exclude_id <- if(is.null(exclude_id)) nodes$ids else rbind(nodes$ids, exclude_id)
      new_get_node <- unique(c(get_node, nodes$nodes))

      inhouse_get_children(
        graph_dt = graph_dt,
        get_node = new_get_node,
        exclude_id = new_exclude_id,
        level = level + 1
      )

    }

  }

  children <- inhouse_get_children(graph_dt = graph_dt, get_node = get_node)

  children <- family_to_list_of_DT(graph_dt = graph_dt,
                                   relation_dt = children,
                                   return_nodes = return_nodes,
                                   type = "get_children")

  return(children)

}
