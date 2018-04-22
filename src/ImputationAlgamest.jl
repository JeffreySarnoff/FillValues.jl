module ImputationAlgamest

export locf, locf!, lerp, qlerp

const Ints   = Union{Int32, Int64}
const Floats = Union{Float32, Float64}

const MaybeInt    = Union{Missing, Ints}
const MaybeFloat  = Union{Missing, Floats}

const MaybeInts   = AbstractVector{MaybeInt}
const MaybeFloats = AbstractVector{MaybeFloat}

include("locf.jl")
include("lerp.jl")

end # ImputationAlgamest
