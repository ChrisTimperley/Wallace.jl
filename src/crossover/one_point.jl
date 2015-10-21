type OnePointCrossover{R} <: Crossover
  rep::R # Is this really necessary?
  rate::Float

  OnePointCrossover(rep::R, rate::Float) = new(rep, rate)
end

"""
Used for composing one point crossover operators.
"""
type OnePointCrossoverBuilder
  rate::Float
  
  OnePointCrossoverBuilder() = new(0.7)
  OnePointCrossoverBuilder(r::Float) = new(r)
end

"""
Composes a one-point crossover operator from a provided definition, for a given
representation.
"""
compose!(c::OnePointCrossoverBuilder, r::Representation) =
  OnePointCrossover{typeof(r)}(r, c.rate)

"""
TODO: Description of one-point crossover.
"""
one_point() = one_point(0.7)
one_point(rate::Float) = OnePointCrossoverBuilder(rate)
function one_point(def::Function)
  b = one_point()
  def(b)
  b
end

num_inputs(o::OnePointCrossover) = 2
num_outputs(o::OnePointCrossover) = 2

function operate!{T}(o::OnePointCrossover,
  inputs::Vector{IndividualStage{Vector{T}}})

  # Enforce the crossover rate.
  rand() > o.rate && return inputs

  # Ensure that the inputs are greater than length 1 (should we do this dynamically?).
  (length(get(inputs[1])) <= 1 || length(get(inputs[2])) <= 1) && return inputs

  # Calculate the crossover point, split A and B into four substrings
  # and combine those substrings to form two children. 
  x = rand(2:(min(length(inputs[1].value), length(inputs[2].value)) - 1))

  # Generate the output chromosomes.
  t = get(inputs[1])[(x + 1):end]
  set(inputs[1], vcat(get(inputs[1])[1:x], get(inputs[2])[(x + 1):end]))
  set(inputs[2], vcat(get(inputs[2])[1:x], t))

  return inputs
end
