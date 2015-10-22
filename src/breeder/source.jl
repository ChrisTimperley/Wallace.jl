"""
The base type used by all breeder sources.
"""
abstract BreederSource

"""
The base type used by all breeder source definitions.
"""
abstract BreederSourceDefinition

"""
Provides a definition of a selection breeder source.
"""
type SelectionBreederSourceDefinition <: BreederSourceDefinition
  label::AbstractString
  operator::SelectionDefinition
  
  SelectionBreederSourceDefinition(label::AbstractString, op::SelectionDefinition) =
    new(label, op)
end

type SelectionBreederSource <: BreederSource
  label::AbstractString
  operator::Selection
  eigen::Type

  SelectionBreederSource(label::AbstractString, s::Selection) =
    new(label, s)
end

"""
Composes a given selection breeder source.
"""
function compose!(def::SelectionBreederSourceDefinition)
  s = BreederSource(selection.compose!(def.label, def.operator))
  s.eigen = anonymous_type(selection)
  s
end

"""
A selection source.
"""
selection(label::AbstractString, op::SelectionDefinition) =
  SelectionBreederSourceDefinition(label, op) 

"""
Provides a definition of a variation breeder source.
"""
type VariationBreederSourceDefinition <: BreederSourceDefinition
  label::AbstractString
  stage::AbstractString
  source::AbstractString
  operator::VariationDefinition

  VariationBreederSourceDefinition(
    label::AbstractString,
    source::AbstractString,
    stage::AbstractString,
    operator::VariationDefinition
  ) =
    new(label, stage, source, operator)
end

type VariationBreederSource <: BreederSource
  label::AbstractString
  operator::Variation
  source_name::AbstractString
  stage_name::AbstractString
  eigen::Type
  source::BreederSource
  stage_getter::Function

  VariationBreederSource(
    label::AbstractString,
    v::Variation,
    source_name::AbstractString,
    stage_name::AbstractString
  ) =
    new(label, v, source_name, stage_name)
end

"""
Composes a variation breeder source.

**Parameters:**

* `v::VariationBreederSource`, the breeder source being composed.
* `sources::Dict{AbstractString, Source}`, a dictionary containing the sources
of the breeder that this source belongs to.
"""
function compose!(def::VariationBreederSourceDefinition, sources::Dict{AbstractString, BreederSource})
  v = VariationBreederSource(compose!(def.label, def.operator, def.source, def.stage))
  v.eigen = anonymous_type(Wallace)
  v.source = sources[def.source]
  v.stage_getter =
    eval(Base.parse("inds -> IndividualStage{$(chromosome(def.stage.representation))}[i.$(def.stage.label) for i in inds]"))
  v
end

"""
DOCUMENT: breeder.variation
"""
variation(
  label::AbstractString,
  stage::AbstractString,
  source::AbstractString,
  op::VariationDefinition
) =
  VariationBreederSourceDefinition(label, source, stage, op)

type MultiBreederSource <: BreederSource
  sources::Vector{BreederSource}
  MultiBreederSource(sources::Vector{BreederSource}) = new(sources)
end
