# encoding: utf-8
load("individual",      dirname(@__FILE__))
load("deme",            dirname(@__FILE__))
load("../base/flatten", dirname(@__FILE__))

type Population
  demes::Vector{Deme}

  Population() = new([])
  Population(dl::Vector{Deme}) = new(dl)
end

# Prepares this population for the main loop of the EA.
prepare!(p::Population) = for deme in p.demes; prepare!(deme); end

# Produces the offspring for a given population at each generation.
breed!(p::Population) = for deme in p.demes; breed!(deme); end

# Finds the best individual within a population.
best(p::Population) = best(map(best, p.demes))
best(d::Deme) = best(d.members)
best{I <: Individual}(inds::Vector{I}) = maximum(inds)

# Returns a list of the unevaluated individuals within a population.
unevaluated(p::Population) = flatten(map(unevaluated, p.demes))
unevaluated(d::Deme) = vcat(unevaluated(d.members), unevaluated(d.offspring))
unevaluated{I <: Individual}(inds::Vector{I}) = filter(i -> !i.evaluated, inds)

register("population", Population)
composer("population") do s
  s["demes"] = Deme[compose_as(d, "deme") for d in s["demes"]]
  Population(s["demes"])
end
