type MOGAFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

"""
TODO: Describe MOGA.
"""
moga(s::Dict{Any, Any}) =
  MOGAFitnessScheme{eval(Base.parse(Base.get(s, "of", "Float")))}(s["maximise"])

scale!{F}(s::MOGAFitnessScheme, inds::Vector{Tuple{Int, F}}) =
  for (p1_id, p1_f) in inds
    p1_f.rank = 1 + count((p2_id, p2_f) -> dominates(p2_f.scores, p1_f.scores, s.maximise), inds)
  end
