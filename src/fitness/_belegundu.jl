type BelegunduFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

"""
Implements a pareto-based multiple-objective fitness scheme through the use
of Belegundu fitness ranking; individuals belonging to the pareto front are
assigned fitness 0, whilst those outside are assigned 1.
"""
function belegundu(s::Dict{Any, Any})
   s["of"] = eval(Base.parse(Base.get(s, "of", "Float")))
   BelegunduFitnessScheme{s["of"]}(s["maximise"])
end

scale!{F}(s::BelegunduFitnessScheme, inds::Vector{Tuple{Int, F}}) =
  for (p1_id, p1_fitness) in inds
    fitness.rank = any((p2_id, p2_fitness) -> dominates(p2_fitness.scores, p1_fitness.scores, s.maximise), inds) ? 1 : 0
  end
