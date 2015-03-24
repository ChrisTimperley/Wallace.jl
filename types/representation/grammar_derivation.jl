load("../representation",           dirname(@__FILE__))
load("int_vector",                  dirname(@__FILE__))
load("grammar_derivation/grammar",  dirname(@__FILE__))

type GrammarDerivationRepresentation <: Representation
  max_wraps::Int
  grammar::Grammar

  GrammarDerivationRepresentation(max_wraps::Int, grammar::Grammar) =
    new(max_wraps, grammar)
end

chromosome(::GrammarDerivationRepresentation) = String

# Converts from a vector of codons to a grammar derivation.
convert!(r_from::IntVectorRepresentation,
  r_to::GrammarDerivationRepresentation,
  c_from::IndividualStage{Vector{Int}},
  c_to::IndividualStage{String}) =
  c_to = derive(r_to, c_from.value)

derive(r::GrammarDerivationRepresentation, s::Vector{Int}) =
  derive(r.grammar, s, r.max_wraps)

register("representation/grammar_derivation", GrammarDerivationRepresentation)
composer("representation/grammar_derivation") do s
  s["max_wraps"] = Base.get(s, "max_wraps", 0)
  s["grammar"] = compose("grammar", s["grammar"])
  GrammarDerivationRepresentation(s["max_wraps"], s["grammar"])
end
