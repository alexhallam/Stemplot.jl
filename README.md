Stemplot
=========

[![Project Status: Active a The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

Stemplots in Julia

```julia
julia> stemplot(randn(100),scale = 1)

   -2 | 930
   -1 | 97733330
    0 | 998877776666666555544433333222221100000
    0 | 00001111222222233344444445566777788889
    1 | 0112234468
    2 | 46

  Description: The decimal is 0 digit(s) to the right of |
```

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

     0 | 20304050607070808090
     1 | 1030303060607080
     2 | 010103060709090
     3 | 0102030405060606080
     4 | 020406070
     5 | 102030405060608090
     6 | 105060607080
     7 | 050506070707080
     8 | 20404050607090
     9 | 10203030508080
    10 | 00

  Description: The decimal is 1 digit(s) to the right of |
```

```julia
julia> `stemplot(rand(-100:100,300))`


  -10 | 0
   -9 | 9090808070606050505040403020202000
   -8 | 8080605050404030300000
   -7 | 909090707070707060606050404040402010
   -6 | 90909080806050404040303020201000
   -5 | 9080807070605040303030202020201000
   -4 | 9080808080807070606050505040303020101010
   -3 | 909080707070706060605050403030202020100
   -2 | 808070707070504010
   -1 | 9080808070707060606040200
    0 | 90909080806050504040302010
    0 | 202040404050607080909090
    1 | 101030304040505050607080808090
    2 | 0101030304040506090
    3 | 30303040404040505060607070
    4 | 2030305050505080808090
    5 | 010101020203030303040405060607080
    6 | 0010103040404040505050606070707070808090
    7 | 405050606070809090
    8 | 202020304040505060707070808080
    9 | 010202030303040405060607070809090

  Description: The decimal is 1 digit(s) to the right of |
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
