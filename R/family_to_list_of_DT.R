family_to_list_of_DT <- function(graph_dt, relation_dt, return_nodes, type){

  edges <- graph_dt[id %in% relation_dt$id]
  edges[, id := NULL]

  if(return_nodes){

    if(type == "get_familytree"){

      nodes <- data.table(name = unique(c(edges$source, edges$target)))

    } else {

      if(type == "get_children"){
        primary_node <- "source"
        secondary_node <- "target"
      }

      if(type == "get_parents"){
        primary_node <- "target"
        secondary_node <- "source"
      }

      nodes <- merge(graph_dt, relation_dt, by = "id", all.y = TRUE)
      nodes_primary <- nodes[, .(name = get(primary_node), level = level - 1)][order(level)] %>% unique(by = "name")

      nodes_secondary <- nodes[, .(name = get(secondary_node), level = level)][order(level)] %>% unique(by = "name")
      nodes_secondary <- nodes_secondary[!(name %in% nodes_primary$name)]

      nodes <- rbind(nodes_primary, nodes_secondary) %>% setorder(level)

    }

    if(type == "get_parents") nodes[, level := level * -1]

    return(list(nodes = nodes, edges = edges))

  } else {

    return(edges)

  }

}
