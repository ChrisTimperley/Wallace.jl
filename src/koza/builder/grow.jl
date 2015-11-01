"""
Provides a definition of a GROW method for constructing Koza trees.
"""
type KozaGrowBuilderDefinition <: KozaBuilderDefinition
  min_depth::Int
  max_depth::Int
  prob_terminal::Float

  KozaGrowBuilderDefinition() = new(1, 8, 0.5)
  KozaGrowBuilderDefinition(min::Int, max::Int) = new(min, max 0.5)
  KozaGrowBuilderDefinition(min::Int, max::Int, p_terminal) =
    new(min, max, p_terminal)
end

"""
Implements the GROW method for constructing Koza trees.
"""
type KozaGrowBuilder{T <: KozaTree} <: KozaBuilder
  min_depth::Int
  max_depth::Int
  prob_terminal::Float

  KozaGrowBuilder(min::Int, max::Int, p::Float) = new(min, max, p)
end

"""
Composes a Koza Grow builder, for a given sub-type of Koza Tree, using a
provided definition.
"""
compose!(d::KozaGrowBuilderDefinition, t::KozaTree) =
  KozaGrowBuilder{t}(d.min_depth, d.max_depth, d.prob_terminal)

"""

**Properties:**

* `min::Int`, the minimum tree depth.
* `max::Int`, the maximum tree depth.
* `p::Float`, pt.
"""
grow() = KozaGrowBuilderDefinition()
grow(min::Int, max::Int) = KozaGrowBuilderDefinition(min, max)
grow(min::Int, max::Int, p::Float) = KozaGrowBuilderDefinition(min, max, p)
function grow(f::Function)
  def = KozaGrowBuilderDefinition()
  f(def)
  def
end

"""
Constructs a Koza Tree belonging to a given representation using the GROW
method, according to a set of provided specifics.
"""
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
