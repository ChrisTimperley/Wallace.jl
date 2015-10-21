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

scale!{I <: Individual}(s::BelegunduFitnessScheme, inds::Vector{I}) =
  for p1 in inds
    p1.fitness.rank = any(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds) ? 1 : 0
  end
