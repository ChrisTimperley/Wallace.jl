"""
An evaluator specialised to dealing with regression problems.
"""
type RegressionEvaluator <: SimpleEvaluator
  num_samples::Int
  samples::Vector{Vector{Float}}

  RegressionEvaluator(samples::Vector{Vector{Float}}) =
    new(length(samples), samples)
end

"""
The regression evaluator measures the fitness of a candidate solution against
the agreement with a series of provided sample observations from an oracle.

TODO: FOR NOW THESE OBSERVATIONS ARE FIXED.
"""
function regression()#s::Dict{Any, Any})
  # Flatten to 1D array?
  samples = Vector{Float}[
    [-10.0, 9090.0],
    [-9.0, 5904.0],
    [-8.0, 3640.0],
    [-7.0, 2100.0],
    [-6.0, 1110.0],
    [-5.0, 520.0],
    [-4.0, 204.0],
    [-3.0, 60.0],
    [-2.0, 10.0],
    [-1.0, 0.0],
    [0.0, 0.0],
    [1.0, 4.0],
    [2.0, 30.0],
    [3.0, 120.0],
    [4.0, 340.0],
    [5.0, 780.0],
    [6.0, 1554.0],
    [7.0, 2800.0],
    [8.0, 4680.0],
    [9.0, 7380.0]
  ]
  RegressionEvaluator(samples)
end

"""
function evaluate!(e::RegressionEvaluator, s::State, sc::FitnessScheme, c::Individual)
  sse = zero(Float)
  diff = zero(Float)
  for x in e.samples
    diff = x[2] - execute(get(c.genome), x[1])
    sse += diff * diff
  end
  fitness(sc, sse)
end
"""
