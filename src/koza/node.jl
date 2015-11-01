"""
The base type used by all nodes within a Koza tree.
"""
abstract KozaNode <: KozaParent

"""
Returns a randomly selected node from a given sub-tree.
"""
sample(n::KozaNode) = search(n, rand(1:num_nodes(n)))

"""
Calculates the depth of a node within the tree which it belongs to.
"""
function depth(n::KozaNode)
  i = 1
  while !isroot(n)
    n = n.parent
    i += 1
  end
  return i
end

"""
Performs a breadth-first search of a sub-tree rooted at a given node, n, for
the node at location p.
"""
function search(n::KozaNode, p::Int)
  i = 1
  q = KozaNode[n]
  
  # We don't actually have to check this...
  # We could just keep popping nodes?
  while !isempty(q)
    n = pop!(q) # pop vs. shift
    if i == p
      return n 
    end
    if isa(n, KozaNonTerminal)
      append!(q, n.children)
    end
    i += 1
  end
end
