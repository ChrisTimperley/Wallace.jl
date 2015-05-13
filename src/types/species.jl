load("individual",      dirname(@__FILE__))
load("representation",  dirname(@__FILE__))
load("species/stage",   dirname(@__FILE__))

type Species{T}
  genotype::SpeciesStage
  stages::Dict{String, SpeciesStage}

  Species(stages::Dict{String, SpeciesStage}) =
    new(root(stages), stages)
end

# Returns the representation used by a given stage of a provided species.
representation(species::Species, stage::String) = species.stages[stage].representation

# Returns the unique individual type associated this species.
ind_type{T}(s::Species{T}) = T

# Converts from one representation to another for a given pair of chromosomes
# for all individuals in a given list.
function convert!{I <: Individual}(
  s::Species,
  from::String,
  to::String,
  inds::Vector{I}
)
  convert!(representation(s, from), representation(s, to), from, to, inds)
end

composer("species") do s
  
  # Compose each of the stages for this species.
  for (name, stage) in s["stages"]
    stage["label"] = name
    s["stages"][name] = compose_as(stage, "species#stage")
  end

  # Compose the individual type.
  I = compose_as(Dict{Any, Any}([
    "fitness" => s["fitness"],
    "stages" => s["stages"]
  ]), "individual")

  # Instantiate this species.
  Species{I}(Dict{String, SpeciesStage}(s["stages"]))
end
