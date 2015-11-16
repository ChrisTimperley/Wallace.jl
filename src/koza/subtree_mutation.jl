type SubtreeMutation <: Mutation
  stage::AbstractString
  representation::KozaTreeRepresentation
  rate::Float
  prob_terminal::Float
  min_depth::Int
  max_depth::Int
  max_tree_depth::Int

  SubtreeMutation(stage::AbstractString, rep::KozaTreeRepresentation, rate::Float, pt::Float, mind::Int, maxd::Int) =
    new(stage, rep, rate, pt, mind - 1, maxd - 1, rep.max_depth)
end

"""
Provides a definition for a subtree mutation operator.
"""
type SubtreeMutationDefinition <: MutationDefinition
  """
  The name of the stage that this operator works on.
  """
  stage::AbstractString

  """
  The mutation rate for this operator determines the probability that a given
  individual will be subject to subtree mutation.
  """
  rate::Float

  """
  The probability of selecting a termainl when generating within the subtree.
  """
  p_terminal::Float

  """
  The minimum depth of the generated sub-tree.
  """
  min_depth::Int

  """
  The maximum depth of the generated sub-tree.
  """
  max_depth::Int

  SubtreeMutationDefinition() = new("", 0.01, 0.5, 1, 5)
end

"""
TODO: Description of sub-tree mutation operator.
"""
function subtree_mutation(def::Function)
  d = SubtreeMutationDefinition()
  def(d)
  d
end

"""
Composes a subtree mutation operator from a provided definition.
"""
function compose!(def::SubtreeMutationDefinition, sp::Species)
  def.stage = def.stage == "" ? genotype(sp).label : def.stage
  r = sp.stages[def.stage].representation
  SubtreeMutation(def.stage, r, def.rate, def.p_terminal, def.min_depth, def.max_depth)
end

num_inputs(o::SubtreeMutation) = 1
num_outputs(o::SubtreeMutation) = 1

"""
Performs subtree mutation on a provided Koza tree.
"""
function operate!{T <: KozaTree}(
  o::SubtreeMutation,
  stage::IndividualStage{T}
)
  # Enforce the mutation rate.
  rand() >= o.rate && return

  # Select a random node in the tree.
  tree = get(stage)
  n1 = sample(tree)
  d = depth(n1)

  # Choose the depth to grow the tree till.
  td = min(o.max_tree_depth, d + rand(o.min_depth:o.max_depth))

  # Grow the sub-tree to a depth between its current and maximum depth
  # and insert it into the tree at the position of the selected node.
  n2 = build(KozaGrowBuilder,
    o.representation,
    n1.parent,
    d,
    td,
    o.prob_terminal)
  swap!(n1.parent, n1, n2)
  
  return
end
