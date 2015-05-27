load("../../fitness", dirname(@__FILE__))

immutable AggregateFitness{T}
  score::Float
  objectives::Vector{T}
end

type AggregateFitnessScheme <: FitnessScheme
  weights::Vector{Float}
end

fitness(s::AggregateFitnessScheme, o::Vector{T}) =
  AggregateFitness(sum(o .* weights), o)

register(joinpath(dirname(@__FILE__), "aggregate.manifest.yml"))
