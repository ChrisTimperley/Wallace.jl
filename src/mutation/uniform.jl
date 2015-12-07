type UniformMutation{R, T} <: Mutation
  stage::AbstractString
  representation::R
  min_value::T
  max_value::T
  rate::Float

  UniformMutation(stage::AbstractString, rep::R, rate::Float) =
    new(stage, rep, minimum_value(rep), maximum_value(rep), rate)
end

"""
Provides a definition for a uniform mutation operator.
"""
type UniformMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float
end

"""
Composes a uniform mutation operator from its definition.
"""
function compose!(d::UniformMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  UniformMutation(d.stage, d.rate, r)
end

"""
TODO: Describe uniform mutation.

**Parameters:**
* `stage::AbstractString`, the name of the developmental stage that this
  operator should be applied to. Defaults to the genotype if no stage is
  specified.
* `rate::Float`, the probability of a bit flip at any given index.
  Defaults to 0.01 if no rate is provided.
"""
uniform() = uniform(0.01)
uniform(rate::Float) = uniform("", rate)
uniform(stage::AbstractString) = uniform(stage, 0.01)
uniform(stage::AbstractString, rate::Float) =
  UniformMutationDefinition(stage, rate)

"""
Returns the number of inputs to this operation.
"""
num_inputs(o::UniformMutation) = 1

"""
Returns the number of outputs produced by this operation.
"""
num_outputs(o::UniformMutation) = 1

function mutate!{T}(o::UniformMutation, input::Vector{T})
  # If we knew the length of our genome in advance, how much faster
  # would this operation be?
  for i in 1:length(input)
    if rand() <= o.rate
      input[i] = rand(o.min_value:o.max_value)
    end
  end
  return input
end
