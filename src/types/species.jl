load("individual",      dirname(@__FILE__))
load("representation",  dirname(@__FILE__))
load("species/stage",   dirname(@__FILE__))

type Species{T}
  genotype::SpeciesStage
  stages::Dict{AbstractString, SpeciesStage}
  fitness::FitnessScheme

  Species(st::Dict{AbstractString, SpeciesStage}, f::FitnessScheme) =
    new(root(st), st, f)
end

# Returns the canonical genotype of a given species.
genotype(s::Species) = s.genotype

# Returns the representation used by a given stage of a provided species.
representation(species::Species, stage::AbstractString) = species.stages[stage].representation

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
  convert!(representation(s, from), representation(s, to), from, to, inds)
end

register(joinpath(dirname(@__FILE__), "species.manifest.yml"))
register(joinpath(dirname(@__FILE__), "species/simple.manifest.yml"))
