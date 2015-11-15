"""
Simple evaluators implement a single objective function.
"""
type SimpleEvaluator <: Evaluator
  stage::AbstractString
  evaluator::Function
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
TODO: Short explanation of what a simple evaluator is.
"""
simple(f::Function) =
  SimpleEvaluatorDefinition(f)

function simple(f::Function, opts::Dict{AbstractString, Any})
  def = SimpleEvaluatorDefinition(f)
  
  if haskey(opts, "stage"); def.stage = opts["stage"]; end
  if haskey(opts, "threads"); def.stage = opts["threads"]; end

  def
end

"""
Evaluates all unevaluated individuals within a provided deme according to
a provided simple evaluator.
"""
function evaluate!(e::SimpleEvaluator, s::State, d::Deme)
  for (id, phenome) in enumerate(deme.offspring.stages[e.stage])
    deme.offspring.fitnesses[id] = e.evaluator(fs, phenome)
  end
  s.evaluations += length(deme.offspring.stages["phenome"])
end

"""
Evaluates all unevaluated individuals contained within a given state according
to a provided simple evaluator.
"""
evaluate!(e::SimpleEvaluator, s::State) =
  for deme in s.population.demes; evaluate!(e, s, deme); end
