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

  # Compute the list of individuals which need to be evaluated.
  # --- Limit to number of remaining evaluations.
  candidates = unevaluated(s.population)

  # Evaluate each individual (in parallel).
  # Or pass as a lambda function?
  for c in candidates
    c.fitness = evaluate!(e, s, c)
    c.evaluated = true
  end

  # Increment the number of evaluations.
  s.evaluations += length(candidates)
  
end

register(joinpath(dirname(@__FILE__), "simple.manifest.yml"))

composer("evaluator/simple") do s
  eigen = anonymous_type(Wallace, "type <: SimpleEvaluator;end")
  define_function(Wallace, "evaluate!", ["::$(eigen)", "s::State", "i::Individual"],
    s["objective"])
  return apply(eigen)
end
