Stemplot
=========

Stemplots in Julia

Installation
------------

```julia
Pkg.clone("https://github.com/alexhallam/Stemplot.jl")
```

Getting Started
----------------

This package has the function `stemplot` which is used to generate
simple stemplots in Julia.

Description
----------------
Draws a stem leaf plot of the given vector `v`.

Usage
----------------
`stemplot(v)`

```
function stemplot(
                  v::Vector,
                  divider::AbstractString,
                  scale::Int64)
```

Arguments
----------------
-**`v`** : Vector for which the stem leaf plot should be computed

-**`divider`**: Symbol for break between stem and leaf. Default = "|"

-**`scale`**: Set scale of plot. Default = 10. Scale is changed via orders of
magnitude common values are ".1","1"."10".

Examples
----------------
```julia
julia> `stemplot(rand(1:100,80))`
```

```julia
julia> `stemplot(rand(-100:100,300))`
```

```julia
julia> `stemplot(randn(50),scale = 1)`
     -2 | 00000
     -1 | 0000000
      0 | 00000000000000
      0 | 0000000000000000
      1 | 00000000
    Key: 1|0 = 1.0
    Description: The decimal is 0 digit(s) to the right of |
```
