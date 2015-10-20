"""
Records information about the best individual within the population after each
generation. Writes a serialised form of the individual to a YAML file named
after the generation number.
"""
type BestIndividualLogger <: Logger; end

"""
Records information about the best individual within the population after each
generation. Writes a serialised form of the individual to a YAML file named
after the generation number.
"""
best_individual() = BestIndividualLogger()

#function log!(l::BestIndividualLogger, s::State)
#  pbest = best(s.population)
#  println("Best fitness: $(describe(pbest.fitness))")
#end
