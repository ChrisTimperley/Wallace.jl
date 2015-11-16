"""
Simple evaluators implement a single objective function.
"""
type SimpleEvaluator{F} <: Evaluator
  evaluator::F
  stage::AbstractString
  threads::Int
end

"""
Provides a definition for a simple evaluator.
"""
type SimpleEvaluatorDefinition <: EvaluatorDefinition
  stage::AbstractString
  threads::Int
  evaluator::Any

  SimpleEvaluatorDefinition() = new("", 1)
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
function simple(def::Function)
  d = SimpleEvaluatorDefinition()
  def(d)
  d
end

"""
Evaluates all unevaluated individuals within a provided deme according to
a provided simple evaluator.
"""
function evaluate!(e::SimpleEvaluator, s::State, d::Deme)
  for (id, phenome) in enumerate(d.offspring.stages[e.stage])
    d.offspring.fitnesses[id] = e.evaluator(d.species.fitness, get(phenome))
  end
  s.evaluations += length(d.offspring.stages[e.stage])
end

"""
Evaluates all unevaluated individuals contained within a given state according
to a provided simple evaluator.
"""
evaluate!(e::SimpleEvaluator, s::State) =
  for deme in s.population.demes; evaluate!(e, s, deme); end
