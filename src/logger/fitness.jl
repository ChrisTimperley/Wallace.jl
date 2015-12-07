immutable FitnessLogger <: Logger; end

immutable FitnessLoggerDefinition <: LoggerDefinition; end

"""
Composes a fitness logger from its definition.
"""
compose!(d::FitnessLoggerDefinition) = FitnessLogger()

"""

"""
fitness() = FitnessLoggerDefinition()

"""
Prints the fitness of the "best" individual within each deme to the standard
output.
"""
function log!(::FitnessLogger, s::State)
  bf = [string(var(d.members.fitnesses)) for d in s.population.demes]
  fs = length(bf) == 1 ? string(bf[1]) : "($(join(", ", map(string, bf)))"
  println("Generation $(s.iterations) [$(s.evaluations)]: $(fs)")
end
