function locf(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   v = copy(vec)
   locf!(v)
   return v
end

function locf!(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
    n = length(vec)
    vecidxs = 1:n

    if isnull(vec[1])
       idx = index_first_nonnan(view(vec, vecidxs))
       vec[1:idx-1] = vec[idx]
    end
    if isnull(vec[end])
       idx = index_final_nonnan(view(vec, vecidxs))
       vec[idx+1:end] = vec[idx]
    end

   if any(isnull.(vec))
       n = length(vec)
       null_at = index_nulls(vec)
       vec[null_at] = locf_values(view(vec, vecidxs), view(null_at,1:length(null_at)))
    end
    
    return nothing
end

function locf_values{T<:Real}(vec::V, null_at::I) where I<:AbstractVector{Int} where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
    augment = 0
    deltas = [null_at[1]-1, diff(null_at)...]

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

"""
    index_first_nonnull(vec)
returns 0 if all elements of vec are Null
"""
function index_first_nonnull(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   result = 0
   for i in 1:length(vec)
      if !isnull(vec[i])
         result = i
         break
      end
   end
   return result
end

"""
    index_final_nonnan(vec)
returns 0 if all elements of vec are Null
"""
function index_final_nonnull(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   result = 0
   for i in length(vec):-1:1
      if !isnull(vec[i])
         result = i
         break
      end
   end
   return result
end
