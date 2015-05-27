load("../evaluator",  dirname(@__FILE__))
load("../state",      dirname(@__FILE__))
load("../individual", dirname(@__FILE__))

# Simple evaluators implement a single objective function.
abstract SimpleEvaluator <: Evaluator

# Evaluates the state of 
function evaluate!(
  e::SimpleEvaluator,
  s::State
  #termination_conditions::Array{Criterion, 1})
)
  # Limit the number of evaluations, perform in parallel.
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

register(joinpath(dirname(@__FILE__), "simple.manifest.yml"))
