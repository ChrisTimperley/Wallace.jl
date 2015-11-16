type SpeciesStage
  """
  A flag indicating whether changes to this stage are lamarckian, i.e. they are
  reflected to the parent stage.
  """
  lamarckian::Bool

  """
  The label of the parent for this stage.
  """
  parent::AbstractString

  """
  The label, or name, of this stage.
  """
  label::AbstractString

  """
  The representation used by this stage.
  """
  representation::Representation

  SpeciesStage(
    label::AbstractString,
    representation::Representation,
    parent::AbstractString,
    lamarckian::Bool
  ) =
    new(lamarckian, parent, label, representation)
end

type SpeciesStageDefinition
  lamarckian::Bool
  parent::AbstractString
  label::AbstractString
  representation::RepresentationDefinition

  SpeciesStageDefinition() = new(false, "")
  SpeciesStageDefinition(
    label::AbstractString,
    representation::RepresentationDefinition,
    parent::AbstractString,
    lamarckian::Bool
  ) =
    new(lamarckian, parent, label, representation)
end

"""
Composes a species stage from its definition.
"""
compose!(def::SpeciesStageDefinition) =
  SpeciesStage(def.label, compose!(def.representation), def.parent, def.lamarckian)

"""
TODO: Describe species stages.

By default, all stages are treated as root stages (although there can only
be one) and as non-lamarckian.
"""
function stage(label::AbstractString, def::Function)
  ss = stage(def)
  ss.label = label
  ss
end
function stage(def::Function)
  ss = SpeciesStageDefinition()
  def(ss)
  ss
end
stage(label::AbstractString, rep::RepresentationDefinition) =
  stage(label, rep, "", false)
stage(label::AbstractString, rep::RepresentationDefinition, from::AbstractString) =
  stage(label, rep, from, false)
stage(label::AbstractString, rep::RepresentationDefinition, from::AbstractString, lamarckian::Bool) =
  SpeciesStageDefinition(label, rep, from, lamarckian)

# Returns the representation used by a given species stage.
rep(s::SpeciesStage) = s.representation

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
