"""
TODO: Description of the current population model.
"""
module population
importall common
using   core, _deme_, utility, species, breeder
export  Population, PopulationDefinition

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
Produces the offspring for a given population at each generation.
"""
breed!(p::Population) = for deme in p.demes; breed!(deme); end

"""
Performs any necessary fitness scaling and processing on each of the
individuals within a given population.
"""
scale!(p::Population) = for deme in p.demes; scale!(deme); end
#scale!(d::Deme) = scale!(d.species.fitness, contents(d))

"""
TODO: IMPLEMENT SCALING.
"""
scale!(d::Deme) = true

# Load each of the population types.
include("population/simple.jl")
include("population/complex.jl")
end
