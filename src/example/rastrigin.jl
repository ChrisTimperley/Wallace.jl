"""
Description of the Rastrigin problem, and the setup used to solve it.

Could accept optional parameters (tournament size, pop size, etc).
"""
function rastrigin()
  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100
      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar()
        sp.representation = representation.float_vector(100, -5.12, 5.12)
      end
      pop.breeder = breeder.simple() do br
        br.selection = selection.tournament(2)
        br.mutation = mutation.gaussian() do mut
          mut.rate = 0.01
          mut.mean = 0.0
          mut.std  = 1.0
        end
        br.crossover = crossover.one_point(1.0)
      end
    end
    alg.evaluator = evaluator.simple("
      f = 1000.0
      for x in get(i.genome)
        f += x*x - 10.0 * cos(2.0 * pi * x)
      end
      assign(scheme, f)
    ")
    alg.termination << criterion.generations(1000)
  end
  algorithm.compose!(def)
end
