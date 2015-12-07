"""
Description of TSP, and the setup used to solve it.
"""
function tsp()
  # Compute the absolute location of the TSP example file.
  file_name = "$(dirname(@__FILE__))/tsp/berlin52.tsp"

  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100
      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar(Float, false)
        sp.representation = representation.permutation(1:52)
      end
      pop.breeder = breeder.flat() do br
        br.selection = selection.tournament(2)
        br.mutation = mutation.single_swap()
        br.crossover = crossover.null()
      end
    end
    alg.evaluator = evaluator.tsp(file_name; threads = 8)
    alg.termination = [criterion.generations(1000)]
    alg.loggers = [logger.fitness()]
  end

  # Build and return the algorithm; somewhat redundant.
  algorithm.compose!(def)
end
