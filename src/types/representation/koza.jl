load("../representation",           dirname(@__FILE__))
load("koza/tree", dirname(@__FILE__))
load("koza/terminal", dirname(@__FILE__))
load("koza/non_terminal", dirname(@__FILE__))
load("koza/input", dirname(@__FILE__))
load("koza/builder", dirname(@__FILE__))
load("koza/parent", dirname(@__FILE__))

abstract KozaCarrier

type KozaTreeRepresentation <: Representation
  tree::Type
  min_depth::Int
  max_depth::Int
  terminals::Vector{KozaTerminal}
  non_terminals::Vector{KozaNonTerminal}
  inputs::Vector{KozaInput}
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

Base.rand(r::KozaTreeRepresentation) = build(r.builder, r)
chromosome(r::KozaTreeRepresentation) = r.tree

sample_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.terminals[rand(1:end)], p)

sample_non_terminal(r::KozaTreeRepresentation, p::KozaParent) =
  fresh(r.non_terminals[rand(1:end)], p)
