load("../fitness", dirname(@__FILE__))

type SimpleFitness{T} <: Fitness
  maximise::Bool
  value::T

  SimpleFitness(maximise::Bool, value::T) = 
    new(maximise, value)
end

describe{T}(f::SimpleFitness{T}) = string(f.value)

# Conversion operations.
#Base.string(f::SimpleFitness) = string(f.value)

# Comparison operations.
Base.isless{T}(x::SimpleFitness{T}, y::SimpleFitness{T}) =
  x.maximise && x.value < y.value
Base.isequal{T}(x::SimpleFitness{T}, y::SimpleFitness{T}) = 
  x.value == y.value

register("fitness/simple", SimpleFitness)
