"""
   locf(vec) is "last observation carry forward"
overwrite NaNs [Nulls] with the prior non-NaN [non-Null] value
If vec starts with NaNs [Nulls], those values will be overwritten
with the first non-NaN [non-Null] value.
"""
function locf(vec::V) where V<:AbstractVector{T} where T<:AbstractFloat
   v = copy(vec)
   locf!(v)
   return v
end

"""
   locf!(vec) is "last observation carry forward"
overwrite NaNs [Nulls] with the prior non-NaN [non-Null] value
If vec starts with NaNs [Nulls], those values will be overwritten
with the first non-NaN [non-Null] value.
"""
function locf!(vec::V) where V<:AbstractVector{T} where T<:AbstractFloat
    n = length(vec)
    vecidxs = 1:n

    if isnan(vec[1])
       idx = index_first_nonnan(view(vec, vecidxs))
       vec[1:idx-1] = vec[idx]
    end
    if isnan(vec[end])
       idx = index_final_nonnan(view(vec, vecidxs))
       vec[idx+1:end] = vec[idx]
    end

   if any(isnan.(vec))
       n = length(vec)
       nans_at = index_nans(vec)
       vec[nans_at] = locf_values(view(vec, vecidxs), nans_at)
    end
    
    return nothing
end

function locf_values(vec::V, nans_at::I) where I<:AbstractVector{Int} where V<:AbstractVector{T} where T<:AbstractFloat
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

function index_nans(vec::V) where V<:AbstractVector{T} where T<:AbstractFloat
    idxs = 1:length(vec)
    nans = map(isnan, view(vec,idxs))
    return idxs[nans]
end

"""
    index_first_nonnan(vec)

returns 0 if all elements of vec are NaN
"""
function index_first_nonnan(vec::V) where V<:AbstractVector{F} where F<:AbstractFloat
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

returns 0 if all elements of vec are NaN
"""
function index_final_nonnan(vec::V) where V<:AbstractVector{F} where F<:AbstractFloat
   result = 0
   for i in length(vec):-1:1
      if !isnan(vec[i])
         result = i
         break
      end
   end
   return result
end
