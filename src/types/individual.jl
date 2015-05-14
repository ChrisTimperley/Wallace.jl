load("fitness.jl",          dirname(@__FILE__))
load("fitness/simple.jl",   dirname(@__FILE__))
load("individual/stage.jl", dirname(@__FILE__))

# The base type used by all individuals.
abstract Individual

Base.isless(x::Individual, y::Individual) =
  !x.evaluated || (y.evaluated && x.fitness < y.fitness)
Base.isequal(x::Individual, y::Individual) = 
  !x.evaluated || (y.evaluated && x.fitness == y.fitness)

register(joinpath(dirname(@__FILE__), "individual.manifest.yml"))
