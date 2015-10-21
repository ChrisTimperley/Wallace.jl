push!(LOAD_PATH, dirname(@__FILE__))

module Wallace
  include(joinpath(dirname(@__FILE__), "base/identity.jl"))
  include("base/float.jl")
  include("base/partition.jl")
  include("base/each.jl")
  include("base/Reflect.jl")

  using .Each
  using .Reflect
  using .Partition
  using DataStructures
  using StatsBase

  # Load the core types.
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
  importall deme
  using population; export population
  using initialiser; export initialiser
  using state; export state
  using criterion; export criterion
  using replacement; export replacement
  using evaluator; export evaluator
  using logger; export logger
  using algorithm; export algorithm
end
