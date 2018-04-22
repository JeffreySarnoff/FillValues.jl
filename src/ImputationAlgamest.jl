module ImputationAlgamest

export locf, locf!, lerp, qlerp,
       findmissings, findpresents, removemissings,
       findnothings, findsomethings, removenothings,
       findNaNs, findnonNaNs, removeNaNs,
       isnothing, issomething

const Ints   = Union{Int32, Int64}
const Floats = Union{Float32, Float64}

const MaybeInts    = Union{Missing, Ints}
const MaybeFloats  = Union{Missing, Floats}

const ExtentInts   = Union{Nothing, Ints}
const ExtentFloats = Union{Nothing, Floats}

include("indicies.jl")  #  index non-values
include("locf.jl")      #  last observation carrys forward 
include("lerp.jl")      #  simple and weighted interpolations
include("getset.jl")    #  datavector's access and restorage smoothified

end # ImputationAlgamest
