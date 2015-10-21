immutable HammingDistance <: Distance
end

"""
The hamming distance between two sequenced collections, or strings, of equal
length is measured as the number of differences between them at each index.
"""
hamming() = HammingDistance()

# Shouldn't be repeating code here.
# Need to find a way to unify these two method headers.
function dist(::HammingDistance, x::DirectIndexString, y::DirectIndexString)
  dst = 0
  for i in 1 : min(length(x), length(y))
    @inbounds if x[i] != y[i]
      dst += 1
    end
  end
  return dst
end

function dist{T}(::HammingDistance, x::Vector{T}, y::Vector{T})
  dst = 0
  for i in 1 : min(length(x), length(y))
    @inbounds if x[i] != y[i]
      dst += 1
    end
  end
  return dst
end
