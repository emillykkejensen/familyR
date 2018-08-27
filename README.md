
<!-- README.md is generated from README.Rmd. Please edit that file -->
familyR
=======

The goal of familyR is to provide a fast way to get all parents, children and even the entire family tree of a node. It uses nothing but data.table and hence it is fast!

familyR consists of tree main functions: 1: get\_familytree 2: get\_parents 3: get\_children

familyR is built so it is easy to visualize with visNetwork's hierarchical layout as both get\_parents and get\_children include the number of levels (or generations if you will), there are between the node you are looking and other nodes in the family.

Installation
------------

You can install familyR from github with:

``` r
# install.packages("devtools")
devtools::install_github("emillykkejensen/familyR")
```

Example
-------

First load the package - note, that familyR relies heavily on data.table.

``` r
library(familyR)
#> Loading required package: data.table
#> Loading required package: magrittr
```

To use familyR you need a data.table of relations:

``` r
my_network <- data.table::data.table(
  from = c("A", "A", "B", "B", "C", "C", "X", "Y"),
  to = c("B", "C", "D", "E", "E", "B", "Y", "Z")
)
```

Note that in order for it to work, you need to name the two columns "from" and "to" - you can include others if you like, as long as you have from and to!

Now let's try to get the entire family tree of node B.

``` r
my_familytree <- get_familytree(my_network, "B")

print(my_familytree$nodes)
#>    id
#> 1:  A
#> 2:  B
#> 3:  C
#> 4:  D
#> 5:  E

print(my_familytree$edges)
#>    from to
#> 1:    A  B
#> 2:    A  C
#> 3:    B  D
#> 4:    B  E
#> 5:    C  E
#> 6:    C  B
```

To show this with visNetwork all you need is:

``` r
library(visNetwork)

visNetwork(my_familytree$nodes, my_familytree$edges) %>%
  visEdges(arrows = "to")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-402c746f1fa9147755e8">{"x":{"nodes":{"id":["A","B","C","D","E"]},"edges":{"from":["A","A","B","B","C","C"],"to":["B","C","D","E","E","B"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
If we on the other hand only want the parents of a node, use get\_parents()

``` r
my_parents <- get_parents(my_network, "D")

print(my_parents$nodes)
#>    id level
#> 1:  D     0
#> 2:  B    -1
#> 3:  C    -2
#> 4:  A    -2

print(my_parents$edges)
#>    from to
#> 1:    A  B
#> 2:    A  C
#> 3:    B  D
#> 4:    C  B
```

As you can see the function not only returns the parents of a node, but also the grandparents, grand grandparents etc. and the function even includes the level (or number of generations) between the node you are looking for (in this case "D") and the other parent nodes in the family.

Parents are given a negative value in level, whereas children are given a positive value.

To use this with visNetwork simply run:

``` r
visNetwork(my_parents$nodes, my_parents$edges) %>% 
  visEdges(arrows = "to") %>%
  visHierarchicalLayout()
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-c9f16666290cf02f52c9">{"x":{"nodes":{"id":["D","B","C","A"],"level":[-0,-1,-2,-2]},"edges":{"from":["A","A","B","C"],"to":["B","C","D","B"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"},"layout":{"hierarchical":{"enabled":true}}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
To get all children of a node, use get\_children()

``` r
my_children <- get_children(my_network, "A")

print(my_children$nodes)
#>    id level
#> 1:  A     0
#> 2:  B     1
#> 3:  C     1
#> 4:  D     2
#> 5:  E     2

print(my_children$edges)
#>    from to
#> 1:    A  B
#> 2:    A  C
#> 3:    B  D
#> 4:    B  E
#> 5:    C  E
#> 6:    C  B
```

``` r
visNetwork(my_children$nodes, my_children$edges) %>% 
    visEdges(arrows = "to") %>%
    visHierarchicalLayout()
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-fad83f164f4d193d86af">{"x":{"nodes":{"id":["A","B","C","D","E"],"level":[0,1,1,2,2]},"edges":{"from":["A","A","B","B","C","C"],"to":["B","C","D","E","E","B"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"},"layout":{"hierarchical":{"enabled":true}}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
To show both parents and children combine the two functions with merge\_family.

``` r
my_parents <- get_parents(my_network, "C")

my_children <- get_children(my_network, "C")

my_family <- merge_family(my_parents, my_children)

print(my_family$nodes)
#>    id level
#> 1:  A    -1
#> 2:  C     0
#> 3:  B     1
#> 4:  E     1
#> 5:  D     2

print(my_family$edges)
#>    from to
#> 1:    A  C
#> 2:    B  D
#> 3:    B  E
#> 4:    C  E
#> 5:    C  B
```

``` r
visNetwork(my_family$nodes, my_family$edges) %>% 
    visEdges(arrows = "to") %>%
    visHierarchicalLayout()
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-9271c6d876af61d4b00e">{"x":{"nodes":{"id":["A","C","B","E","D"],"level":[-1,-0,1,1,2]},"edges":{"from":["A","B","B","C","C"],"to":["C","D","E","E","B"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"},"layout":{"hierarchical":{"enabled":true}}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
As you can see, some nodes are internally related (node B and E). If you would like to remove those inner relations use the remove\_inner\_relations() function.

``` r
my_new_family <- remove_inner_relations(my_family)

visNetwork(my_new_family$nodes, my_new_family$edges) %>% 
    visEdges(arrows = "to") %>%
    visHierarchicalLayout()
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-6f69063ca42c64590465">{"x":{"nodes":{"id":["A","C","B","E","D"],"level":[-1,-0,1,1,2]},"edges":{"from":["A","B","C","C"],"to":["C","D","E","B"]},"nodesToDataframe":true,"edgesToDataframe":true,"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":"to"},"layout":{"hierarchical":{"enabled":true}}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null,"background":"rgba(0, 0, 0, 0)"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
