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

"""
TODO: Composes a species stage.

By default, all stages are treated as root stages (although there can only
be one) and as non-lamarckian.

"""
function stage(s::Dict{Any, Any})
  s["from"] = Base.get(s, "from", "")
  s["lamarckian"] = Base.get(s, "lamarckian", false)
  stage(s["label"], s["representation"], s["from"], s["lamarckian"])
end
stage(label::String, rep::Representation) =
  stage(label, rep, "", false)
stage(label::String, rep::Representation, from::String) =
  stage(label, rep, from, false)
stage(label::String, rep::Representation, from::String, lamarckian::Bool) =
  stage(label, rep, from, lamarckian)

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
