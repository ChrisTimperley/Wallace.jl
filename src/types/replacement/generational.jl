load("../replacement",  dirname(@__FILE__))
load("../state",        dirname(@__FILE__))

type GenerationalReplacement <: Replacement; end

replace!(r::GenerationalReplacement, s::State) =
  for d in s.population.demes; replace!(r, d); end

replace!(r::GenerationalReplacement, d::Deme) =
  d.members[1:end] = d.offspring[1:d.capacity]

register(joinpath(dirname(@__FILE__), "generational.manifest.yml"))
