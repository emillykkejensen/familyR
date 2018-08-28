#' Get the entire family tree of a node
#'
#' get_familytree() returns all nodes even remotely connected to your input node.
#' So not only will it return all parents, grandparents, grand grandparents, etc.,
#' children, grandchildren, grand grandchildren, etc., but also the parents, grandparents
#' and so on for those parents and children.
#'
#' The function takes as its input a data.table (graph_dt) with at least two columns called "from" and "to" and potentially many more.
#'
#'
#' @param graph_dt data.table; A data.table with a "from" and a "to" column. See details for more.
#' @param get_node character; The name of the node(s) who's family tree you want
#' @param return_nodes logical; If TRUE (default) the function will return both
#' the inputted graph_dt along with a nodes data.table. See return for more.
#'
#' @return It will return the inputted graph_dt data.table but only with family members included.
#'
#' If return_nodes is TRUE it will also retun a data.table with node ids including a
#' column called level showing you how many generations there are between the diffent nodes
#' and the inputted node (get_node).
#'
#' When return_nodes is TRUE it returns both data.tables in a list called nodes and edges.
#'
#' @examples
#' my_network <- data.table::data.table(
#'   from = c("A", "A", "B", "C", "X", "Y"),
#'   to = c("B", "C", "D", "E", "Y", "Z")
#' )
#'
#' # -------------------------------
#' get_familytree(my_network, "B")
#'
#'
#' # -------------------------------
#' get_familytree(my_network, "X", return_nodes = FALSE)
#'
#'
#'
#' @export
get_familytree <- function(graph_dt, get_node, return_nodes = TRUE){

  graph_dt <- family_functions_check(graph_dt, verbose = TRUE)

  inhouse_get_familytree <- function(graph_dt, get_node, level = 1, exclude_id = NULL){

    relation_ids <- if(!is.null(exclude_id)){

      graph_dt[(from %in% get_node | to %in% get_node) & !(id %in% exclude_id$id)]

    } else {

      graph_dt[(from %in% get_node | to %in% get_node)]

    }

    if(nrow(relation_ids) == 0){

      return(exclude_id)

    } else {

      nodes <- list(nodes = unique(c(relation_ids$from, relation_ids$to)),
                    ids = data.table(id = relation_ids$id, level = level))

      new_exclude_id <- if(is.null(exclude_id)) nodes$ids else rbind(nodes$ids, exclude_id)
      new_get_node <- unique(c(get_node, nodes$nodes))

      inhouse_get_familytree(
        graph_dt = graph_dt,
        get_node = new_get_node,
        exclude_id = new_exclude_id,
        level = level + 1)

    }

  }

  familytree_dt <- inhouse_get_familytree(graph_dt = graph_dt, get_node = get_node)

  family <- family_to_list_of_DT(graph_dt = graph_dt,
                                 relation_dt = familytree_dt,
                                 return_nodes = return_nodes,
                                 type = "get_familytree")

  if(return_nodes & !is.null(family)) family$nodes[id %in% get_node, level := 0] %>% setorder(level)

  return(family)
}
