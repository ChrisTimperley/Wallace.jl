module species
using utility, core
importall representation, fitness, common
export Species, convert!, genotype, SpeciesDefinition, empty_individual_collection

"""
The base type used by all species definitions.
"""
abstract SpeciesDefinition

# Load species stages.
include("species/stage.jl")

"""
Used to hold information about a given species.
"""
type Species
  stages::Dict{AbstractString, SpeciesStage}
  fitness::FitnessScheme
  genotype::SpeciesStage

  Species(st::Dict{AbstractString, SpeciesStage}, f::FitnessScheme) =
    new(st, f, root(st))
end

"""
Constructs an empty individual collection for this species.
"""
function empty_individual_collection(s::Species)
  F = uses(s.fitness)
  d = Dict{AbstractString, Any}()
  for (label, st) in s.stages
    d[label] = chromosome(st.representation)[]
  end
  return IndividualCollection{F}(F[], d)
end

"""
Returns the canonical genotype of a given species.
"""
genotype(s::Species) = s.genotype

"""
Returns the representation used by a given stage of a provided species.
"""
rep(species::Species, stage::AbstractString) =
  species.stages[stage].representation

"""

"""
__wallace__ = Base
startUp(m::Module) =
  __wallace__ = m

# Include all other components of the species module.
include("species/graph.jl")
include("species/simple.jl")
include("species/complex.jl")
end
