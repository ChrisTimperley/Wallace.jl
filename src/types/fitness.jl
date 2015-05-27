abstract Fitness

abstract FitnessScheme

sort(s::FitnessScheme, x::Individual, y::Individual) =


compare(s::FitnessScheme, x::Individual, y::Individual) =
  compare(s, x.fitness, y.fitness)

best(s::FitnessScheme, x::Individual, y::Individual) =
  compare(s, x, y) == 1 ? y : x

Wallace.register(joinpath(dirname(@__FILE__), "fitness.manifest.yml"))
