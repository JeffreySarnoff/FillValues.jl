# determine if any of an ordered sequence are missing

findmissings(x::AbstractArray{T}) where {T} = findall(x .=== missing)
findpresents(x::AbstractArray{T}) where {T} = findall(x .!== missing)

for T in (:Int8, :Int16, :Int32, :Int64, :Int128,
          :UInt8, :UInt16, :UInt32, :UInt64, :UInt128,
          :Float16, :Float32, :Float64, :String, :Char)
  @eval begin
     removemissings(x::AbstractArray{$T}) = x
     function removemissings(x::AbstractArray{Union{Missing,$T}})
        result::$T = filter(!ismissing, x)
        return result
     end
  end
end
