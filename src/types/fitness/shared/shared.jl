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

# Sharing function.
sh(s::FitnessSharingScheme, d::Float) =
  d <= s.radius ? 1.0 - (d/s.radius) ^ s.alpha : 0.0

function process!{I <: Individual}(s::FitnessSharingScheme, inds::Vector{I})
  for i1 in inds
    # Vicinity parameter
    i1.fitness.shared = score(i1.fitness.base) /
      sum(i2 -> sh(s, distance(s.distance, i1, i2)), inds)
  end
end

register(joinpath(dirname(@__FILE__), "shared.manifest.yml"))
