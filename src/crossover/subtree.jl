load("../crossover", dirname(@__FILE__))
load("../../representation/koza", dirname(@__FILE__))

type SubtreeCrossover <: Crossover
  rep::KozaTreeRepresentation
  rate::Float
  max_depth::Int
  max_tries::Int

  SubtreeCrossover(rep::KozaTreeRepresentation, rate::Float, max_tries::Int) =
    new(rep, rate, rep.max_depth, max_tries)
end

num_inputs(o::SubtreeCrossover) = 2
num_outputs(o::SubtreeCrossover) = 2

function operate!{T <: KozaTree}(o::SubtreeCrossover,
  inputs::Vector{IndividualStage{T}})

  if rand() > o.rate
    return
  end

  # Choose a node at random from the first tree.
  nx = sample(get(inputs[1]))
  
  # Continue to sample nodes from the 2nd tree until either a viable
  # crossover candidate has been found, or till a maximum number of
  # attempts have passed.
  for i in 1:o.max_tries
    ny = sample(get(inputs[2]))
    if  (depth(ny) + height(nx) - 1) <= o.max_depth &&
        (depth(nx) + height(ny) - 1) <= o.max_depth
      swap!(ny, nx)
      break
    end
  end

end

register(joinpath(dirname(@__FILE__), "subtree.manifest.yml"))
