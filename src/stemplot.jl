"""
`stemplot(v; nargs...)`->` Plot`
Description
===========
Draws a stem leaf plot of the given vector `v`.
Usage
=====
`stemplot(v)`
function stemplot(
                  v::Vector,
                  scale::Int64,
                  divider::AbstractString,
                  padchar::AbstractString)
Arguments
=========
-**`v`** : Vector for which the stem leaf plot should be computed
-**`scale`**: Set scale of plot. Default = 10. Scale is changed via orders of magnitude common values are ".1","1"."10".
-**`divider`**: Symbol for break between stem and leaf. Default = "|"
-**`padchar`**: Character(s) to separate stems, leaves and dividers. Default = " "
Results
=======
A plot of object type

Author(s)
========
- Alex Hallam (Github: https://github.com/alexhallam)
- Matthew Amos (Github: https://github.com/equinetic)
Examples
========
`stemplot(rand(1:100,80))`
`stemplot(rand(-100:100,300))`
`stemplot(randn(50),scale = 1)`
     -2 | 00000
     -1 | 0000000
      0 | 00000000000000
      0 | 0000000000000000
      1 | 00000000
    Key: 1|0 = 1.0
    Description: The decimal is 0 digit(s) to the right of |
See Also
========
`histogram`
"""
function stemplot(v::AbstractVector;
                  scale=10,
                  divider::AbstractString="|",
                  padchar::AbstractString=" "
                  )
  v = convert(Vector{AbstractFloat}, v)

  # Initial Stems, Leaves
  left_ints, leaves = divrem(v, scale)

  # Negative zeros => -0.00
  left_ints[(left_ints .== 0) .& (sign.(leaves) .== -1)] = -0.00

  # Stem range => sorted hexadecimal
  stems= minimum(left_ints):maximum(left_ints)
  stems = sort(unique(vcat(stems, left_ints)))
  stems = num2hex.(stems); left_ints = num2hex.(left_ints)

  getlabel(s) = s == num2hex(-0.) ? "-0" : string(Int(hex2num(s)))
  getleaf(stem) = sort(abs.(trunc.(Int, leaves[left_ints .== stem])))

  labels = getlabel.(stems)
  lbl_len = maximum(length.(labels))
  col_len = lbl_len + 1

  # Stem | Leaf print routine
  for i = 1:length(stems)
    stem = rpad(lpad(labels[i], lbl_len, padchar), col_len, padchar)
    leaf = join(string.(getleaf(stems[i])))
    println(stem, divider, padchar, leaf)
  end

  # Print key
  println("\nKey: 1$(divider)0 = $(scale)")
  # Description of where the decimal is
  ndigits = abs.(trunc.(Int,log10(scale)))
  right_or_left = ifelse(trunc.(Int,log10(scale)) < 0, "left", "right")
  println("The decimal is $(ndigits) digit(s) to the $(right_or_left) of $(divider)")
end
