type SubtreeCrossover <: Crossover
  rate::Float
  max_tries::Int
  max_depth::Int
  rep::Representation.KozaTreeRepresentation

  SubtreeCrossover() =
    new(0.7, 1)
  SubtreeCrossover(rate::Float, max_tries::Int) =
    new(rate, max_tries)
end

"""
Composes a given sub-tree crossover operator.
"""
function compose!(c::SubtreeCrossover, r::Representation)
  c.max_depth = r.max_depth
  c.rep = r
  c
end

"""
TODO: Write representation.subtree
"""
subtree() = subtree(0.7, 1)
subtree(rate::Float) = subtree(rate, 0.7)
subtree(limit::Int) = subtree(0.7, limit)
function subtree(def::Function)
  c = subtree()
  def(c)
  c
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
