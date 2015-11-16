"""
An evaluator specialised to dealing with regression problems.
"""
type RegressionEvaluator <: Evaluator
  num_samples::Int
  samples::Vector{Tuple{Float, Float}}

  RegressionEvaluator(samples::Vector{Tuple{Float, Float}}) =
    new(length(samples), samples)
end

"""
Provides a definition for a regression evaluator.
"""
type RegressionEvaluatorDefinition <: EvaluatorDefinition
  samples::Vector{Tuple{Float, Float}}
end

"""
Composes a regression evaluator from a provided definition.
"""
compose!(def::RegressionEvaluatorDefinition) =
  RegressionEvaluator(def.samples)

"""
The regression evaluator measures the fitness of a candidate solution against
the agreement with a series of provided sample observations from an oracle.

TODO: FOR NOW THESE OBSERVATIONS ARE FIXED.
"""
regression() =
  regression([
    (-10.0, 9090.0),
    (-9.0, 5904.0),
    (-8.0, 3640.0),
    (-7.0, 2100.0),
    (-6.0, 1110.0),
    (-5.0, 520.0),
    (-4.0, 204.0),
    (-3.0, 60.0),
    (-2.0, 10.0),
    (-1.0, 0.0),
    (0.0, 0.0),
    (1.0, 4.0),
    (2.0, 30.0),
    (3.0, 120.0),
    (4.0, 340.0),
    (5.0, 780.0),
    (6.0, 1554.0),
    (7.0, 2800.0),
    (8.0, 4680.0),
    (9.0, 7380.0)
  ])

regression(samples::Array{Tuple{Float, Float}}) =
  RegressionEvaluatorDefinition(samples)

"""
Evaluates all unevaluated individuals within a provided deme according to
a provided simple evaluator.
"""
function evaluate!(e::SimpleEvaluator, s::State, d::Deme)
  for (id, phenome) in enumerate(d.offspring.stages[e.stage])
    d.offspring.fitnesses[id] = evaluate!(e, s, d.species.fitness, get(phenome))
  end
  s.evaluations += length(d.offspring.stages[e.stage])
end

"""
Evaluates all unevaluated individuals contained within a given state according
to a provided simple evaluator.
"""
evaluate!(e::SimpleEvaluator, s::State) =
  for deme in s.population.demes; evaluate!(e, s, deme); end

function evaluate!(e::RegressionEvaluator, s::State, sc::FitnessScheme, c::Vector{Float})
  sse = zero(Float)
  diff = zero(Float)
  for (x, y) in e.samples
    diff = y - execute(get(c.genome), x)
    sse += diff * diff
  end
  assign(sc, sse)
end
