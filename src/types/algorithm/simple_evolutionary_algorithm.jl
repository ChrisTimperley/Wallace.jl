load("../algorithm"   , dirname(@__FILE__))
load("../breeder"     , dirname(@__FILE__))
load("../evaluator"   , dirname(@__FILE__))
load("../logger"      , dirname(@__FILE__))
load("../replacement" , dirname(@__FILE__))
load("../criterion"   , dirname(@__FILE__))
load("../initializer" , dirname(@__FILE__))

type SimpleEvolutionaryAlgorithm <: Algorithm
  state::State
  evaluator::Evaluator
  replacement::Replacement
  termination::Dict{String, Criterion}
  loggers::Vector{Logger}
  initializer::Initializer
  output::String

  SimpleEvolutionaryAlgorithm(p::Population, ev::Evaluator, r::Replacement, td::Dict{String, Criterion}, ls::Vector{Logger}, o::String) =
    new(State(p), ev, r, td, ls, DefaultInitializer(), o)
end

function run!(a::SimpleEvolutionaryAlgorithm)
  reset!(a.state)
  prepare!(a.loggers, a.output)
  initialize!(a.initializer, a.state.population)
  evaluate!(a.evaluator, a.state)

  # Record the best individual from the population.
  pbest = gbest = best(a.state.population)

  prepare!(a.state.population)

  while !any(c -> is_satisfied(c, a.state), values(a.termination))
    breed!(a.state.population)
    evaluate!(a.evaluator, a.state)

    # Record the best individual from the population.
    # --- What does this mean for co-evolution?
    pbest = best(a.state.population)
    gbest = best([pbest, gbest])

    replace!(a.replacement, a.state)
    call!(a.loggers, a.state)
    a.state.iterations += 1
  end
  close!(a.loggers)
end

register("algorithm/simple_evolutionary_algorithm", SimpleEvolutionaryAlgorithm)
composer("algorithm/simple_evolutionary_algorithm") do s
  s["output"] = abspath(Base.get(s, "output", "output"))
  s["population"] = compose_as(s["population"], "population")
  s["replacement"] = compose_as(s["replacement"], s["replacement"]["type"])
  s["evaluator"] = compose_as(s["evaluator"], s["evaluator"]["type"])
  s["loggers"] = Logger[compose_as(lg, lg["type"]) for lg in Base.get(s, "loggers", [])]

  s["termination"] = Base.get(s, "termination", Dict{String, Criterion}())
  for t in keys(s["termination"])
    s["termination"][t] = compose_as(s["termination"][t], s["termination"][t]["type"])
  end
  s["termination"] = Dict{String, Criterion}(s["termination"])

  SimpleEvolutionaryAlgorithm(s["population"], s["evaluator"], s["replacement"],
    s["termination"], s["loggers"], s["output"])
end
