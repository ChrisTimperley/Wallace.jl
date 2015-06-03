load("../pareto/pareto.jl", dirname(@__FILE__))

type MOGAFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

scale!{I <: Individual}(s::MOGAFitnessScheme, inds::Vector{I}) =
  for p1 in inds
    p1.fitness.rank = 1 + count(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds)
  end

register(joinpath(dirname(@__FILE__), "moga.manifest.yml"))
