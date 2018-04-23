const OneToZero = Base.OneTo(0)

for (Q,F) in ((:Missing, :findmissings), (:Nothing, :findnothings))
  @eval begin    
    function locf(::Type{$Q}, data::AbstractArray{T,1}) where {T<:IntFloat}
        indices = $F(data)
        return if isempty(indicies)
                   data
               else
                   locf($Q, data, indicies)
               end
    end

    function locf(::Type{$Q}, data::AbstractArray{T,1}, indicies) where {T} 
        # cannot carry forward into data[bgn] 
        if indicies[1] === 1
            indicies = length(indicies) === 1 ? OneToZero : indicies[2:end]
        end
   
        while !isempty(indices)
           prior_indicies = indicies - 1
           data[indices] = data[prior_indicies]
           indices = $F(data)
        end
        return data
    end

    function locf(::Type{$Q}, data::AbstractArray{T,2}) where {T<:IntFloat}
        axs1, axs2 = axes(data)
        datavec = Vector{T}(undef, axs1.stop)
        for ax in axs2
            datavec[:] = data[axs1, ax]
            isnothing(findfirst($F, datavec)) && continue
            data[axs1, ax] = locf($Q, datavec)
        end
        return data
    end
  end
end










#=


"""
   locf(vec [, fillback]) is "last observation carry forward"

Overwrite NaNs [Nulls] with the prior non-NaN [non-Null] values.

If fillback=true (default) and vec starts with NaNs [Nulls],
vec starts with NaNs [Nulls], those values will be overwritten
with the first non-NaN [non-Null] value.
"""
function locf(vec::AbstractFloatVec, fillback::Bool)
   idx = index_first_nonnan(vec)
   v = locf(vec)
   if fillback==false && idxhttps://github.com/JuliaArrays/EndpointRanges.jl > 1
      v[1:idx-1] = NaN
   end
   return v
end

function locf(vec::AbstractFloatVec)
   v = copy(vec)
   locf!(v)
   return v
end


"""
   locf!(vec [, fillback]) is "last observation carry forward" in place

Overwrite NaNs [Nulls] with the prior non-NaN [non-Null] values

If fillback=true (default) and vec starts with NaNs [Nulls],
those values will be overwritten with the first non-NaN [non-Null] value.
"""
function locf!(vec::AbstractFloatVec, fillback::Bool)
   idx = index_first_nonnan(vec)
   locf!(vec)
   if fillback==false && dx > 1
      vec[1:idx-1] = NaN
   end
   return nothing
end

function locf!(vec::AbstractFloatVec)
    n = length(vec)
    vecidxs = 1:n

    if isnan(vec[1])
       idx = index_first_nonnan(view(vec, vecidxs))
       if idx != 0
           vec[1:idx-1] = vec[idx]
       end
    end
    if isnan(vec[end])
       idx = index_final_nonnan(view(vec, vecidxs))
       if idx != 0
          vec[idx+1:end] = vec[idx]
       end
    end

    if any(isnan.(vec))
       n = length(vec)
       nans_at = index_nans(vec)
       if n > length(nans_at)
           vec[nans_at] = locf_values(view(vec, vecidxs), view(nans_at,1:length(nans_at)))
      end
    end

    return nothing
end

function locf_values(vec::AbstractFloatVec, nans_at::AbstractIntVec)
    augment = 0
    deltas = [nans_at[1]-1, diff(nans_at)...]

    for i in 2:length(deltas)
        if deltas[i] == 1
            augment += 1
            deltas[i] = 0
        else
            deltas[i] += augment
            augment = 0
        end
    end

    return cumsum(deltas)
end

function index_nans(vec::AbstractFloatVec)
    idxs = 1:length(vec)
    nans = map(isnan, view(vec,idxs))
    return idxs[nans]
end

"""
    index_first_nonnan(vec)

returns 0 iff all elements of vec are NaN
"""
function index_first_nonnan(vec::AbstractFloatVec)
   result = 0
   for i in 1:length(vec)
      if !isnan(vec[i])
         result = i
         break
      end
   end
   return result
end

"""
    index_final_nonnan(vec)

returns 0 iff all elements of vec are NaN
"""
function index_final_nonnan(vec::AbstractFloatVec)
   result = 0
   for i in length(vec):-1:1
      if !isnan(vec[i])
         result = i
         break
      end
   end
   return result
end

=#
