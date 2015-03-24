load("../mutation", dirname(@__FILE__))

type GaussianMutation{R, T} <: Mutation
  representation::R
  mean::T
  std::T
#  min_value::T
#  max_value::T
  rate::Float

  GaussianMutation(rep::R, mean::T, std::T, rate::Float) =
    new(rep, mean, std, rate)  
  #new(rep, minimum_value(rep), maximum_value(rep), rate)
end

gaussian{T}(mean::T, std::T) =
  mean + std * sqrt(-2 * log(1 - rand())) * sin(2 * pi * rand())

num_inputs(o::GaussianMutation) = 1
num_outputs(o::GaussianMutation) = 1

function operate!{T}(o::GaussianMutation,
  inputs::Vector{IndividualStage{Vector{T}}})

  # If we knew the length of our genome in advance, how much faster
  # would this operation be?
  for i in 1:length(get(inputs[1]))
    if rand() <= o.rate
      get(inputs[1])[i] += gaussian(o.mean, o.std)
    end
  end
  return inputs

end

register("mutation/gaussian", GaussianMutation)
composer("mutation/gaussian") do s
  rep = s["stage"].representation
  GaussianMutation{typeof(rep), codon_type(rep)}(
    rep, s["mean"], s["std"], Base.get(s, "rate", 0.01))
end
