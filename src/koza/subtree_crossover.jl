type SubtreeCrossover <: Crossover
  stage::AbstractString
  rate::Float
  max_tries::Int
  max_depth::Int
  rep::KozaTreeRepresentation

  SubtreeCrossover(stage::AbstractString, rate::Float, max_tries::Int, max_depth::Int, rep::KozaTreeRepresentation) =
    new(stage, rate, max_tries, max_depth, rep)
end

"""
Provides a definition for a subtree crossover operator.
"""
type SubtreeCrossoverDefinition <: CrossoverDefinition
  """
  The name of the stage that this operator works on.
  """
  stage::AbstractString

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

  SubtreeCrossoverDefinition(stage::AbstractString, r::Float, mt::Int) =
    new(stage, r, mt)
end

"""
Composes a given sub-tree crossover operator from its definition.
"""
function compose!(c::SubtreeCrossoverDefinition, sp::Species)
  c.stage = c.stage == "" ? genotype(sp).label : c.stage
  r = sp.stages[c.stage].representation
  SubtreeCrossover(c.stage, c.rate, c.max_tries, r.max_depth, r)
end

"""
TODO: Write koza.subtree_crossover documentation.
"""
subtree_crossover() = subtree_crossover("", 0.7, 1)
subtree_crossover(stage::AbstractString) =
  subtree_crssover(stage, 0.7, 1)
subtree_crossover(rate::Float) = subtree_crossover("", rate, 1)
subtree_crossover(limit::Int) = subtree_crossover("", 0.7, limit)
subtree_crossover(stage::AbstractString, rate::Float) =
  subtree_crossover(stage, rate, 1)
subtree_crossover(stage::AbstractString, limit::Int) =
  subtree_crossover(stage, 0.7, limit)
subtree_crossover(rate::Float, limit::Int) = subtree_crossover("", rate, limit)
subtree_crossover(stage::AbstractString, rate::Float, limit::Int) =
  SubtreeCrossoverDefinition(stage, rate, limit)
function subtree_crossover(def::Function)
  c = subtree_crossover()
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
  outputs::Vector{IndividualStage{T}},
  x::T,
  y::T
)
  # Enforce the crossover rate
  rand() > o.rate && return

  # Choose a node at random from the first tree.
  nx = sample(x)
  
  # Continue to sample nodes from the 2nd tree until either a viable
  # crossover candidate has been found, or till a maximum number of
  # attempts have passed.
  for i in 1:o.max_tries
    ny = sample(y)
    if  (depth(ny) + height(nx) - 1) <= o.max_depth &&
        (depth(nx) + height(ny) - 1) <= o.max_depth
      swap!(ny, nx)
      break
    end
  end
end
