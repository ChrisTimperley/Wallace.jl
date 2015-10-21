"""
Aggregate fitness reduces a set of individual search objectives to a single
scalar fitness value.
"""
immutable AggregateFitness
  score::Float
  objectives::Vector{Float}
end

type AggregateFitnessScheme <: FitnessScheme
  maximise::Bool
  weights::Vector{Float}
  
  AggregateFitnessScheme(m::Bool, w::Vector{Float}) = new(m, w)
end

"""
This fitness scheme operates by aggregating the weighted values of each of
the objectives into a single scalar value, which is to be either maximised
or minimised.

**Properties:**

* `weights::Vector{Float}`, a list holding the weights used for each of the
objective values upon aggregation.
* `maximise::Bool`, a flag indicating whether the aggregated fitness value
should be maximised.
"""
aggregate(s::Dict{Any, Any}) =
  # Need to handle weights.
  aggregate(Base.get(s, "maximise", true), s["weights"])

aggregate(maximise::Bool, weights::Vector{Float}) =
  AggregateFitnessScheme(maximise, weights)

uses(s::AggregateFitnessScheme) = AggregateFitness
maximise(s::AggregateFitnessScheme) = s.maximise
assign(s::AggregateFitnessScheme, o::Vector{Float}) =
  AggregateFitness(sum(o .* weights), o)
