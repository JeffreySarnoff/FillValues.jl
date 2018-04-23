# determine if any of an ordered sequence are missing

isnothing(x::Nothing) = true
isnothing(x::T) where {T} = false

issomething(x::Nothing) = false
issomething(x::T) where {T} = true

isNaN(x::AbstractFloat) = isnan(x)
isNaN(x::T) where {T} = false
 
Base.findall(::Type{Missing}, x::AbstractArray{T,N}) = findmissings(x)
Base.findall(::Type{Nothing}, x::AbstractArray{T,N}) = findnothings(x)
Base.findlast(::Type{Missing}, x::AbstractArray{T,N}) = findlast(missing, x)
Base.findlast(::Type{Nothing}, x::AbstractArray{T,N}) = findlast(nothing, x)
Base.findfirst(::Type{Missing}, x::AbstractArray{T,N}) = findfirst(missing, x)
Base.findfirst(::Type{Nothing}, x::AbstractArray{T,N}) = findfirst(nothing, x)

Base.findall(::Type{Float64}, x::AbstractArray{T,N}) = findNaNs(x)
Base.findall(::Type{Float32}, x::AbstractArray{T,N}) = findNaNs(x)
Base.findlast(::Type{Float64}, x::AbstractArray{T,N}) = findlast(isnan, x)
Base.findlast(::Type{Float32}, x::AbstractArray{T,N}) = findlast(isnan, x)
Base.findfirst(::Type{Float64}, x::AbstractArray{T,N}) = findfirst(isnan, x)
Base.findfirst(::Type{Float32}, x::AbstractArray{T,N}) = findfirst(isnan, x)


findmissings(x::AbstractArray{T,N}) where {N,T} = findall(x .=== missing)
findnothings(x::AbstractArray{T,N}) where {N,T} = findall(x .=== nothing)
findNaNs(x::AbstractArray{T,N})     where {N,T} = findall(map(isNaN,x))

findpresents(x::AbstractArray{T,N})   where {N,T} = findall(x .!== missing)
findsomethings(x::AbstractArray{T,N}) where {N,T} = findall(x .!== nothing)
findnonNaNs(x::AbstractArray{T,N})    where {N,T} = findall(map(!isNaN,x))

for T in (:Int8, :Int16, :Int32, :Int64, :Int128,
          :UInt8, :UInt16, :UInt32, :UInt64, :UInt128,
          :Float16, :Float32, :Float64, :String, :Char)
  @eval begin
     removemissings(x::AbstractArray{$T,N}) where {N} = x
     removenothings(x::AbstractArray{$T,N}) where {N} = x
     function removemissings(x::AbstractArray{Union{Missing,$T},N}) where {N}
        result::$T = filter(!ismissing, x)
        return result
     end
     function removenothings(x::AbstractArray{Union{Nothing,$T},N}) where {N}
        result::$T = filter(!isnothing, x)
        return result
     end
     function removeNaNs(x::AbstractArray{Union{Nothing,$T},N}) where {N}
        result::$T = filter(!isNaN, x)
        return result
     end
  end
end


