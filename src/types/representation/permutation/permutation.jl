load("../../representation", dirname(@__FILE__))

immutable PermutationRepresentation{T} <: Representation
  alphabet::T
  size::Integer

  KozaTreeRepresentation(tree::Type,
    min_d::Int,
    max_d::Int,
    t::Vector{KozaTerminal},
    nt::Vector{KozaNonTerminal},
    i::Vector{KozaInput},
    b::KozaBuilder) =
    new(tree, min_d, max_d, t, nt, i, b)
end

Base.rand(r::KozaTreeRepresentation) = build(r.builder, r)
chromosome(r::KozaTreeRepresentation) = r.tree

sample_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.terminals[rand(1:end)], p)

sample_non_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.non_terminals[rand(1:end)], p)

register(joinpath(dirname(@__FILE__), "manifest.yml"))
