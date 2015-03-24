load("../representation",  dirname(@__FILE__))

type SpeciesStage
  # The label, or name, of this stage.
  label::String

  # The label of the parent for this stage.
  parent::String

  # The representation used by this stage.
  representation::Representation

  # A flag indicating whether changes to this stage are lamarckian, i.e.
  # they are reflected to the parent stage.
  lamarckian::Bool

  # Constructs a new species stage.
  SpeciesStage(label::String, parent::String, representation::Representation, lamarckian::Bool) =
    new(label, parent, representation, lamarckian)
end

# Returns the representation used by a given species stage.
representation(s::SpeciesStage) = s.representation

# Returns the chromosome used by this species stage.
chromosome(s::SpeciesStage) = chromosome(s.representation)

# Determines whether a given species stage is the root stage.
root(s::SpeciesStage) = s.parent == ""

# Returns the root stage from a collection of species stages.
root(ss::Dict{String, SpeciesStage}) = root(collect(values(ss)))
root(ss::Vector{SpeciesStage}) = for s in ss
  if root(s)
    return s
  end
end

register("species#stage", SpeciesStage)
composer("species#stage") do s

  # By default, all stages are treated as root stages (although there can only be one) and
  # as non-lamarckian.
  s["from"] = Base.get(s, "from", "")
  s["lamarckian"] = Base.get(s, "lamarckian", false)

  # Build the representation for this stage.
  s["representation"] = compose(s["representation"]["type"], s["representation"])

  return SpeciesStage(s["label"], s["from"], s["representation"], s["lamarckian"])
  
end
