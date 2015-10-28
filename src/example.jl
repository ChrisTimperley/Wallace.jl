require("Wallace.jl")
using Wallace

def = algorithm.genetic() do alg
  alg.population = population.simple() do pop
    pop.size = 100
    pop.species = species.simple() do sp
      sp.fitness = fitness.scalar()
      sp.representation = representation.bit_vector()
    end
    pop.breeder = breeder.simple() do br
      br.selection = selection.tournament(5)
      br.mutation = mutation.bit_flip()
      br.crossover = crossover.one_point()
    end
  end
  alg.evaluator = evaluator.simple("
    assign(scheme, sum(get(i.genome)))
  ")

  alg.termination["generations"] = criterion.generations(100)
end

alg = algorithm.compose!(def)
algorithm.run!(alg)
