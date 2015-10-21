type GaussianMutation{T} <: Mutation
  mean::T
  std::T
  min_value::T
  max_value::T
  rate::Float
  representation::Representation

  GaussianMutation() = new()
  GaussianMutation(mean::T, std::T, rate::Float) =
    new(mean, std, minimum_value(rep), maximum_value(rep), rate)  
end

gaussian_noise{T}(mean::T, std::T) =
  mean + std * sqrt(-2 * log(1 - rand())) * sin(2 * pi * rand())

num_inputs(o::GaussianMutation) = 1
num_outputs(o::GaussianMutation) = 1

function operate!{T}(o::GaussianMutation,
  inputs::Vector{IndividualStage{Vector{T}}})

  # If we knew the length of our genome in advance, how much faster
  # would this operation be?
  for i in 1:length(get(inputs[1]))
    if rand() <= o.rate
      get(inputs[1])[i] += gaussian_noise(o.mean, o.std)
      get(inputs[1])[i] = min(max(get(inputs[1])[i], o.min_value), o.max_value)
    end
  end
  return inputs
end
