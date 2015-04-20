# encoding: utf-8
load("../state",      dirname(@__FILE__))
load("../criterion",  dirname(@__FILE__))

type EvaluationsCriterion <: Criterion
  limit::Int
  EvaluationsCriterion(limit::Int) = new(limit)
end

is_satisfied(c::EvaluationsCriterion, s::State) = s.evaluations >= c.limit

register("criterion/evaluations", EvaluationsCriterion)
composer("criterion/evaluations") do s
  EvaluationsCriterion(s["limit"])
end
