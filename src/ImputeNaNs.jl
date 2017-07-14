module ImputeNaNs

export locf, locf!

const AbstractIntVec = AbstractVector{T} where T<:Integer
const AbstractFloatVec = AbstractVector{T} where T<:AbstractFloat

include("locf_nans.jl")
include("locf_nulls.jl")

end # module
