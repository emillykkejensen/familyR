#' @import data.table
family_to_list_of_DT <- function(graph_dt, relation_dt, return_nodes, type){

  if(is.null(relation_dt)){

    return(NULL)

  } else {

    edges <- graph_dt[id %in% relation_dt$id]
    edges[, id := NULL]

    if(return_nodes){

      if(type == "get_familytree"){

        nodes <- rbind(graph_dt[, .(id = id, name = from)], graph_dt[, .(id = id, name = to)])

        nodes <- merge(graph_dt, relation_dt, by = "id", all.y = TRUE)
        nodes <- rbind(nodes[, .(id = from, level)], nodes[, .(id = to, level)]) %>%
          setorder(level) %>%
          unique(by = "id")

      } else {

        if(type == "get_children"){
          primary_node <- "from"
          secondary_node <- "to"
        }

        if(type == "get_parents"){
          primary_node <- "to"
          secondary_node <- "from"
        }

        nodes <- merge(graph_dt, relation_dt, by = "id", all.y = TRUE)
        nodes_primary <- nodes[, .(id = get(primary_node), level = level - 1)][order(level)] %>% unique(by = "id")

        nodes_secondary <- nodes[, .(id = get(secondary_node), level = level)][order(level)] %>% unique(by = "id")
        nodes_secondary <- nodes_secondary[!(id %in% nodes_primary$id)]

        nodes <- rbind(nodes_primary, nodes_secondary) %>% setorder(level)

      }

      if(type == "get_parents") nodes[, level := level * -1]

      return(list(nodes = nodes, edges = edges))

    } else {

      return(edges)

    }

  }

}
