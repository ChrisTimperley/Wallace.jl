type OnePointCrossover{R} <: Crossover
  stage::AbstractString
  rep::R # Is this really necessary?
  rate::Float

  OnePointCrossover(stage::AbstractString, rep::R, rate::Float) =
    new(stage, rep, rate)
end

"""
Used for composing one point crossover operators.
"""
type OnePointCrossoverDefinition <: CrossoverDefinition
  stage::AbstractString
  rate::Float
  
  OnePointCrossoverDefinition() = new("", 0.7)
  OnePointCrossoverDefinition(r::Float) = new("", r)
  OnePointCrossoverDefinition(s::AbstractString) = new(s, 0.7)
  OnePointCrossoverDefinition(s::AbstractString, r::Float) = new(s, r)
end

"""
Composes a one-point crossover operator from a provided definition, for a given
species.
"""
function compose!(c::OnePointCrossoverDefinition, sp::Species)
  c.stage = c.stage == "" ? genotype(sp).label : c.stage
  OnePointCrossover{typeof(r)}(c.stage, r, c.rate)
end

"""
TODO: Description of one-point crossover.
"""
one_point() = one_point(0.7)
one_point(rate::Float) = OnePointCrossoverDefinition(rate)
one_point(stage::AbstractString) = OnePointCrossoverDefinition(stage, 0.7)
one_point(stage::AbstractString, rate::Float) =
  OnePointCrossoverDefinition(stage, rate)
function one_point(def::Function)
  d = one_point()
  def(d)
  d
end

num_inputs(o::OnePointCrossover) = 2
num_outputs(o::OnePointCrossover) = 2

function operate!{T}(o::OnePointCrossover, inputs::Vector{T})
  # Enforce the crossover rate.
  rand() > o.rate && return inputs

  # Ensure that the inputs are greater than length 1 (should we do this dynamically?).
  (length(inputs[1]) <= 1 || length(inputs[2]) <= 1) && return inputs

  # Calculate the crossover point, split A and B into four substrings
  # and combine those substrings to form two children. 
  x = rand(2:(min(length(inputs[1]), length(inputs[2])) - 1))

  # Generate the output chromosomes.
  t = inputs[1][(x + 1):end]
  inputs[1] = vcat(inputs[1][1:x], inputs[2][(x + 1):end])
  inputs[2] = vcat(inputs[2][1:x], t)

  return inputs
end
