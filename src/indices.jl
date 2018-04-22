# determine if any of an ordered sequence are missing

isnothing(x::Nothing) = true
isnothing(x::T) where {T} = false

isNaN(x::Number) = isnan(x)
isNaN(x::T) where {T} = false
          
findmissings(x::AbstractArray{T,N}) where {N,T} = findall(x .=== missing)
findnothings(x::AbstractArray{T,N}) where {N,T} = findall(x .=== nothing)
findNaNs(x::AbstractArray{T,N})     where {N,T} = findall(map(isNaN,x))

findpresents(x::AbstractArray{T,N})  where {N,T} = findall(x .!== missing)
findsomethigs(x::AbstractArray{T,N}) where {N,T} = findall(x .!== nothing)
findnonNaNs(x::AbstractArray{T,N})   where {N,T} = findall(map(!isNaN,x))

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


