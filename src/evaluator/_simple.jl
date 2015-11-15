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
  if e.stage != ""
    e.stage = p.demes[1].species.genotype.label
  end
  SimpleEvaluator(e.evaluator, e.stage, e.threads)
end

"""
TODO: Short explanation of what a simple evaluator is.
"""
simple(f::Function) =
  SimpleEvaluatorDefinition(f)

function simple{S <: AbstractString}(f::Function, opts::Dict{S, Any})
  def = SimpleEvaluatorDefinition(f)
  
  if haskey(opts, "stage"); def.stage = opts["stage"]; end
  if haskey(opts, "threads"); def.threads = opts["threads"]; end

  def
end

"""
Evaluates all unevaluated individuals within a provided deme according to
a provided simple evaluator.
"""
function evaluate!(e::SimpleEvaluator, s::State, d::Deme)
  for (id, phenome) in enumerate(d.offspring.stages[e.stage])
    d.offspring.fitnesses[id] = e.evaluator(d.species.fitness, phenome)
  end
  s.evaluations += length(d.offspring.stages[e.stage])
end

"""
Evaluates all unevaluated individuals contained within a given state according
to a provided simple evaluator.
"""
evaluate!(e::SimpleEvaluator, s::State) =
  for deme in s.population.demes; evaluate!(e, s, deme); end
