load("../mutation", dirname(@__FILE__))

type UniformMutation{R, T} <: Mutation
  representation::R
  min_value::T
  max_value::T
  rate::Float

  UniformMutation(rep::R, rate::Float) =
    new(rep, minimum_value(rep), maximum_value(rep), rate)
end

# Returns the number of inputs to this operation.
num_inputs(o::UniformMutation) = 1

# Returns the number of outputs produced by this operation.
num_outputs(o::UniformMutation) = 1

function operate!{T}(o::UniformMutation,
  inputs::Vector{IndividualStage{Vector{T}}})

  # If we knew the length of our genome in advance, how much faster
  # would this operation be?
  for i in 1:length(get(inputs[1]))
    if rand() <= o.rate
      get(inputs[1])[i] = rand(o.min_value:o.max_value)
    end
  end
  return inputs

end

register("mutation/uniform", UniformMutation)
composer("mutation/uniform") do s
  rep = s["stage"].representation
  UniformMutation{typeof(rep), codon_type(rep)}(
    rep, Base.get(s, "rate", 0.01))
end
