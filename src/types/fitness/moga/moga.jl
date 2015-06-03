load("../pareto/pareto.jl", dirname(@__FILE__))

type MOGAFitnessScheme <: FitnessScheme
  maximise::Vector{Bool}
end

process!{I <: Individual}(s::MOGAFitnessScheme, inds::Vector{I}) =
  for p1 in inds
    p1.fitness.rank = 1 + count(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds)
  end
