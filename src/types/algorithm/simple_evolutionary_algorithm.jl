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
  #pbest = gbest = best(a.state.population)

  prepare!(a.state.population)

  while !any(c -> is_satisfied(c, a.state), values(a.termination))
    breed!(a.state.population)
    evaluate!(a.evaluator, a.state)

    # Record the best individual from the population.
    # --- What does this mean for co-evolution?
    #pbest = best(a.state.population)
    #gbest = best([pbest, gbest])

    replace!(a.replacement, a.state)
    call!(a.loggers, a.state)
    a.state.iterations += 1
  end
  close!(a.loggers)
end

register(joinpath(dirname(@__FILE__), "simple_evolutionary_algorithm.manifest.yml"))
