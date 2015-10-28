"""
Implements the Koza FULL initialisation method.
"""
type KozaFullBuilder{T <: KozaTree} <: KozaBuilder
  """
  The minimum depth of trees created according to this method.
  """
  min_depth::Int

  """
  The maximum depth of trees created according to this method.
  """
  max_depth::Int

  KozaFullBuilder() = new(1, 8)
  KozaFullBuilder(min::Int, max::Int) = new(min, max)
end

"""
Implements the Koza FULL initialisation method, where some `d` is selected
between a specified minimum and maximum depth, and used to generate a full tree
with a depth equal to `d`.

**Properties:**

* `min::Int`, the minimum tree depth.
* `max::Int`, the maximum tree depth.
"""
full() = KozaFullBuilder()
full(min::Int, max::Int) = KozaFullBuilder(min, max)
function full(f::Function)
  def = KozaFullBuilder()
  f(def)
  def
end

"""
Constructs a Koza Tree belonging to a given representation using the FULL
method, according to a set of provided specifics.
"""
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
