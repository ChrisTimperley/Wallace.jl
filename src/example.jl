require("Wallace.jl")
using Wallace

def = algorithm.genetic() do alg
  alg.population = population.simple() do pop
    pop.size = 100
    pop.species = species.simple() do sp
      println("a")
    end
    pop.breeder = breeder.simple() do br
      println("b")
      #br.selection = selection.tournament(5)
      #br.mutation = mutation.bit_flip()
      #br.crossover = crossover.one_point()
      println("hello_again")
    end
  end
end

#alg = algorithm.compose!(def)
