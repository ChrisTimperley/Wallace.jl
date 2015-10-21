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
  include("_core.jl")

  using fitness; export fitness
  using representation; export representation
  using individual
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
