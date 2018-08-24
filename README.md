
<!-- README.md is generated from README.Rmd. Please edit that file -->
familyR
=======

The goal of familyR is to provide a fast way to get all parents, children and even the entire family tree of a node. It uses nothing but data.table and hence it is fast!

Installation
------------

You can install familyR from github with:

``` r
# install.packages("devtools")
devtools::install_github("emillykkejensen/familyR")
```

Example
-------

First load the package - note, that familyR relies hevyly on the data.table package.

``` r

library(familyR)
#> Loading required package: data.table
#> Loading required package: magrittr
```

To use familyR you need a data.table of relations like so:

``` r
my_network <- data.table::data.table(
  source = c("A", "A", "B", "B", "C", "C", "X", "Y"),
  target = c("B", "C", "D", "E", "E", "B", "Y", "Z")
)
```

Note that in order for it to work, you need to name the two columns "source" and "target" - you can include others if you like, as long as you have source and target!

Now let's try to get the entire family tree of node B.

``` r

my_familytree <- get_familytree(my_network, "B")

print(my_familytree$nodes)
#>    name
#> 1:    A
#> 2:    B
#> 3:    C
#> 4:    D
#> 5:    E

print(my_familytree$edges)
#>    source target
#> 1:      A      B
#> 2:      A      C
#> 3:      B      D
#> 4:      B      E
#> 5:      C      E
#> 6:      C      B
```

If we on the other hand only want the parents of a node, use get\_parents()

``` r

my_parents <- get_parents(my_network, "D")

print(my_parents$nodes)
#>    name level
#> 1:    D     0
#> 2:    B    -1
#> 3:    C    -2
#> 4:    A    -2

print(my_parents$edges)
#>    source target
#> 1:      A      B
#> 2:      A      C
#> 3:      B      D
#> 4:      C      B
```

As you can see the function not only returns the parents of a node, but also the grandparents, grand grandparents etc. and the function even includes the level (or number of generations) between the node you are looking for (in this case "D") and the other parent nodes in the family.

Parents are given a negative value in level, whereas children are given a positive value.

``` r

my_children <- get_children(my_network, "A")

print(my_children$nodes)
#>    name level
#> 1:    A     0
#> 2:    B     1
#> 3:    C     1
#> 4:    D     2
#> 5:    E     2

print(my_children$edges)
#>    source target
#> 1:      A      B
#> 2:      A      C
#> 3:      B      D
#> 4:      B      E
#> 5:      C      E
#> 6:      C      B
```

If you would like to remove inner relations for your parents or children, you can use the remove\_inner\_relations() function.

``` r

my_new_children <- remove_inner_relations(my_children)

print(my_new_children$edges)
#>    source target
#> 1:      A      B
#> 2:      A      C
#> 3:      B      D
#> 4:      B      E
#> 5:      C      E
```
