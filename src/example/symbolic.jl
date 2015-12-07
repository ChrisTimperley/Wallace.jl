"""
Description of the symbolic regression problem.
"""
function symbolic()
  def = algorithm.genetic() do alg
    alg.population = population.simple() do pop
      pop.size = 100
      pop.species = species.simple() do sp
        sp.fitness = fitness.scalar()
        sp.representation = koza.tree() do t
          t.min_depth = 1
          t.max_depth = 18
          t.inputs = ["x::Float64"]
          t.terminals = ["x::Float64"]
          t.non_terminals = [
            "add(x::Float64, y::Float64)::Float64 = x + y"
            "sub(x::Float64, y::Float64)::Float64 = x - y"
            "mul(x::Float64, y::Float64)::Float64 = x * y"
          ]
        end
      end
      pop.breeder = breeder.flat() do br
        br.selection = selection.tournament(2)
        br.mutation = koza.subtree_mutation() do mut
          mut.rate = 0.1
        end
        br.crossover = koza.subtree_crossover(0.9)
      end
    end
    alg.evaluator = evaluator.regression()
    alg.termination = [criterion.generations(1000)]
  end
  algorithm.compose!(def)
end
