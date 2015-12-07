using state, breeder, evaluator, logger, replacement, criterion, initialiser,
      population

"""
Builder for algorithm.genetic.
"""
type GeneticAlgorithmDefinition
  output::AbstractString
  replacement::Replacement
  loggers::Vector{LoggerDefinition}
  termination::Vector{Criterion}
  population::PopulationDefinition
  evaluator::EvaluatorDefinition

  GeneticAlgorithmDefinition() =
    new("output", replacement.generational(), [], [])
end

type GeneticAlgorithm <: Algorithm
  state::State
  evaluator::Evaluator
  replacement::Replacement
  termination::Vector{Criterion}
  loggers::Vector{Logger}
  initialiser::Initialiser
  output::AbstractString

  GeneticAlgorithm() = new()
end

"""
Composes an `algorithm.genetic` instance from information provided within a
supplied builder.
"""
function compose!(def::GeneticAlgorithmDefinition)
  alg = GeneticAlgorithm()
  pop = population.compose!(def.population)
  alg.state = State(pop)
  alg.evaluator = compose!(def.evaluator,  pop)
  alg.replacement = def.replacement
  alg.termination = def.termination
  alg.initialiser = initialiser.DefaultInitialiser()
  alg.output = abspath(def.output)
  alg.loggers = Logger[compose!(l) for l in def.loggers]
  alg
end

"""
TODO: Explain algorithm.genetic
"""
function genetic(def::Function)
  d = GeneticAlgorithmDefinition()
  def(d)
  d
end

function run!(a::GeneticAlgorithm)
  reset!(a.state)
  prepare!(a.loggers, a.output)
  initialise!(a.initialiser, a.state.population)
  evaluate!(a.evaluator, a.state)
  scale!(a.state.population)

  # Record the best individual from the population.
  #pbest = gbest = best(a.state.population)

  #prepare!(a.state.population)

  while !any(c -> is_satisfied(c, a.state), a.termination)
    breed!(a.state.population)
    evaluate!(a.evaluator, a.state)
    scale!(a.state.population)

    # Record the best individual from the population.
    # --- What does this mean for co-evolution?
    #pbest = best(a.state.population)
    #gbest = best([pbest, gbest])

    # Debugging, for now.

    replace!(a.replacement, a.state)
    scale!(a.state.population)
    logger.call!(a.loggers, a.state)
    a.state.iterations += 1
  end
  logger.close!(a.loggers)
end
