load("../mutation", dirname(@__FILE__))
load("../../representation/bit_vector", dirname(@__FILE__))

type BitFlipMutation <: Mutation
  representation::BitVectorRepresentation
  rate::Float

  BitFlipMutation(rep::BitVectorRepresentation, rate::Float) =
    new(rep, rate)
end

num_inputs(o::BitFlipMutation) = 1
num_outputs(o::BitFlipMutation) = 1

function operate!(o::BitFlipMutation,
  inputs::Vector{IndividualStage{Vector{Int}}})
  for i in 1:length(get(inputs[1]))
    if rand() <= o.rate
      if get(inputs[1])[i] == 1
        get(inputs[1])[i] = 0
      else
        get(inputs[1])[i] = 1
      end
    end
  end
  return inputs
end

composer("mutation/bit_flip") do s
  BitFlipMutation(s["stage"].representation, Base.get(s, "rate", 0.01))
end
