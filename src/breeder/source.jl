abstract BreederSource

type SelectionBreederSource <: BreederSource
  operator::Selection
  eigen::Type
  SelectionBreederSource(s::Selection) = new(s)
end

"""
Composes a given selection breeder source.
"""
function compose!(v::SelectionBreederSource)
  v.eigen = anonymous_type(Wallace)
  v
end

"""
A selection source.
"""
selection(op::Selection) = SelectionBreederSource(op) 

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
function compose!(v::VariationBreederSource, sources::Dict{AbstractString, Source})
  v.eigen = anonymous_type(Wallace)
  v.source = sources[v.source_name]
  v.stage_getter =
    eval(Base.parse("inds -> IndividualStage{$(chromosome(stage.representation))}[i.$(stage.label) for i in inds]"))
  v
end

"""
DOCUMENT: breeder.variation
"""
variation(stage::String, source::String, op::Variator) =
  VariationBreederSource(op, source, stage)

type MultiBreederSource <: BreederSource
  sources::Vector{BreederSource}
  MultiBreederSource(sources::Vector{BreederSource}) = new(sources)
end
