"""
The base type used by all koza trees. A new, concrete type is dynamically
created for each problem, tailored to its specifics, giving it a higher level
of performance. This has the effect of essentially creating a highly optimised
interpreter for each problem.
"""
abstract KozaTree <: KozaParent

"""
Constructs the koza tree type for a given problem, based on the inputs to that
tree.
"""
function compose_tree_type(inputs::Vector{KozaInput})
  # Generate an anonymous type for the tree.
  t = anonymous_type(koza, "type <: KozaTree
    root::KozaNode

    constructor() = new()
    constructor(n::KozaNode) = new(n)
  end")

  # Implement the execution method for this tree type.
  src = join(vcat(["_t::$(t)"], ["$(a.label)::$(a.ty)" for a in inputs]), ",")
  src = "execute($(src)) = execute($(join(vcat(["_t.root"], [
  a.label for a in inputs]), ",")))"
  eval(koza, Base.parse(src))

  # Implement the cloning method for this tree type.
  return t
end

"""
Produces a deep-clone of a provided Koza Tree.
"""
clone{T <: KozaTree}(t::T) = T(clone(t.root), t)

"""
Selects a node from a provided Koza Tree at random uniformly.
"""
sample(t::KozaTree) = sample(t.root)

"""
Determines whether a given node is the root of the tree to which it belongs.
"""
isroot(n::KozaNode) = isa(n.parent, KozaTree)

"""
Returns the number of nodes in a given Koza Tree.
"""
num_nodes(t::KozaTree) = num_nodes(t.root)
height(t::KozaTree) = height(t.root)

"""
Produces a string-based description of a given Koza Tree.
"""
describe(t::KozaTree) = describe(t.root)

"""
Destructively swaps the position of two given nodes within the same Koza Tree.
"""
function swap!(n1::KozaNode, n2::KozaNode)
  t = n1.parent
  swap!(n2.parent, n2, n1)
  swap!(t, n1, n2)
end
function swap!(parent::KozaNode, child::KozaNode, with::KozaNode)
  parent.children[findfirst(parent.children, child)] = with
  with.parent = parent
end
function swap!(parent::KozaTree, child::KozaNode, with::KozaNode)
  parent.root = with
  with.parent = parent
end
