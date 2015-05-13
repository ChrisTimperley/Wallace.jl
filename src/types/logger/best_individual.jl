load("../logger", dirname(@__FILE__))

type BestIndividualLogger <: Logger
end

function log!(l::BestIndividualLogger, s::State)
  pbest = best(s.population)
  println("Best fitness: $(describe(pbest.fitness))")
end

composer("logger/best_individual") do s
  BestIndividualLogger()
end
