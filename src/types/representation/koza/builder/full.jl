load("../builder", dirname(@__FILE__))
load("../parent",  dirname(@__FILE__))
load("../../koza", dirname(@__FILE__))

type KozaFullBuilder{T <: KozaTree} <: KozaBuilder
  min_depth::Int
  max_depth::Int

  KozaFullBuilder(mind::Int, maxd::Int) =
    new(mind, maxd)
end

function build{T}(b::KozaFullBuilder{T}, r::KozaTreeRepresentation)
  t = T()
  t.root = build(KozaFullBuilder, r, t, 1, rand(b.min_depth:b.max_depth))
  return t
end

build(::Type{KozaFullBuilder},
  r::KozaTreeRepresentation,
  p::KozaParent,
  d::Integer,
  md::Integer
) =
  if d == md
    return sample_terminal(r, p)
  else
    n = sample_non_terminal(r, p)
    for i in 1:arity(n)
      n.children[i] = build(KozaFullBuilder, r, n, d+1, md)
    end
    return n
  end
