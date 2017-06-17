# TODO

- ~~[ ] Create type for stemplot so that it can be updated/refreshed with `stemplot!()`~~
  - Current structure doesn't have mutating parameters
- [x] Add `trim::Bool` parameter to limit output
- [ ] Add `precision::Bool` parameter to round output. Example:

```julia
julia> v = [8,9,43,44]
julia> stemplot(v, scale=100)
0 | 894344

# The 43 and 44 are misleading in this case, so
# a precision parameter may be of use
julia > stemplot(v, scale=100, precision=10)
0 | 0044
```

- [ ] Add `split::Bool` parameter - break a stem across two or more lines if there's
too many digits (or should this be `split::Int`, `maxdigits::Int`...?). For example:

```julia
julia> mystemplot
 0 | 0113
 1 | 0123456789
 2 |
 3 | 88
julia> stemplot!(mystemplot, split=true)
 0 | 0113
 1 | 012345
 1 | 6789
 2 |
 3 | 88
```

- [x] Create method for back-to-back stem plots which can be useful for comparing
distributions:

```julia
julia> stemplot(dataset1, dataset2)
 99832 | 0 | 12339
   210 | 1 | 0012334
       | 2 | 89
  6600 | 3 | 00136
```

- [ ] 0.6 proof everything
- [ ] Update docs
