push!(LOAD_PATH, dirname(@__FILE__))

module Wallace
  export register, compose

  # Load and import the base and kernel modules.
  include(joinpath(dirname(@__FILE__), "base/identity.jl"))
  include("base/float.jl")
  include("base/partition.jl")
  include("base/each.jl")
  include("base/Reflect.jl")
  include("kernel/parser.jl")
  include("kernel/registry.jl")
  include("kernel/composer.jl")
  include("kernel/example.jl")
  include("kernel/help.jl")

  using .Each
  using .Reflect
  using .Partition
  using .Registry
  using .Parser
  using .Composer
  using .Help
  using DataStructures
  using StatsBase

  using criterion
  export criterion

  using replacement
  export replacement

  using evaluator
  export evaluator
 
  using logger; export logger
end
