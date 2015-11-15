"""
Description of the OneMax problem, and the setup used to solve it.

Could accept optional parameters (tournament size, pop size, etc).
"""
function one_max()
  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100
      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar()
        sp.representation = representation.bit_vector(100)
      end
      pop.breeder = breeder.flat() do br
        br.selection = selection.tournament(2)
        br.mutation = mutation.bit_flip(1.0)
        br.crossover = crossover.one_point(0.1)
      end
    end
    alg.evaluator = evaluator.simple(Dict("threads" => 8)) do scheme, genome
      assign(scheme, sum(genome))
    end
    alg.termination["generations"] = criterion.generations(1000)
  end
  algorithm.compose!(def)
end
