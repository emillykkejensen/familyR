#' Copy family data
#'
#' Copy one list of familyR data to another.
#'
#' As familyR relies on data.table it also builds on the principle of changing input
#' by reference. Therefor you need to specify, that you want to copy data from on data.table
#' to another insted of just creating a new reference. This is, what the copy_family does.
#'
#' @param graph_dt graph_dt; Graph_dt list of data.tables with edges and nodes
#'
#' @return A copied version of the inputted graph_dt data.tables.
#'
#' @examples
#' my_network <- data.table::data.table(
#'   from = c("A", "A", "B", "C", "X", "Y"),
#'   to = c("B", "C", "D", "E", "Y", "Z")
#' )
#'
#' my_family <- get_familytree(my_network, "B")
#'
#' my_copied_family <- copy_family(my_family)
#'
#' @import data.table
#'
#' @export
copy_family <- function(graph_dt){

  new_nodes <- data.table::copy(graph_dt$nodes)
  new_edges <- data.table::copy(graph_dt$edges)

  return(list(nodes = new_nodes, edges = new_edges))

}
