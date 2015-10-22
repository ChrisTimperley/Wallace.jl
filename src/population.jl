"""
TODO: Description of the current population model.
"""
module population
using core, _deme_, individual, utility
export Population, best!, prepare!, breed!, unevaluated, scale!

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
Composes a given population.
"""
function compose!(p::Population)
  p.demes = Deme[compose!(d) for d in p.demes]
  p
end

"""
Simple populations consist of a single fixed-size deme containing individuals of
the same species.

**Properties:**

* `size::Int`, the number of individuals within the population.
* `offspring::Int`, the number of offspring that should be produced at each
  generation.
* `species::Species`, the species to which all individuals within this
  population belong.
* `breeder::Breeder`, the breeder used to generate the offspring for this
  population at each generation.
"""
function simple(s::Dict{Any, Any})
  complex(Dict{Any, Any}(
    "demes" => [
      Dict{Any, Any}(
        "capacity"  => s["size"],
        "offspring" => Base.get(s, "offspring", s["size"]),
        "species"   => s["species"],
        "breeder"   => s["breeder"]
      )
    ]
  ))
end

"""
Complex populations may consist of multiple demes, where all members of a given
deme belong to the same species, but each deme may use a different species.

**Properties:**

*`demes::Vector{Specification}`, an ordered list containing specifications
  for each of the demes within this population.
"""
function complex(s::Dict{Any, Any})
  s["demes"] = Deme[deme(d) for d in s["demes"]]
  Population(s["demes"])
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
end
