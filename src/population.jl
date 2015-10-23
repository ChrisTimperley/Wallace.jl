"""
TODO: Description of the current population model.
"""
module population
importall common
using   core, _deme_, individual, utility, species, breeder
export  Population, best!, unevaluated, PopulationDefinition

"""
The base type used by all population definitions.
"""
abstract PopulationDefinition

"""
Used to hold the contents of a population, where a population is modelled
as a collection of demes (which may, or may not, be of different species).
"""
type Population
  demes::Vector{Deme}

  Population() = new([])
  Population(dl::Vector{Deme}) = new(dl)
end

"""
Prepares a given population for the main loop of the EA.
"""
prepare!(p::Population) = for deme in p.demes; prepare!(deme); end

"""
Produces the offspring for a given population at each generation.
"""
breed!(p::Population) = for deme in p.demes; breed!(deme); end

"""
Finds the best individual within a given population.
"""
best(p::Population) = best(map(best, p.demes))

"""
Finds the best individual within a given deme.
"""
best(d::Deme) = best(d.members)

"""
Finds the best individual from a list of individuals.
"""
best{I <: Individual}(inds::Vector{I}) = maximum(inds)

"""
Returns a list of the unevaluated individuals within a population.
"""
unevaluated(p::Population) = flatten(map(unevaluated, p.demes))

"""
Returns a list of the unevaluated individuals within a deme.
"""
unevaluated(d::Deme) = vcat(unevaluated(d.members), unevaluated(d.offspring))

"""
Returns a list of the unevaluated individuals from a list of individuals.
"""
unevaluated{I <: Individual}(inds::Vector{I}) = filter(i -> !i.evaluated, inds)

"""
Performs any necessary fitness scaling and processing on each of the
individuals within a given population.
"""
scale!(p::Population) = for deme in p.demes; scale!(deme); end
scale!(d::Deme) = scale!(d.species.fitness, contents(d))

# Load each of the population types.
include("population/simple.jl")
include("population/complex.jl")
end
