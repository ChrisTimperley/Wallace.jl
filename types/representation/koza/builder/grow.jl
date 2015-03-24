load("../builder", dirname(@__FILE__))
load("../../koza", dirname(@__FILE__))
load("../parent",  dirname(@__FILE__))

type KozaGrowBuilder{T <: KozaTree} <: KozaBuilder
  min_depth::Int
  max_depth::Int
  prob_terminal::Float

  KozaGrowBuilder(mind::Int, maxd::Int, p::Float) =
    new(mind, maxd, p)
end

function build{T}(b::KozaGrowBuilder{T}, r::KozaTreeRepresentation)
  t = T()
  t.root = build(KozaGrowBuilder, r, t, 1, rand(b.min_depth:b.max_depth), b.prob_terminal)
  return t
end

build(::Type{KozaGrowBuilder},
  r::KozaTreeRepresentation,
  p::KozaParent,
  d::Integer,
  md::Integer,
  pb::Float
) =
  if rand() <= pb || d == md
    return sample_terminal(r, p)
  else
    n = sample_non_terminal(r, p)
    for i in 1:arity(n)
      n.children[i] = build(KozaGrowBuilder, r, n, d+1, md, pb)
    end
    return n
  end
