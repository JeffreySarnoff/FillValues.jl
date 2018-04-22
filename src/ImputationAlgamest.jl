"""
    ImputationAlgamest

### datum overwrites imputand
> selected by nearness and oriention

- locf
-- carry prior observation to next time[s]
- focb
-- carry later observation to earlier time[s]

### estimand overwrites imputand
> interpolation, approximation, likelihood, rectification
- linearfit, quadraticfit, cubicfit
- ratio of linear or linear, quadratic or quadratic interpolation
- physiomechanistic resolution
- adjacency weighted neighboring tangencies
"""
module ImputationAlgamest

export locf, locf!, focb, focb!,
       lerp, qlerp

const MaybeInt   = Union{Missing, Int64, Int32}
const MaybeFloat = Union{Missing, Float64, Float32}

const MaybeInts   = AbstractVector{MaybeInt}
const MaybeFloats = AbstractVector{MaybeFloat}


include("locf.jl")
include("lerp.jl")


end # module ImputationAlgamest
