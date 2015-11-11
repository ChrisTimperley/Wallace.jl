type SubtreeCrossover <: Crossover
  rate::Float
  max_tries::Int
  max_depth::Int
  rep::KozaTreeRepresentation

  SubtreeCrossover() =
    new(0.7, 1)
  SubtreeCrossover(rate::Float, max_tries::Int) =
    new(rate, max_tries)
end

"""
Provides a definition for a subtree crossover operator.
"""
type SubtreeCrossoverDefinition <: CrossoverDefinition

  """
  The crossover rate for this operator, i.e. the probability that a given pair
  of trees will be subject to crossover.
  """
  rate::Float

  """
  The maximum number of tries that the operator when attempting to make a
  viable crossover before giving up.
  """
  max_tries::Int

  SubtreeCrossoverDefinition() = new(0.7, 1)
  SubtreeCrossoverDefinition(r::Float) = new(r, 1)
  SubtreeCrossoverDefinition(r::Float, mt::Int) = new(r, mt)
end

"""
Composes a given sub-tree crossover operator from its definition.
"""
function compose!(c::SubtreeCrossoverDefinition, r::KozaTreeRepresentation)
  op = SubtreeCrossover(c.rate, c.max_tries)
  op.max_depth = r.max_depth
  op.rep = r
  op
end

"""
TODO: Write koza.subtree documentation.
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

"""
Performs a sub-tree crossover on a pair of provided Koza trees (belonging to
the same species).
"""
function operate!{T <: KozaTree}(
  o::SubtreeCrossover,
  inputs::Vector{IndividualStage{T}}
)
  # Enforce the crossover rate
  rand() > o.rate && return

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
