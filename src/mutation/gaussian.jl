"""
Used to provide a definition for a Gaussian mutation operator.
"""
type GaussianMutationDefinition <: MutationDefinition
  stage::AbstractString
  rate::Float
  mean::Float
  std::Float

  GaussianMutationDefinition() = new("", 0.01, 0.0, 1.0) 
  GaussianMutationDefinition(stage::AbstractString) = new(stage, 0.01, 0.0, 1.0)
  GaussianMutationDefinition(r::Float) = new("", r, 0.0, 1.0)
  GaussianMutatianDefinition(r::Float, u::Float, s::Float) =
    new("", r, u, s)
  GaussianMutationDefinition(stage::AbstractString, r::Float, u::Float, s::Float) =
    new(stage, r, u, s)
end

"""
Composes a Gaussian mutation operator from a provided definition.
"""
function compose!(d::GaussianMutationDefinition, sp::Species)
  d.stage = d.stage == "" ? genotype(sp).label : d.stage
  GaussianMutation{Float}(d.mean, d.std, d.rate, r)
end

type GaussianMutation{T <: Number} <: Mutation
  stage::AbstractString
  mean::T
  std::T
  min_value::T
  max_value::T
  rate::Float
  representation::Representation

  GaussianMutation(stage::AbstractString, mean::T, std::T, rate::Float, rep::Representation) =
    new(stage, mean, std, representation.minimum_value(rep), representation.maximum_value(rep), rate, rep)
end

"""
TODO: DESCRIPTION OF GAUSSIAN MUTATION.
"""
gaussian() = GaussianMutationDefinition()
gaussian(rate::Float) = GaussianMutationDefinition(rate)
gaussian(stage::AbstractString) = GaussianMutationDefinition(stage)
gaussian(rate::Float, mean::Float, std::Float) =
  GaussianMutationDefinition(rate, mean, std)
gaussian(stage::AbstractString, rate::Float, mean::Float, std::Float) =
  GaussianMutationDefinition(stage, rate, mean, std)
function gaussian(f::Function)
  def = GaussianMutationDefinition()
  f(def)
  def
end

"""
Produces some Gaussian noise from a given distribution, specified by its mean
and standard deviation.
"""
gaussian_noise{T <: Number}(mean::T, std::T) =
  mean + std * sqrt(-2 * log(1 - rand())) * sin(2 * pi * rand())

function mutate!{T <: Number}(o::GaussianMutation, input::Vector{T})
  # If we knew the length of our genome in advance, how much faster
  # would this operation be?
  for i in 1:length(input)
    if rand() <= o.rate
      input[i] += gaussian_noise(o.mean, o.std)
      input[i] = min(max(input[i], o.min_value), o.max_value)
    end
  end
  return input
end
