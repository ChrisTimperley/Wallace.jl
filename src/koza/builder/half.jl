"""
Implements the Koza HALF-TO-HALF initialisation method.
"""
type KozaHalfBuilder{T <: KozaTree} <: KozaBuilder
  min_depth::Int
  max_depth::Int
  prob_terminals::Float
  prob_grow::Float
end

"""
Provides a definition of a HALF-TO-HALF method for constructing Koza trees.
"""
type KozaHalfBuilderDefinition <: KozaBuilderDefinition
  """
  The minimum depth of trees created according to this method.
  """
  min_depth::Int

  """
  The maximum depth of trees created according to this method.
  """
  max_depth::Int

  """
  The probability of a terminal being selected when generating the root of
  a sub-tree.
  """
  prob_terminals::Float

  """
  The probability of a sub-tree being generated according to the GROW method,
  rather than the FULL method.
  """
  prob_grow::Float

  KozaHalfBuilderDefinition() = new(1, 9, 0.5, 0.5)
  KozaHalfBuilderDefinition(min::Int, max::Int) = new(min, max, 0.5, 0.5)
  KozaHalfBuilderDefinition(min::Int, max::Int, pt::Float, pg::Float) =
    new(min, max, pt, pg)
end

"""
Composes a Koza HALF-AND-HALF builder, for a given sub-type of Koza Tree, using
a provided definition.
"""
compose!(d::KozaHalfBuilderDefinition, t::Type) =
  KozaHalfBuilder{t}(d.min_depth, d.max_depth, d.prob_terminals, d.prob_grow)

"""
TODO

**Properties:**

* `min::Int`, the minimum tree depth.
* `max::Int`, the maximum tree depth.
* `prob_terminal::Float`, the probability of a terminal - TODO!
"""
half() = KozaHalfBuilderDefinition()
half(min::Int, max::Int, pt::Float, pg::Float) =
  KozaHalfBuilderDefinition(min, max, pt, pg)
function half(f::Function)
  def = KozaHalfBuilderDefinition()
  f(def)
  def
end

"""
Constructs a Koza Tree belonging to a given representation using the
HALF-AND-HALF method, according to a set of provided specifics.
"""
function build{T}(b::KozaHalfBuilder{T}, r::KozaTreeRepresentation)
  t = T()
  if rand() <= b.prob_grow
    t.root = build(KozaGrowBuilder, r, t, 1, rand(b.min_depth:b.max_depth), b.prob_terminals)
  else
    t.root = build(KozaFullBuilder, r, t, 1, rand(b.min_depth:b.max_depth))
  end
  return t
end
