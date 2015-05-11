load("parent",  dirname(@__FILE__))
load("node",    dirname(@__FILE__))
load("input",   dirname(@__FILE__))

abstract KozaTree <: KozaParent
function ComposeKozaTree(inputs::Vector{KozaInput})
  t = anonymous_type(Wallace, "type <: KozaTree
    root::KozaNode

    constructor() = new()
    constructor(n::KozaNode) = new(n)
  end")

  # Implement the execution method for this tree type.
  src = join([["_t::$(t)"], ["$(a.label)::$(a.ty)" for a in inputs]], ",")
  src = "execute($(src)) = execute($(join([["_t.root"], [
  a.label for a in inputs]], ",")))"
  println(src)
  eval(Wallace, Base.parse(src))

  # Implement the cloning method for this tree type.

  return t
end

clone{T <: KozaTree}(t::T) = T(clone(t.root), t)
sample(t::KozaTree) = sample(t.root)
isroot(n::KozaNode) = isa(n.parent, KozaTree)
num_nodes(t::KozaTree) = num_nodes(t.root)
height(t::KozaTree) = height(t.root)
describe(t::KozaTree) = describe(t.root)

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
