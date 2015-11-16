module koza
using utility, individual, species
importall core, common, representation, crossover, mutation, variation

"""
The base type of all types which may serve as the parent of a Koza tree node.
For the root of the tree, this parent is the tree itself, and for all other
nodes, this type will be a node.
"""
abstract KozaParent
abstract KozaCarrier

"""
The base type used by all koza trees. A new, concrete type is dynamically
created for each problem, tailored to its specifics, giving it a higher level
of performance. This has the effect of essentially creating a highly optimised
interpreter for each problem.
"""
abstract KozaTree <: KozaParent

# Load the sub-components.
include("koza/node.jl")
include("koza/input.jl")
include("koza/tree.jl")
include("koza/terminal.jl")
include("koza/non_terminal.jl")
include("koza/input.jl")
include("koza/builder.jl")

"""
Used to provide a definition for a Koza tree representation.
"""
type KozaTreeRepresentationDefinition <: RepresentationDefinition
  min_depth::Int
  max_depth::Int
  builder::KozaBuilderDefinition
  terminals::Vector{AbstractString}
  non_terminals::Vector{AbstractString}
  inputs::Vector{AbstractString}

  KozaTreeRepresentationDefinition() =
    new(1, 9, KozaHalfBuilderDefinition(), [], [], [])
end

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

  KozaTreeRepresentation(
    tree::Type,
    min_d::Int,
    max_d::Int,
    t::Vector{KozaTerminal},
    nt::Vector{KozaNonTerminal},
    i::Vector{KozaInput},
    b::KozaBuilder) =
    new(tree, min_d, max_d, t, nt, i, b)
end

"""
TODO: Description of Koza tree representation.
"""
function tree(f::Function)
  def = KozaTreeRepresentationDefinition()
  f(def)
  def
end

"""
Composes a Koza tree representation from a provided definition.
"""
function compose!(def::KozaTreeRepresentationDefinition)
  inputs = KozaInput[KozaInput(i) for i in def.inputs]
  tree = compose_tree_type(inputs)
  builder = compose!(def.builder, tree)
  terminals = KozaTerminal[compose_terminal(inputs, t)() for t in def.terminals]
  non_terminals = KozaNonTerminal[compose_non_terminal(inputs, nt)() for nt in def.non_terminals]
  KozaTreeRepresentation(tree, def.min_depth, def.max_depth, terminals, non_terminals,
    inputs, builder)
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

# Load the operators.
include("koza/subtree_crossover.jl")
include("koza/subtree_mutation.jl")

# Load each of the building methods.
include("koza/builder/full.jl")
include("koza/builder/grow.jl")
include("koza/builder/half.jl")
end
