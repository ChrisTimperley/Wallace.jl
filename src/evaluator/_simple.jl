"""
Simple evaluators implement a single objective function.
"""
type SimpleEvaluator <: Evaluator
  evaluator::Function
  stage::AbstractString
  threads::Int
end

"""
Provides a definition for a simple evaluator.
"""
type SimpleEvaluatorDefinition <: EvaluatorDefinition
  evaluator::Function
  stage::AbstractString
  threads::Int

  SimpleEvaluatorDefinition(e::Function) =
    new(e, "", 1)
end

"""
Composes a simple evaluator from its definition.
"""
function compose!(e::SimpleEvaluatorDefinition, p::Population)
  if e.stage == ""
    e.stage = p.demes[1].species.genotype.label
  end
  SimpleEvaluator(e.evaluator, e.stage, e.threads)
end

"""
TODO: Short explanation of what a simple evaluator is.
"""
simple(f::Function) =
  SimpleEvaluatorDefinition(f)

"""
Evaluates a provided phenome according to a simple evaluation method.
"""
evaluate{T}(ev::SimpleEvaluator, sch::FitnessScheme, phenome::T) =
  ev.evaluator(sch, phenome)
