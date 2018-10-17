
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/emillykkejensen/familyR.svg?branch=master)](https://travis-ci.org/emillykkejensen/familyR)

familyR
=======

The goal of familyR is to provide a fast way to get all parents, children and even the entire family tree of a node. It uses nothing but data.table and hence it is fast!

familyR consists of tree main functions: 1. get\_familytree 2. get\_parents 3. get\_children

familyR is built so it is easy to visualize with visNetwork's hierarchical layout as both get\_parents and get\_children include the number of levels (or generations if you will), there are between the node you are looking and other nodes in the family.

Installation
------------

You can install familyR from github with:

``` r
# install.packages("devtools")
devtools::install_github("emillykkejensen/familyR")
```

How to use familyR
------------------

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
  to   = c("B", "C", "D", "E", "E", "B", "Y", "Z")
)
```

Note that in order for it to work, you need to name the two columns "from" and "to" - you can include others if you like, as long as you have from and to!

### The main functions

Now let's try to get the entire family tree of node B.

``` r
my_familytree <- get_familytree(my_network, "C")

print(my_familytree$nodes)
#>    id level
#> 1:  C     0
#> 2:  A     1
#> 3:  E     1
#> 4:  B     1
#> 5:  D     2

print(my_familytree$edges)
#>    from to
#> 1:    A  B
#> 2:    A  C
#> 3:    B  D
#> 4:    B  E
#> 5:    C  E
#> 6:    C  B
```

As you can see the function not only returns the entire family tree of a node B, but also the level (or number of generations) between the node you are looking for (in this case "B") and the other nodes in the family.

By looking at the level column we can see, that node C is directly related to node A, E and B and is related in second generation with node D.

To show this with visNetwork all you need is:

``` r
library(visNetwork)

visNetwork(my_familytree$nodes, my_familytree$edges) %>%
  visEdges(arrows = "to")
```

If we are not interested in the entire family tree, but only want the parents of a node use get\_parents()

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

get\_parents() not only returns the parents of a node, but also the grandparents, grand grandparents etc.

As with get\_familytree() this function also returns both the node id and the level, but here you'll notice that the levels are given a negative value. This is to show the direction of the generation and comes in handy if you want to merge with get\_children().

To get all children of a node use get\_children(). This works exactly like get\_parents(), but returns levels in positive numbers.

### Combining functions

Id you don't want the entire family tree of a node, but would like to get both parents and children you can combine them using merge\_family()

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

This will give you both parents (with a negative level value) and children (with a positive level value) of node C.

As you can see from my\_family$edges, some nodes are internally related (node B and E). If you would like to show, only direct relations to node C and thus remove those inner relations, use the remove\_inner\_relations() function.

``` r
my_new_family <- remove_inner_relations(my_family)

print(my_new_family$nodes)
#>    id level
#> 1:  A    -1
#> 2:  C     0
#> 3:  B     1
#> 4:  E     1
#> 5:  D     2

print(my_new_family$edges)
#>    from to
#> 1:    A  C
#> 2:    B  D
#> 3:    C  E
#> 4:    C  B
```

Now you can use my\_new\_family with visNetwork's visHierarchicalLayout function, that uses the level column.

``` r
visNetwork(my_new_family$nodes, my_new_family$edges) %>% 
    visEdges(arrows = "to") %>%
    visHierarchicalLayout()
```

### Nice to know

familyR uses data.table and thus builds on the principle of changing input by reference. Therefor you need to specify, that you want to copy data from on data.table to another insted of just creating a new reference. To do this, use the copy\_family() function.

``` r
my_copied_family <- copy_family(my_new_family)
```
