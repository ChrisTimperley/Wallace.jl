"""
The examples module demonstrates how Wallace can be used to solve a number of
example problems. Each method within this module is named after the problem
being solved (using snake case), and returns a composed algorithm definition
which can be executed using the `run!` method.
"""
module example
  using core, common, algorithm, logger, criterion, evaluator, replacement,
        crossover, mutation, selection, fitness, population, breeder,
        initialiser, species, representation, koza, utility

  # Load each of the examples.
  include("example/one_max.jl")
  include("example/rastrigin.jl")
  include("example/symbolic.jl")
  include("example/tsp.jl")
end
