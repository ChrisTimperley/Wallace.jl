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
function compose!(
  def::SelectionBreederSourceDefinition,
  ::Species,
  ::Dict{AbstractString, BreederSource}
)
  op = compose!(def.operator)
  s = SelectionBreederSource(def.label, op)
  s.eigen = anonymous_type(breeder)
  s
end

"""
A selection source.
"""
selection_source(label::AbstractString, op::SelectionDefinition) =
  SelectionBreederSourceDefinition(label, op) 

"""
Provides a definition of a variation breeder source.
"""
type VariationBreederSourceDefinition <: BreederSourceDefinition
  label::AbstractString
  source::AbstractString
  stage::AbstractString
  operator::VariationDefinition

  VariationBreederSourceDefinition(
    label::AbstractString,
    source::AbstractString,
    stage::AbstractString,
    operator::VariationDefinition
  ) =
    new(label, source, stage, operator)
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

* `def::VariationBreederSourceDefinition`, a definition of the breeder source
that is to be composed.
* `species::Species`, the species that this breeder belongs to.
* `sources::Dict{AbstractString, Source}`, a dictionary containing the sources
of the breeder that this source belongs to.
"""
function compose!(
  def::VariationBreederSourceDefinition,
  sp::Species,
  sources::Dict{AbstractString, BreederSource}
)
  # Find the stage and representation used by this source.
  stage = sp.stages[def.stage]
  representation = species.rep(stage) # TODO: FIX FIX FIX

  # Build the variation operator.
  op = compose!(def.operator, representation)

  # Build the breeder source.
  v = VariationBreederSource(def.label, op, def.source, def.stage)
  v.eigen = anonymous_type(breeder)
  v.source = sources[def.source]
  v.stage_getter =
    eval(Main, Base.parse("inds -> Wallace.IndividualStage{$(chromosome(representation))}[i.$(def.stage) for i in inds]"))
  v
end

"""
DOCUMENT: breeder.variation
"""
variation_source(
  label::AbstractString,
  source::AbstractString,
  stage::AbstractString,
  op::VariationDefinition
) =
  VariationBreederSourceDefinition(label, source, stage, op)

type MultiBreederSource <: BreederSource
  sources::Vector{BreederSource}
  MultiBreederSource(sources::Vector{BreederSource}) = new(sources)
end
