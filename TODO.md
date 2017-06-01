# TODO

- [ ] Create type for stemplot so that it can be updated/refreshed with `stemplot!()`
- [ ] Add `trim::Bool` parameter - round down by base *`scale`* to reduce digits
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

- [ ] Create method for back-to-back stem plots which can be useful for comparing
distributions:

```julia
julia> stemplot(dataset1, dataset2)
 99832 | 0 | 12339
   210 | 1 | 0012334
       | 2 | 89
  6600 | 3 | 00136
```
