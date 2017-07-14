module ImputeNaNs

export locf, locf!

const AbstractFloatVec = AbstractVector{T} where T<:AbstractFloat

include("locf_nans.jl")
include("locf_nulls.jl")

end # module
