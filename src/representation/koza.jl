module koza

# Load the sub-components.
# May want to define this as its own module?
include("koza/node")
include("koza/input")
include("koza/tree")
include("koza/terminal")
include("koza/non_terminal")
include("koza/input")
include("koza/builder")

"""
The base type of all types which may serve as the parent of a Koza tree node.
For the root of the tree, this parent is the tree itself, and for all other
nodes, this type will be a node.
"""
abstract KozaParent
abstract KozaCarrier

type KozaTreeRepresentation <: Representation
  """
  The automatically generated, problem-specific KozaTree sub-type used by this
  representation.
  """
  tree::Type

  """
  The minimum depth of trees using this representation.
  """
  min_depth::Int

  """
  The maximum depth of trees using this representation.
  """
  max_depth::Int

  """
  The set of terminals used by trees belonging to this representation.
  """
  terminals::Vector{KozaTerminal}

  """
  The set of non-terminals used by trees belonging to this representation.
  """
  non_terminals::Vector{KozaNonTerminal}

  """
  An ordered list of the inputs to each of the programs created from Koza trees
  belonging to this representation.
  """
  inputs::Vector{KozaInput}

  """
  The building method used to generate new trees belonging to this
  representation.
  """
  builder::KozaBuilder
  # ERCs

  KozaTreeRepresentation(tree::Type,
    min_d::Int,
    max_d::Int,
    t::Vector{KozaTerminal},
    nt::Vector{KozaNonTerminal},
    i::Vector{KozaInput},
    b::KozaBuilder) =
    new(tree, min_d, max_d, t, nt, i, b)
end

"""
Generates a koza tree at random, according to the breeding method used by the
supplied representation.
"""
Base.rand(r::KozaTreeRepresentation) = build(r.builder, r)

"""
Returns the customised data structure used by a given Koza Tree representation.
"""
chromosome(r::KozaTreeRepresentation) = r.tree

"""
Randomly selects a terminal from the terminal set for insertion underneath a
provided parent.
"""
sample_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.terminals[rand(1:end)], p) # ???

sample_non_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.non_terminals[rand(1:end)], p)
end
