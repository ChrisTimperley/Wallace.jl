load("../representation",  dirname(@__FILE__))

type SpeciesStage
  # The label, or name, of this stage.
  label::AbstractString

  # The label of the parent for this stage.
  parent::AbstractString

  # The representation used by this stage.
  representation::Representation

  # A flag indicating whether changes to this stage are lamarckian, i.e.
  # they are reflected to the parent stage.
  lamarckian::Bool

  # Constructs a new species stage.
  SpeciesStage(label::AbstractString, parent::AbstractString, representation::Representation, lamarckian::Bool) =
    new(label, parent, representation, lamarckian)
end

# Returns the representation used by a given species stage.
representation(s::SpeciesStage) = s.representation

# Returns the chromosome used by this species stage.
chromosome(s::SpeciesStage) = chromosome(s.representation)

# Determines whether a given species stage is the root stage.
root(s::SpeciesStage) = s.parent == ""

# Returns the root stage from a collection of species stages.
root(ss::Dict{AbstractString, SpeciesStage}) = root(collect(values(ss)))
root(ss::Vector{SpeciesStage}) = for s in ss
  if root(s)
    return s
  end
end

register(joinpath(dirname(@__FILE__), "stage.manifest.yml"))
