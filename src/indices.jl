# determine if any of an ordered sequence are missing

findmissings(x::AbstractArray{T}) where {T} = findall(x .=== missing)
findpresents(x::AbstractArray{T}) where {T} = findall(x .!== missing)

