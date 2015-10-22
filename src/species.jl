module species
using representation, fitness, core, utility
export Species, convert!, compose!, genotype, rep, ind_type, SpeciesDefinition

"""
The base type used by all species definitions.
"""
abstract SpeciesDefinition

# Load species stages.
include("species/stage.jl")

"""
Used to hold information about a given species.
"""
type Species{T}
  stages::Dict{AbstractString, SpeciesStage}
  fitness::FitnessScheme
  genotype::SpeciesStage

  Species(st::Dict{AbstractString, SpeciesStage}, f::FitnessScheme) =
    new(st, f, root(st))
end

# Returns the canonical genotype of a given species.
genotype(s::Species) = s.genotype

# Returns the representation used by a given stage of a provided species.
rep(species::Species, stage::AbstractString) =
  species.stages[stage].representation

# Returns the unique individual type associated this species.
ind_type{T}(s::Species{T}) = T

# Converts from one representation to another for a given pair of chromosomes
# for all individuals in a given list.
function convert!{I <: Individual}(
  s::Species,
  from::AbstractString,
  to::AbstractString,
  inds::Vector{I}
)
  convert!(rep(s, from), rep(s, to), from, to, inds)
end

# Include all other components of the species module.
include("species/individual_type.jl")
include("species/graph.jl")
include("species/simple.jl")
include("species/complex.jl")
end
