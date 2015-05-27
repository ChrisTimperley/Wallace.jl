load("../../fitness", dirname(@__FILE__))

immutable AggregateFitness
  score::Float
  objectives::Vector{Float}
end

type AggregateFitnessScheme <: FitnessScheme
  weights::Vector{Float}
end

fitness(s::AggregateFitnessScheme, o::Vector{Float}) =
  AggregateFitness(sum(o .* weights), o)

register(joinpath(dirname(@__FILE__), "aggregate.manifest.yml"))
