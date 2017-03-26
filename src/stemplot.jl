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
                  symbol::AbstractString,
                  scale::Int64)
Arguments
=========
-**`v`** : Vector for which the stem leaf plot should be computed
-**`divider`**: Symbol for break between stem and leaf. Default = "|"
-**`scale`**: Set scale of plot. Default = 10. Scale is changed via orders of magnitude common values are ".1","1"."10".
Results
=======
A plot of object type
TODO
Author(s)
========
- Alex Hallam (Github: https://github.com/alexhallam)
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
function stemplot(
                  v::Vector;
                  divider::AbstractString="|",
                  scale=10
                  )
    v = convert(Array{AbstractFloat,1}, v)
    left_ints,leaves = divrem(sort(v),scale)
    leaves_of_zero_left_ints = leaves[left_ints .==0]
    neg_zero_leaves = leaves_of_zero_left_ints[leaves_of_zero_left_ints.<0]
    pos_zero_leaves = leaves_of_zero_left_ints[leaves_of_zero_left_ints.>=0]

    # Delete pos_zero_leaves that are equal to neg_zero_leaves
    deleteat!(pos_zero_leaves, findin(pos_zero_leaves, neg_zero_leaves))

    # Truncate values, so trailing decimals do not show
    leaves = trunc(Int,leaves*10)
    neg_zero_leaves = trunc(Int,neg_zero_leaves*10)
    pos_zero_leaves = trunc(Int,pos_zero_leaves*10)

    # Create range of values for stems. This is so the empty sets are not missed
    stems = collect(minimum(left_ints) : maximum(left_ints))

    # Get the leaves associated with a given stem
    getleaves(stem) = leaves[left_ints .== stem]

    # Dict mapping stems to leaves
    dict = Dict(stem => getleaves(stem) for stem in stems)

    # Replace values at positive 0 with leaves associated with positive 0 only
    dict[0] = pos_zero_leaves

    # Handle -0 stems and associated leaves
    if any(leaves_of_zero_left_ints .< 0.0)
        dict[-0.0] = neg_zero_leaves
        # Delete negative values in dictionary with 0.0 as stem
        # add -0.0 dict with values
        push!(stems, -0.0)
        sort!(stems)
    end

    # Prep and print stemplot
    # Set pad
    pad = "  "
    one_space = " "
    # width needed for proper formating of stem-to-divider
    max_stem_width = length(string(maximum(round(Int64,stems))))
    println()
    for stem in stems
        stemleaves = dict[stem]
        # print the stem and divider
        each_stem_width = length(string(round(Int64,stem)))
        print(pad, one_space^(max_stem_width+2-each_stem_width), rpad(round(Int64,stem), 1),one_space, divider, " ")
        # if leaves exist print them without dict brackets
        if !isempty(stemleaves)
            leaf_string = string(stemleaves)[2:(end-1)]
            print(replace(leaf_string,r"[,-]",""))
        end
        println()
    end

    # Get and print key
    # Get index of last stem
    key_stem_index = findlast(s -> !isempty(getleaves(stem)),stems)
    # If a key_stem exsits
    if key_stem_index > 0
        key_stem = trunc(Int,stems[key_stem_index])
        # Print first leaf in stem and remove negative on leaf, if leaf is negative.
        key_leaf = norm(dict[key_stem][1])
        if scale == 1
            key_value = round(key_stem*scale+key_leaf*.1,1)
        else
            key_value = round(key_stem*scale+key_leaf,1)
        end
        # println("\n",pad, "Key: $(key_stem)$(divider)$(key_leaf) = $(key_value)")

        # Description of where the decimal is
        ndigits = abs(trunc(Int,log10(scale)))
        right_or_left = ifelse(trunc(Int,log10(scale)) < 0, "left", "right")
        println("\n",pad,"Description: The decimal is $(ndigits) digit(s) to the $(right_or_left) of $(divider)")
    end
end
