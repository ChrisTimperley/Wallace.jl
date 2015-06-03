load("../pareto/pareto.jl", dirname(@__FILE__))

type BelegunduFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

process!{I <: Individual}(s::BelegunduFitnessScheme, inds::Vector{I}) =
  for p1 in inds
    p1.fitness.rank = any(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds) ? 1 : 0
  end

register(joinpath(dirname(@__FILE__), "belegundu.manifest.yml"))
