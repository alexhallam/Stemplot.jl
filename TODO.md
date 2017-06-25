# TODO

- ~~[ ] Create type for stemplot so that it can be updated/refreshed with `stemplot!()`~~
  - Current structure doesn't have mutating parameters
- [x] Add `trim::Bool` parameter to limit output
- [x] Add `precision::Bool` parameter to round output.
  - Untested, but complete

Example:
```julia
julia> v = [8,9,43,44]
julia> stemplot(v, scale=100)
0 | 894344

# The 43 and 44 are misleading in this case, so
# a precision parameter may be of use
julia > stemplot(v, scale=100, precision=10)
0 | 1144
```

- ~~[ ] Add `split::Bool` parameter - break a stem across two or more lines if there's
too many digits (or should this be `split::Int`, `maxdigits::Int`...?). For example:~~
  * For now this seems like a feature that would be fairly tedious to incorporate. If there's a need in the future
  perhaps, but it doesn't seem worth reworking the print routine to support splitting at this time.

```julia
julia> mystemplot
 0 | 0113456
 1 | 0123456789
 2 |
 3 | 88
julia> stemplot!(mystemplot, split=true)
 0 | 0113456
 1 | 012345
 1 | 6789
 2 |
 3 | 88

 # or?
 julia> stemplot!(mystemplot, split=true)
 0 | 01134
 0 | 56
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
- [x] Remove repeated code for legend between single and B2B - this can be a separate function
- [x] 0.6 proof everything
- [x] ensure the `where T<:Real` works, and that no strange behavior is occuring across the various parameters
- [x] Update docs
- [x] add tests
- [x] make components of the legend toggle-able
- [x] clean up these arguments, it's a little confusing to follow the bouncing ball
- [x] make indentation consistent
- [ ] ensure we're good with the trim kwarg as trim and not trunc - i accidentally used the former despite the issue discussion
- [ ] move into a fork of UnicodePlots
  - Remember to remove TODO, include README into forked version
  - Get Christopher Stocker's input on general API, decision to use some abstract types for string and float
