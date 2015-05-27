load("fitness.jl",          dirname(@__FILE__))
load("fitness/simple.jl",   dirname(@__FILE__))
load("individual/stage.jl", dirname(@__FILE__))

# The base type used by all individuals.
abstract Individual

# Sorts a list of individuals in descending order of fitness,
# from best to worst.
sort{I <: Individual}(s::FitnessScheme, l::Vector{I}) =
  sort(l, lt = (x, y) -> isbetter(s, x, y)) 

# Sorts a list of individuals in descending order of fitness,
# from best to worst, in place.
sort!{I <: Individual}(s::FitnessScheme, l::Vector{I}) =
  sort!(l, lt = (x, y) -> isbetter(s, x, y))

# Compares an individual X to an individual Y to determine whether X is
# an improvement upon Y.
isbetter(s::FitnessScheme, x::Individual, y::Individual) =
  compare(s, x, y) == -1

compare{I <: Individual}(s::FitnessScheme, x::I,  y::I) =
  !x.evaluated ? 1 : compare(s, x.fitness, y.fitness)

Base.isless(x::Individual, y::Individual) =
  !x.evaluated || (y.evaluated && x.fitness < y.fitness)
Base.isequal(x::Individual, y::Individual) = 
  !x.evaluated || (y.evaluated && x.fitness == y.fitness)

register(joinpath(dirname(@__FILE__), "individual.manifest.yml"))
