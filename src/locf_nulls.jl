function locf(vec::V, fillback::Bool) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   idx = index_first_nonnull(vec)
   v = locf(vec)
   if !fillback && idx > 1
      v[1:idx-1] = vec[1:idx-1]
   end
   return v
end

function locf(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   v = copy(vec)
   locf!(v)
   return v
end

function locf!(vec::V, fillback::Bool) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
   idx = index_first_nonnull(vec)
   if !fillback && idx > 1
      vecstart = vec[1:idx-1]
   end   
   locf!(vec)
   if !fillback && idx > 1
       vec[1:idx-1] = vecstart
   end
   return nothing
end

function locf!(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
    n = length(vec)
    vecidxs = 1:n

    if isnull(vec[1])
       idx = index_first_nonnull(view(vec, vecidxs))
       if idx != 0
           vec[1:idx-1] = vec[idx]
       end
    end
    if isnull(vec[end])
       idx = index_final_nonnull(view(vec, vecidxs))
       if idx != 0
           vec[idx+1:end] = vec[idx]
       end     
    end

   if any(isnull.(vec))
       n = length(vec)
       nulls_at = index_nulls(vec)
       if n > length(nulls_at)
           vec[nulls_at] = locf_values(view(vec, vecidxs), view(nulls_at,1:length(nulls_at)))
       end  
    end
    
    return nothing
end

function locf_values(vec::V, nulls_at::I) where I<:AbstractVector{Int} where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
    augment = 0
    deltas = [nulls_at[1]-1, diff(nulls_at)...]

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

function index_nulls(vec::V) where V<:AbstractVector{N} where N<:Nullable{T} where T<:Number
    idxs = 1:length(vec)
    nulls = map(isnull, view(vec,idxs))
    return idxs[nulls]
end   

"""
    index_first_nonnull(vec)

returns 0 iff all elements of vec are Null
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
    index_final_nonnull(vec)

returns 0 iff all elements of vec are Null
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
