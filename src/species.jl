module
using individual, representation, fitness

type Species{T}
  stages::Dict{AbstractString, SpeciesStage}
  fitness::FitnessScheme
  genotype::SpeciesStage

  Species(st::Dict{AbstractString, SpeciesStage}, f::FitnessScheme) =
    new(st, f)
end

"""
Composes a given species.
"""
function compose!(s::Species)
  s.genotype = root(s.stages)
  s
end

"""
A simple species uses only a single representation, and defaults to using
scalar fitness if no fitness scheme is specified. For most problems, simple
species will suffice.

The genome of an individual belonging to a simple species may be retrieved
through its `genome` property.

**Properties:**

* `representation::Representation`, the solution represented used by members
of this species.
* `fitness::FitnessScheme`, the fitness scheme used by members of this
species. Defaults to (maximised) scalar fitness if unspecified.
"""
function simple(def::Function)
  def
end

simple(s::Dict{Any, Any}) =
  complex(Dict{Any, Any}(
    "fitness" => Base.get(s, "fitness", fitness.scalar()),
    "stages"  => Dict{Any, Any}(
      "genome" => Dict{Any, Any}(
        "representation" => s["representation"]
      )
    )
  ), "species")

"""
Unlike a simple species, a complex species may be composed of numerous
developmental stages, or different views on a particular stage.

For example, in the case of grammatical evolution, one may wish to represent
use different stages to represent the individual as a bit vector, codon
vector, program string, and compiled program.
"""
function complex(s::Dict{Any, Any})
  println("- composing species.")

  # Compose each of the stages for this species.
  println("-- composing species stages.")
  for (name, stage::Dict{Any, Any}) in s["stages"]
    stage["label"] = name
    s["stages"][name] = compose_as(stage, "species#stage")
  end

  # Compose the fitness scheme for this species.
  # Default to maximization of a float scalar.
  println("-- composing fitness.")
  s["fitness"] = Base.get(s, "fitness", Dict{Any, Any}(
    "type" => "fitness/scalar",
    "maximise" => true,
    "of" => "Float"
  ))
  s["fitness"] = compose_as(s["fitness"], s["fitness"]["type"])

  # Compose the individual type.
  println("-- composing individual type.")
  I = compose_as(Dict{Any, Any}(
    "fitness" => s["fitness"],
    "stages" => s["stages"]
  ), "individual")

  # Instantiate this species.
  Species{I}(Dict{String, SpeciesStage}(s["stages"]), s["fitness"])
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

# Include all other components of the species module.
include("species/stage.jl")
include("species/graph.jl")
end
