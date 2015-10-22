include("graph/node.jl")

export  RepresentationGraph

# Representation graphs are used to indicate whether particular stages
# of an individual are synchronised with the genome.
type RepresentationGraph
  nodes::Dict{AbstractString, RepresentationGraphNode}

  # Produces the representation graph for a given species.
  RepresentationGraph(s::Species) =
    RepresentationGraph([RepresentationGraphNode(stv) for (stl, stv) in s.stages])

  # Constructs a representation graph from a list of provided
  # representation graph nodes.
  RepresentationGraph(nodes::Vector{RepresentationGraphNode}) = begin
    
    # Construct a map storing each node within the graph by its label.
    node_map = Dict{AbstractString, RepresentationGraphNode}()
    for n in nodes
      node_map[n.label] = n
    end

    # Determine the list of sources for each node within the graph. 
    for (label, node) in node_map
      if !isroot(node)
        node.sources = [node_map[node.parent]]
      end
    end

    # Determine the list of destinations and Lamarckian links for
    # each node within the graph.
    for (label, node) in node_map
      if !isroot(node)
        push!(node_map[node.parent].destinations, node)
        if node.lamarckian
          push!(node_map[node.parent].sources, node)
          push!(node.destinations, node_map[node.parent])
        end
      end
    end

    # For each node, determine the list of nodes which it can ultimately reach,
    # and which nodes can ultimately reach it.
    for node in nodes
      node.can_reach = find_reachable(node)
      node.can_reach_from = find_reachable_from(node)
    end

    # Construct the representation graph using the prepared map of
    # nodes within the graph.
    return new(node_map)

  end
end

function describe(g::RepresentationGraph)
  for n in nodes(g)
    if n.clean
      status = "CLEAN"
    else
      status = "DIRTY"
    end
    println("$(n.label) <$(status)>")
  end
end

function path_to_clean(from::RepresentationGraphNode)
  path = RepresentationGraphNode[from]
  paths = Vector{RepresentationGraphNode}[path]
  while !path[1].clean
    path = pop!(paths)

    # Create a new branch for each unvisited node.
    for src in path[1].sources
      if src != path[1]
        push!(paths, [[src], path])
      end
    end
  end
  return [n.label for n in path]
end

# Returns a list of all the nodes which can be reached from a given node.
function find_reachable(node::RepresentationGraphNode)
  target = node
  q = [node]
  reachable = RepresentationGraphNode[]
  buffer = RepresentationGraphNode[]
  while !isempty(q)
    node = shift!(q)
    buffer = filter(d -> d != target && !in(d, reachable), node.destinations)
    reachable = vcat(reachable, buffer)
    q = vcat(q, buffer)
  end
  return reachable
end

# Returns a list of all the nodes from which this node can be reached.
function find_reachable_from(node::RepresentationGraphNode)
  target = node
  q = [node]
  reachable_from = RepresentationGraphNode[]
  buffer = RepresentationGraphNode[]
  while !isempty(q)
    node = shift!(q)
    buffer = filter(d -> d != target && !in(d, reachable_from), node.sources)
    reachable_from = vcat(reachable_from, buffer)
    q = vcat(q, buffer)
  end
  return reachable_from
end

# Returns a list of the nodes within a given representation graph.
nodes(g::RepresentationGraph) = collect(values(g.nodes))

# Initialises the representation graph for a given species by marking all
# nodes as dirty, except for the canonical genotype.
function initialize!(g::RepresentationGraph)
  for node in nodes(g)
    node.clean = isroot(node)
  end
  return g
end

# Produces a deep clone of a given representation graph.
clone(g::RepresentationGraph) =
  RepresentationGraph([copy(n) for n in nodes(g)])

# Returns all clean nodes within a given representation graph.
find_clean(g::RepresentationGraph) = filter(n -> n.clean, nodes(g))

# Calculates the chain of synchronisation operations required to sync a given
# stage within the representation graph. Marks all nodes along the chain as
# clean thereafter, before touching the edited node and dirtying any nodes
# reachable from the edited node.
function partial_sync!(g::RepresentationGraph, s::AbstractString)
  # Calculate the shortest path to synchronising the requested stage.
  path = path_to_clean(g.nodes[s])  

  # Mark all the nodes along the path as clean.
  for label in path
    g.nodes[label].clean = true
  end

  # Mark all reachable nodes as dirty.
  for n in g.nodes[s].can_reach
    g.nodes[n.label].clean = false
  end

  # Return the chain of operations (as a vector of pairs) required to synchronise
  # the representation graph for the desired operation.
  return Tuple{AbstractString, AbstractString}[
    (path[i], path[i + 1]) for i in 1:(length(path) - 1)]
end

# Calculates the chain of synchronisation operations required to fully
# synchronise all the stages of a given representation graph. Marks all
# nodes within the graph as clean thereafter.
function full_sync!(g::RepresentationGraph)
  ops = Tuple{AbstractString, AbstractString}[]
  q = find_clean(g)
  while !isempty(q)
    n1 = pop!(q)
    for n2 in n1.destinations
      if !n2.clean
        n2.clean = true
        push!(q, n2)
        push!(ops, (n1.label, n2.label))
      end
    end
  end
  return ops
end
