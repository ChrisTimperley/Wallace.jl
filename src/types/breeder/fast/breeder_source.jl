load("../../operator/selection", dirname(@__FILE__))
load("../../operator/variation", dirname(@__FILE__))
load("../../species/stage",   dirname(@__FILE__))

abstract BreederSource

type SelectionBreederSource <: BreederSource
  eigen::Type
  operator::Selection
  SelectionBreederSource(s::Selection) =
    new(anonymous_type(Wallace), s)
end

type VariationBreederSource <: BreederSource
  eigen::Type
  operator::Variation
  source::BreederSource
  stage_name::AbstractString
  stage_getter::Function
  VariationBreederSource(v::Variation, s::BreederSource, stage::SpeciesStage) =
    new(anonymous_type(Wallace), v, s, stage.label,
      eval(Base.parse("inds -> IndividualStage{$(chromosome(stage.representation))}[i.$(stage.label) for i in inds]")))
end

type MultiBreederSource <: BreederSource
  sources::Vector{BreederSource}
  MultiBreederSource(sources::Vector{BreederSource}) = new(sources)
end

register(joinpath(dirname(@__FILE__), "selection.manifest.yml"))
register(joinpath(dirname(@__FILE__), "variation.manifest.yml"))
