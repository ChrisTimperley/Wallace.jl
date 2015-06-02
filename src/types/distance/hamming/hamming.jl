load("../../distance.jl", dirname(@__FILE__))

immutable HammingDistance <: Distance
end

# Shouldn't be repeating code here.
# Need to find a way to unify these two method headers.
function distance(::HammingDistance, x::DirectIndexString, y::DirectIndexString)
  dst = 0
  for i in 1 : min(length(x), length(y))
    @inbounds if x[i] != y[i]
      dst += 1
    end
  end
  return dst
end

function distance{T}(::HammingDistance, x::Vector{T}, y::Vector{T})
  dst = 0
  for i in 1 : min(length(x), length(y))
    @inbounds if x[i] != y[i]
      dst += 1
    end
  end
  return dst
end
