load("simple", dirname(@__FILE__))
load("../fitness/simple", dirname(@__FILE__))

type RegressionEvaluator <: SimpleEvaluator
  num_samples::Int
  samples::Vector{Vector{Float}}

  RegressionEvaluator(samples::Vector{Vector{Float}}) =
    new(length(samples), samples)
end

function evaluate!(e::RegressionEvaluator, s::State, c::Individual)
  sse = zero(Float)
  diff = zero(Float)
  for x in e.samples
    diff = x[2] - execute(get(c.tree), x[1])
    sse += diff * diff
  end
  SimpleFitness{Float}(false, sse)
end

register("evaluator/regression", RegressionEvaluator)
composer("evaluator/regression") do s

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

  return RegressionEvaluator(samples)
end
