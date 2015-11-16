# TODO:
# Shared fitness cannot be used until a better distance calculation scheme has
# been implemented. Fitness should not depend on "Individual". Distance schemes
# should be interchangeable.

type SharedFitness{T}
  base::T
  shared::Float

  SharedFitness(f::T) = new(f)
end

type FitnessSharingScheme <: FitnessScheme
  base::FitnessScheme
  radius::Float
  alpha::Float
  dist::Distance

  FitnessSharingScheme(b::FitnessScheme, r::Float, a::Float, d::Distance) =
    new(b, r, a, d)
end

"""
TODO: Document shared fitness schemes.

"""
shared(s::Dict{Any, Any}) =
  SharedFitnessScheme(s["base"], s["radius"], s["alpha"], s["distance"])

uses(s::FitnessSharingScheme) = SharedFitness{uses(s.base)}
maximise(s::FitnessSharingScheme) = maximise(s.base)
assign(s::FitnessSharingScheme, args...) =
  fitness(s.base, args...)

sh(s::FitnessSharingScheme, d::Float) =
  d < s.radius ? 1.0 - (d/s.radius) ^ s.alpha : 0.0

scale!{F}(s::FitnessSharingScheme, inds::Vector{Tuple{Int, F}}) =
  for (i1_id, i1_f) in inds
    i1_f.shared = score(i1_f.base) /
      sum((i2_id, i2_f) -> sh(s, distance(s.distance, i1, i2)), inds)
  end

compare(s::FitnessSharingScheme, x::SharedFitness, y::SharedFitness) =
  if x.shared > y.shared
    maximise(s) ? -1 : 1
  elseif x.shared < y.shared
    maximise(s) ? 1 : -1
  else
    0
  end
