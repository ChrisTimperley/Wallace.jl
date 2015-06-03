load("../../fitness", dirname(@__FILE__))

immutable AggregateFitness
  score::Float
  objectives::Vector{Float}
end

type AggregateFitnessScheme <: FitnessScheme
  weights::Vector{Float}
  maximise::Bool
  
  AggregateFitnessScheme(w::Vector{Float}, m::Bool) = new(w, m)
end

uses(s::AggregateFitnessScheme) = AggregateFitness
maximise(s::AggregateFitnessScheme) = s.maximise
fitness(s::AggregateFitnessScheme, o::Vector{Float}) =
  AggregateFitness(sum(o .* weights), o)

register(joinpath(dirname(@__FILE__), "aggregate.manifest.yml"))
