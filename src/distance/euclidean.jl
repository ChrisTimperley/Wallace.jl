immutable EuclideanDistance <: Distance; end

"""
Measures the euclidean distance between two vectors.
"""
euclidean() = EuclideanDistance()

distance(::EuclideanDistance, x::Number, y::Number) = abs(x - y)

function distance{T <: Number}(::EuclideanDistance, x::Vector{T}, y::Vector{T})
  d = zero(T)
  for (a, b) in zip(x, y)
    d += (a - b) ^ 2
  end
  return d
end
