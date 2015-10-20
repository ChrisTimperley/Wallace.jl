"""
Simple evaluators implement a single objective function.
"""
abstract SimpleEvaluator <: Evaluator

"""
Simple evaluator!
"""
function simple(s::Dict{Any, Any})
  eigen = anonymous_type(Wallace, "type <: SimpleEvaluator;end")
  define_function(Wallace, "evaluate!", ["::$(eigen)", "s::State", "scheme::FitnessScheme", "i::Individual"],
    s["objective"])
  return eigen()
end

"""
function evaluate!(e::SimpleEvaluator, s::State)
  # TODO: Limit the number of evaluations, perform in parallel.
  for deme in s.population.demes
    for c in vcat(deme.members, deme.offspring)
      if !c.evaluated
        c.fitness = evaluate!(e, s, deme.species.fitness, c)
        c.evaluated = true
        s.evaluations += 1
      end
    end
  end
end
"""
