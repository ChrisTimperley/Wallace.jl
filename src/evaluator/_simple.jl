"""
Simple evaluators implement a single objective function, and use the genotype
of a species when performing the evaluation (as opposed to using some later
stage of development).
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
Simple evaluators implement a single objective function, and use the genotype
of a species when performing the evaluation (as opposed to using some later
stage of development).

"""
simple(f::Function; stage = "", threads = 1) =
  SimpleEvaluatorDefinition(f, stage, max(1, threads))

"""
Evaluates a provided phenome according to a simple evaluation method.
"""
function evaluate{T}(ev::SimpleEvaluator, sch::FitnessScheme, phenome::T)
  println("Called simple evaluator")
  ev.evaluator(sch, phenome)
end
