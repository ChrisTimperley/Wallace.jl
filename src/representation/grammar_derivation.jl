# Load the grammar type.
include("grammar_derivation/grammar.jl")

"""
Provides a definition for a grammar derivation representation.
"""
type GrammarDerivationRepresentationDefinition <: RepresentationDefinition
  """
  The maximum number of times that the genome is allowed to wrap around itself
  if it has run out of codons to use. By default, wrapping is disabled.
  """
  max_wraps::Int

  """
  The grammar that should be used to produce the derivations.
  """
  grammar::Grammar

  GrammarDerivationRepresentationDefinition() = new(0)
end

type GrammarDerivationRepresentation <: Representation
  max_wraps::Int
  grammar::Grammar

  GrammarDerivationRepresentation(max_wraps::Int, grammar::Grammar) =
    new(max_wraps, grammar)
end

chromosome(::GrammarDerivationRepresentation) = AbstractString

"""
TODO: Document grammar derivation representations.
"""
function grammar(def::Function)
  g = GrammarDerivationRepresentationDefinition()
  def(g)
  g
end

"""
Composes a grammar derivation representation from a provided definition.
"""
function compose!(def::GrammarDerivationRepresentationDefinition)
  GrammarDerivationRepresentation(def.max_wraps, def.grammar)
end

"""
Converts from a vector of codons to a grammar derivation.
"""
convert!(
  r_from::IntVectorRepresentation,
  r_to::GrammarDerivationRepresentation,
  c_from::IndividualStage{Vector{Int}},
  c_to::IndividualStage{AbstractString}
) =
  c_to = derive(r_to, c_from.value)

"""
Produces a grammar derivation from a given sequence of codons, according to
a provided grammar derivation representation.
"""
derive(r::GrammarDerivationRepresentation, s::Vector{Int}) =
  derive(r.grammar, s, r.max_wraps)
