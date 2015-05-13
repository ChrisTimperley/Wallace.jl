load("../crossover", dirname(@__FILE__))

type OnePointCrossover{R} <: Crossover
  rep::R
  rate::Float

  OnePointCrossover(rep::R, rate::Float) = new(rep, rate)
end

# Returns the number of inputs to this operation.
num_inputs(o::OnePointCrossover) = 2

# Returns the number of outputs produced by this operation.
num_outputs(o::OnePointCrossover) = 2

function operate!{T}(o::OnePointCrossover,
  inputs::Vector{IndividualStage{Vector{T}}})

  # Enforce the crossover rate.
  if rand() > o.rate
    return
    #return inputs
  end

  # Ensure that the inputs are greater than length 1 (should we do this dynamically?).
  if length(get(inputs[1])) <= 1 || length(get(inputs[2])) <= 1
    return
    #return inputs
  end

  # Calculate the crossover point, split A and B into four substrings
  # and combine those substrings to form two children. 
  x = rand(2:(min(length(inputs[1].value), length(inputs[2].value)) - 1))

  # Generate the output chromosomes.
  t = get(inputs[1])[(x + 1):end]
  set(inputs[1], vcat(get(inputs[1])[1:x], get(inputs[2])[(x + 1):end]))
  set(inputs[2], vcat(get(inputs[2])[1:x], t))

  return inputs

end

composer("crossover/one_point") do s
  rep = s["stage"].representation
  OnePointCrossover{typeof(rep)}(rep, Base.get(s, "rate", 0.7))
end
