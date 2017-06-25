# Author(s)
# ----------
# - Alex Hallam (Github: https://github.com/alexhallam)\n
# - Matthew Amos (Github: https://github.com/equinetic)


"""
```julia
Stemplot(v::AbstractVector{T} where T<:Real;
                  scale=10,
                  precision=1)
```

`v` = vector of real numbers\n
`scale` = base of the stems, default 10\n
`precision` = scale of the leaves, default 1 (no rounding)

"""
struct Stemplot
  left_ints::AbstractVector{AbstractFloat}
  leaves::AbstractVector{AbstractFloat}

  function Stemplot(v::AbstractVector{T} where T <: Real;
                    scale=10,
                    precision=1, args...)
    v = convert(Vector{AbstractFloat}, v)
    divop = divrem.(v, scale)
    left_ints = [x[1] for x in divop]
    leaves = trunc.(Int, round.([x[2] for x in divop]/precision, 0))
    left_ints[(left_ints .== 0) .& (sign.(leaves) .== -1)] = -0.00
    new(left_ints, leaves)
  end

end

function getstems(left_ints::Vector{AbstractFloat}; trim::Bool=false)
  # Stem range => sorted hexadecimal
  stemrng= minimum(left_ints):maximum(left_ints)
  stems = trim ? sort(unique(left_ints)) : sort(unique(vcat(stemrng, left_ints)))
  stems = num2hex.(stems); left_ints = num2hex.(left_ints)
  return stems, left_ints
end

stemplot_getlabel(s) = s == num2hex(-0.) ? "-0" : string(Int(hex2num(s)))
stemplot_getleaf(s, l_i, lv) = join(string.( sort(abs.(trunc.(Int, lv[l_i .== s]))) ))

"""
`stemplot(v; nargs...)`->` Plot`

Description
============
Draws a stem leaf plot of the given vector `v` or a back-to-back
stem and leaf plot of vectors `v1` and `v2`.

Usage
----------
```julia
stemplot(v::Vector,
  scale::Real,
  precision::Real,
  divider::AbstractString,
  padchar::AbstractString,
  trim::Bool)

stemplot(v1::Vector, v2::Vector)

```
Arguments
----------
-**`v`; `v1, v2`**: Vector(s) for which the stem leaf plot should be computed\n
-**`scale`**: Set scale of plot. Default = 10. Scale is changed via
orders of magnitude common values are ".1","1"."10".\n
-**`precision`**: Set precision of plot, defaults to 1. This will reduce the
number of digits in the leaves.\n
-**`divider`**: Symbol for break between stem and leaf. Default = "|"\n
-**`padchar`**: Character(s) to separate stems, leaves and dividers. Default = " "\n
-**`trim`**: Remove stems that do not contain any leaves.

Results
----------
A plot of object type Stemplot

Examples
----------
```julia
stemplot(rand(1:100,80))
stemplot(rand(-100:100,300))
stemplot(randn(50),scale = 1)
     -2 | 00000
     -1 | 0000000
      0 | 00000000000000
      0 | 0000000000000000
      1 | 00000000
    Key: 1|0 = 1.0
    Description: The decimal is 0 digit(s) to the right of |
```

"""
function stemplot(plt::Stemplot;
                  scale=10,
                  precision=1,
                  divider::AbstractString="|",
                  padchar::AbstractString=" ",
                  trim::Bool=false,
                  args...)

  left_ints = plt.left_ints
  leaves = plt.leaves

  stems, left_ints = getstems(left_ints, trim=trim)

  labels = stemplot_getlabel.(stems)
  lbl_len = maximum(length.(labels))
  col_len = lbl_len + 1

  # Stem | Leaf print routine
  for i = 1:length(stems)
    stem = rpad(lpad(labels[i], lbl_len, padchar), col_len, padchar)
    leaf = stemplot_getleaf(stems[i], left_ints, leaves)
    println(stem, divider, padchar, leaf)
  end

  # Print key
  stemplotlegend(scale=scale, precision=precision, divider=divider, args...)
end

# back to back
function stemplot(plt1::Stemplot, plt2::Stemplot;
                  scale=10,
                  precision=1,
                  divider::AbstractString="|",
                  padchar::AbstractString=" ",
                  trim::Bool=false,
                  args...)

  leaves1 = plt1.leaves
  leaves2 = plt2.leaves

  _, li_1  = getstems(plt1.left_ints, trim=trim)
  _, li_2  = getstems(plt2.left_ints, trim=trim)
  stems, _ = getstems(vcat(plt1.left_ints, plt2.left_ints), trim=trim)

  labels = stemplot_getlabel.(stems)
  lbl_len = maximum(length.(labels))
  col_len = lbl_len + 1

  # Stem | Leaf print routine
  left_leaves = [stemplot_getleaf(stems[i],li_1,leaves1) for i=1:length(stems)]
  leftleaf_len = maximum(length.(left_leaves))

  for i = 1:length(stems)
    left_leaf = lpad(reverse(left_leaves[i]), leftleaf_len, padchar)
    right_leaf = stemplot_getleaf(stems[i], li_2, leaves2)
    stem = rpad(lpad(labels[i], col_len, padchar), col_len+1, padchar)
    println(left_leaf, padchar, divider, stem, divider, padchar, right_leaf)
  end

  # Print key
  stemplotlegend(scale=scale, precision=precision, divider=divider, args...)
end

# Prints legend at the end of the plot
function stemplotlegend(;scale=10,
                  precision=1,
                  divider::AbstractString="|",
                  printscale=true,
                  printdecloc=true,
                  printprecision=true, args...)
  if printscale
    println("\nKey: 1$(divider)0 = $(scale)")
  end

  if printdecloc
    ndigits = abs.(trunc(Int,log10(scale)))
    right_or_left = ifelse(trunc(Int,log10(scale)) < 0, "left", "right")
    println("The decimal is $(ndigits) digit(s) to the $(right_or_left) of $(divider)")
  end

  if printprecision && precision != 1
    suffix = get(Dict('1'=>"st",'2'=>"nd",'3'=>"rd"), string(precision)[end],"th")
    println("Leaves are rounded to the nearest $(precision)$(suffix)")
  end

end

# Normal stem plot
function stemplot(v::AbstractVector{T} where T<:Real; args...)
  plt = Stemplot(v; args...)
  stemplot(plt; args...)
end

# Back to back plot
function stemplot(v1::AbstractVector{A} where A<:Real,
                  v2::AbstractVector{B} where B<:Real;
                  args...)
  # Stemplot object
  plt1 = Stemplot(v1; args...)
  plt2 = Stemplot(v2; args...)

  # Dispatch to plot routine
  stemplot(plt1, plt2; args...)
end
