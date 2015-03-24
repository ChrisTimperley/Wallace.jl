# encoding: utf-8
load("simple", dirname(@__FILE__))

type LambdaEvaluator <: SimpleEvaluator
  objective::Function

  LambdaEvaluator(f::Function) = new(f)
end

evaluate!(e::LambdaEvaluator, s::State, c::Individual) =
  e.objective(e, s, c)
