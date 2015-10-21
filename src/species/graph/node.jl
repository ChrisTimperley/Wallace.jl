# Stores the details of a node within a representation graph.
type RepresentationGraphNode
  label::AbstractString
  parent::AbstractString
  clean::Bool
  lamarckian::Bool
  destinations::Vector{RepresentationGraphNode}
  sources::Vector{RepresentationGraphNode}
  can_reach::Vector{RepresentationGraphNode}
  can_reach_from::Vector{RepresentationGraphNode}

  # Creates a new representation graph node from a given species stage.
  RepresentationGraphNode(s::SpeciesStage) =
    RepresentationGraphNode(s.label, s.parent, false, s.lamarckian)

  # Creates a new child node using a given label, a parent node, a clean flag
  # and a lamarckian flag.
  RepresentationGraphNode(label::AbstractString, parent::AbstractString, clean::Bool, lamarckian::Bool) =
    new(label, parent, clean, lamarckian, [], [], [], [])
end

# Produces an (unprepared) clone of a given representation graph node.
copy(n::RepresentationGraphNode) =
  RepresentationGraphNode(n.label, n.parent, n.clean, n.lamarckian)

# Checks whether a given node within a representation graph is the root node.
isroot(n::RepresentationGraphNode) = n.parent == ""
