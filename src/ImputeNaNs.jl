module ImputeNaNs

export locf, locf!

const AbstractIntVec = AbstractVector{T} where T<:Integer
const AbstractFloatVec = AbstractVector{T} where T<:AbstractFloat
const NullableNumVec = AbstractVector{N} where N<:Nullable{T} where T

include("locf_nans.jl")
include("locf_nulls.jl")

end # module
