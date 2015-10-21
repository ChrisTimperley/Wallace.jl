load("../mutation",                                 dirname(@__FILE__))
load("../../representation/koza",                   dirname(@__FILE__))
load("../../representation/koza/builder/full/full", dirname(@__FILE__))

type SubtreeMutation <: Mutation
  representation::KozaTreeRepresentation
  rate::Float
  prob_terminal::Float
  min_depth::Int
  max_depth::Int
  max_tree_depth::Int

  SubtreeMutation(rep::KozaTreeRepresentation, rate::Float, pt::Float, mind::Int, maxd::Int) =
    new(rep, rate, pt, mind - 1, maxd - 1, rep.max_depth)
end

num_inputs(o::SubtreeMutation) = 1
num_outputs(o::SubtreeMutation) = 1

function operate!{T <: KozaTree}(o::SubtreeMutation,
  inputs::Vector{IndividualStage{T}})
 
  # Enforce the mutation rate.
  if rand() >= o.rate
    return
  end

  # Select a random node in the tree.
  tree = get(inputs[1])
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

end

register(joinpath(dirname(@__FILE__), "subtree.manifest.yml"))
