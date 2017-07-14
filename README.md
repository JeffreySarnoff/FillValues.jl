# ImputeNaNs.jl

### fills NaN or Null values using last observation carry forward (locf)

#### Copyright © 2017 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/FillValues.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/FillValues.jl)
-----

# exports

locf, locf!

# use

```julia
using ImputeNaNs

vec = [NaN, 1.0, NaN, 2.0, NaN, NaN]
locf(vec)
# [1.0, 1.0, 1.0, 2.0, 2.0, 2.0]
locf(vec, false)
# [NaN, 1.0, 1.0, 2.0, 2.0, 2.0]
```

# note

Also works with Nullables.
