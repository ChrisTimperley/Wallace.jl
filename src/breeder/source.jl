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
  operator::SelectionDefinition
  
  SelectionBreederSourceDefinition(op::SelectionDefinition) = new(op)
end

type SelectionBreederSource <: BreederSource
  operator::Selection
  eigen::Type
  SelectionBreederSource(s::Selection) = new(s)
end

"""
Composes a given selection breeder source.
"""
function compose!(def::SelectionBreederSourceDefinition)
  s = BreederSource(selection.compose!(def.operator))
  s.eigen = anonymous_type(selection)
  s
end

"""
A selection source.
"""
selection(op::SelectionDefinition) = SelectionBreederSourceDefinition(op) 

"""
Provides a definition of a variation breeder source.
"""
type VariationBreederSourceDefinition <: BreederSourceDefinition
  stage::AbstractString
  source::AbstractString
  operator::VariationDefinition

  VariationBreederSourceDefinition(stage::AbstractString,
    source::AbstractString,
    operator::VariationDefinition
  ) =
    new(stage, source, operator)
end

type VariationBreederSource <: BreederSource
  operator::Variation
  source_name::AbstractString
  stage_name::AbstractString
  eigen::Type
  source::BreederSource
  stage_getter::Function
  VariationBreederSource(v::Variation, source_name::AbstractString, stage_name::AbstractString) =
    new(v, source_name, stage_name)
end

"""
Composes a variation breeder source.

**Parameters:**

* `v::VariationBreederSource`, the breeder source being composed.
* `sources::Dict{AbstractString, Source}`, a dictionary containing the sources
of the breeder that this source belongs to.
"""
function compose!(def::VariationBreederSourceDefinition, sources::Dict{AbstractString, BreederSource})
  v = VariationBreederSource(compose!(def.operator, def.source, def.stage))
  v.eigen = anonymous_type(Wallace)
  v.source = sources[def.source]
  v.stage_getter =
    eval(Base.parse("inds -> IndividualStage{$(chromosome(def.stage.representation))}[i.$(def.stage.label) for i in inds]"))
  v
end

"""
DOCUMENT: breeder.variation
"""
variation(stage::AbstractString, source::AbstractString, op::VariationDefinition) =
  VariationBreederSourceDefinition(op, source, stage)

type MultiBreederSource <: BreederSource
  sources::Vector{BreederSource}
  MultiBreederSource(sources::Vector{BreederSource}) = new(sources)
end
