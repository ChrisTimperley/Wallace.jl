# Deal with multiple-source nodes.
function build_sync(s::Species, b::FastBreeder)
  
  # For each source used by this breeder, build the preceding set of
  # synchronisation operations and calculate the final state of the
  # representation graph for each, before calculating the synchronisation
  # operations required to produce a complete representation graph for
  # each.
  for child in sources(b)
    rep_graph = build_sync(RepresentationGraph(s), child)
    sync_path = species.full_sync!(rep_graph)
    build_sync(child.eigen, b.eigen, sync_path)
  end

  # Return the built breeder.
  return b
end

build_sync(g::RepresentationGraph, n::SelectionBreederSource) =
  species.initialize!(species.clone(g))

function build_sync(g::RepresentationGraph, n::VariationBreederSource)
  rep_graph::RepresentationGraph = g

  # For each source used by this breeding operator, calculate the shortest chain of
  # synchronisation operations required to generate the stage used by this operator.
  for child in sources(n)
    rep_graph = build_sync(g, child)
    sync_path = species.partial_sync!(rep_graph, n.stage_name)

    # If it's multi-source?
    # Mark all nodes except the edited node as dirty; DODGY.

    # Fetch the eigentypes of the two breeding nodes and implement the synchronisation
    # operation between them.
    build_sync(child.eigen, n.eigen, sync_path)
  end

  # Return the resulting representation graph.
  return rep_graph
end

function build_sync(from::Type, to::Type, ops::Vector{Tuple{AbstractString, AbstractString}})
  body = "function sync{I <: Individual}(from::Type{$(from)}, to::Type{$(to)}, s::Species{I}, inds::Vector{I})\n" *
    join(["convert!(s, \"$(s_from)\", \"$(s_to)\", inds)" for (s_from, s_to) in ops], "\n") *
    "\nreturn inds" *
    "\nend"

  # Dynamically evaluate the function definition
  eval(breeder, Base.parse(body))
end
