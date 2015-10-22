module replacement
  using state, _deme_
  export  Replacement

  """
  The base type used by all replacement schemes.
  """
  abstract Replacement

  """
  Performs replacement on each deme within the population for a given algorithm
  state, according to a provided replacement scheme.
  """
  replace!(::Replacement, ::State) =
    error("No replace! operator implemented by this replacement scheme.")

  """
  Replaces the existing members of a deme with their offspring at the end of
  each generation.
  """
  type GenerationalReplacement <: Replacement; end

  """
  Generational replacement simply replaces the existing population with their
  offspring at the each of each generation. This is the default replacement
  scheme used by simple genetic algorithms. Also known as comma replacement,
  when used in conjuction with evolution strategies.
  """
  generational() = GenerationalReplacement()
  comma = generational

  replace!(r::GenerationalReplacement, s::State) =
    for d in s.population.demes; replace!(r, d); end

  replace!(r::GenerationalReplacement, d::Deme) =
    d.members[1:end] = d.offspring[1:d.capacity]
end
