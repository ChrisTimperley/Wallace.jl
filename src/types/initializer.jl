load("population.jl",   dirname(@__FILE__))
load("deme.jl",         dirname(@__FILE__))

abstract Initializer

# Initialises all members within a given population.
initialize!(i::Initializer, p::Population) = for d in p.demes
  initialize!(i, d)
end

# Initialises all members within a given deme.
initialize!{I <: Individual}(i::Initializer, d::Deme{I}) = for ind in d.members
  initialize!(i, ind)
end

register(joinpath(dirname(@__FILE__), "initializer.manifest.yml"))
