type MOGAFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

"""
TODO: Describe MOGA.
"""
moga(s::Dict{Any, Any}) =
  MOGAFitnessScheme{eval(Base.parse(Base.get(s, "of", "Float")))}(s["maximise"])

scale!{I <: Individual}(s::MOGAFitnessScheme, inds::Vector{I}) =
  for p1 in inds
    p1.fitness.rank = 1 + count(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds)
  end
