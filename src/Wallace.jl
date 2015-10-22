push!(LOAD_PATH, dirname(@__FILE__))

"""
TODO: Document Wallace module.
"""
module Wallace
  using StatsBase
  using utility
  using core
  using distance; export distance
  using fitness; export fitness
  using individual
  using representation; export representation
  using selection; export selection
  using variation; export variation
  using crossover; export crossover
  using mutation; export mutation
  using breeder; export breeder
  using _deme_
  using population; export population
  using initialiser; export initialiser
  using state; export state
  using criterion; export criterion
  using replacement; export replacement
  using evaluator; export evaluator
  using logger; export logger
  using algorithm; export algorithm
end
