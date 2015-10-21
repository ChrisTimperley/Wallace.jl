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

uses(s::FitnessSharingScheme) = SharedFitness{uses(s.base)}
maximise(s::FitnessSharingScheme) = maximise(s.base)
fitness(s::FitnessSharingScheme, args...) =
  fitness(s.base, args...)

sh(s::FitnessSharingScheme, d::Float) =
  d < s.radius ? 1.0 - (d/s.radius) ^ s.alpha : 0.0

scale!{I <: Individual}(s::FitnessSharingScheme, inds::Vector{I}) =
  for i1 in inds
    i1.fitness.shared = score(i1.fitness.base) /
      sum(i2 -> sh(s, distance(s.distance, i1, i2)), inds)
  end

compare(s::FitnessSharingScheme, x::SharedFitness, y::SharedFitness) =
  if x.shared > y.shared
    maximise(s) ? -1 : 1
  elseif x.shared < y.shared
    maximise(s) ? 1 : -1
  else
    0
  end

register(joinpath(dirname(@__FILE__), "shared.manifest.yml"))
