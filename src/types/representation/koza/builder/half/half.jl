load("../../builder", dirname(@__FILE__))
load("../../parent",  dirname(@__FILE__))
load("../../../koza", dirname(@__FILE__))
load("../full/full",  dirname(@__FILE__))
load("../grow/grow",  dirname(@__FILE__))

type KozaHalfBuilder{T <: KozaTree} <: KozaBuilder
  min_depth::Int
  max_depth::Int
  prob_terminals::Float
  prob_grow::Float
end

function build{T}(b::KozaHalfBuilder{T}, r::KozaTreeRepresentation)
  t = T()
  if rand() <= b.prob_grow
    t.root = build(KozaGrowBuilder, r, t, 1, rand(b.min_depth:b.max_depth), b.prob_terminals)
  else
    t.root = build(KozaFullBuilder, r, t, 1, rand(b.min_depth:b.max_depth))
  end
  return t
end

register(joinpath(dirname(@__FILE__), "manifest.yml"))
