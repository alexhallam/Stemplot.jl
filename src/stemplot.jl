type Stemplot
  left_ints::Vector{AbstractFloat}
  leaves::Vector{AbstractFloat}

  function Stemplot(v::AbstractVector; scale=10)
    v = convert(Vector{AbstractFloat}, v)
    left_ints, leaves = divrem(v, scale)
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
stemplot_getleaf(s, l_i, lv) = sort(abs.(trunc(Int, lv[l_i .== s])))

"""
`stemplot(v; nargs...)`->` Plot`

Description
============

Draws a stem leaf plot of the given vector `v`.

Usage
----------
```julia
`stemplot(v)`
function stemplot(
                  v::Vector,
                  scale::Int64,
                  divider::AbstractString,
                  padchar::AbstractString)
```
Arguments
----------

-**`v`** : Vector for which the stem leaf plot should be computed

-**`scale`**: Set scale of plot. Default = 10. Scale is changed via orders of magnitude common values are ".1","1"."10".

-**`divider`**: Symbol for break between stem and leaf. Default = "|"

-**`padchar`**: Character(s) to separate stems, leaves and dividers. Default = " "

Results
----------

A plot of object type

Author(s)
----------

- Alex Hallam (Github: https://github.com/alexhallam)

- Matthew Amos (Github: https://github.com/equinetic)

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
function stemplot(plt::Stemplot, scale=10;
                  divider::AbstractString="|",
                  padchar::AbstractString=" ",
                  trim::Bool=false,
                  )

    left_ints = plt.left_ints
    leaves = plt.leaves

    stems, left_ints = getstems(left_ints, trim=trim)

    labels = stemplot_getlabel.(stems)
    lbl_len = maximum(length.(labels))
    col_len = lbl_len + 1

    # Stem | Leaf print routine
    for i = 1:length(stems)
      stem = rpad(lpad(labels[i], lbl_len, padchar), col_len, padchar)
      leaf = join(string.(stemplot_getleaf(stems[i], left_ints, leaves)))
      println(stem, divider, padchar, leaf)
    end

    # Print key
    println("\nKey: 1$(divider)0 = $(scale)")
    # Description of where the decimal is
    ndigits = abs.(trunc(Int,log10(scale)))
    right_or_left = ifelse(trunc(Int,log10(scale)) < 0, "left", "right")
    println("The decimal is $(ndigits) digit(s) to the $(right_or_left) of $(divider)")

end

# back to back
function stemplot(plt1::Stemplot, plt2::Stemplot, scale=10;
                  divider::AbstractString="|",
                  padchar::AbstractString=" ",
                  trim::Bool=false,
                  )

    li_1 = plt1.left_ints
    li_2 = plt2.left_ints
    leaves1 = plt1.leaves
    leaves2 = plt2.leaves

    stems, left_ints = getstems(vcat(li_1, li_2), trim=trim)

    labels = stemplot_getlabel.(stems)
    lbl_len = maximum(length.(labels))
    col_len = lbl_len + 1

    # Stem | Leaf print routine
    for i = 1:length(stems)
      left_leaf = ""
      right_leaf = ""
      stem = ""
      #stem = rpad(lpad(labels[i], lbl_len, padchar), col_len, padchar)
      #leaf = join(string.(stemplot_getleaf(stems[i], left_ints, leaves)))
      println(left_leaf, padchar, divider, stem, divider, padchar, right_leaf)
    end

    # Print key
    println("\nKey: 1$(divider)0 = $(scale)")
    # Description of where the decimal is
    ndigits = abs.(trunc(Int,log10(scale)))
    right_or_left = ifelse(trunc(Int,log10(scale)) < 0, "left", "right")
    println("The decimal is $(ndigits) digit(s) to the $(right_or_left) of $(divider)")

end

# Single
function stemplot(v::AbstractVector, scale=10; args...)
  # Stemplot object
  plt = Stemplot(v, scale=scale)

  # Dispatch to plot routine
  stemplot(plt; args...)
end

# Back to back
function stemplot(v1::AbstractVector, v2::AbstractVector, scale=10; args...)
  # Stemplot object
  plt1 = Stemplot(v1, scale=scale)
  plt2 = Stemplot(v2, scale=scale)

  # Dispatch to plot routine
  stemplot(plt1, pl2; args...)
end

# mutating
function stemplot!()::Stemplot
end
