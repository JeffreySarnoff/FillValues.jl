module ImputationAlgamest

export locf, locf!, lerp, qlerp,
       findmissings, findpresents, removemissings

const Ints   = Union{Int32, Int64}
const Floats = Union{Float32, Float64}

const MaybeInt    = Union{Missing, Ints}
const MaybeFloat  = Union{Missing, Floats}

const MaybeInts   = AbstractVector{MaybeInt}
const MaybeFloats = AbstractVector{MaybeFloat}

include("indicies.jl")  #  index non-values
include("locf.jl")      #  last observation carrys forward 
include("lerp.jl")      #  simple and weighted interpolations
include("getset.jl")    #  datavector's access and restorage smoothified

end # ImputationAlgamest
