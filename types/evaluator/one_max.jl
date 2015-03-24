load("simple",            dirname(@__FILE__))
load("../fitness/simple", dirname(@__FILE__))

type OneMaxEvaluator <: SimpleEvaluator; end

evaluate!(::OneMaxEvaluator, s::State, c::Individual) =
  SimpleFitness{Int}(true, sum(c.genome))

register("evaluator/one_max", OneMaxEvaluator)
composer("evaluator/one_max") do s
  OneMaxEvaluator()
end
