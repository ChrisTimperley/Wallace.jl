type GoldbergFitness{T}
  scores::Vector{T}
  rank::Integer

  GoldbergFitness(s::Vector{T}) = new(s)
end

type SharedFitness{T}
  fitness::T
  shared::Float64

  SharedFitness(f::T) = new(f)
end

type Wrapper
  fitness::GoldbergFitness{Float64}

  Wrapper(s::Vector{Float64}) = new(GoldbergFitness{Float64}(s))
end

function dominates{T}(x::Vector{T}, y::Vector{T}, maximise::Vector{Bool})
  dom = false
  for (i, xi) in enumerate(x)
    if xi != y[i]
      if (xi > y[i]) == maximise[i]
        dom = true
      else
        return false
      end
    end
  end
  return dom
end

abstract FitnessScheme

type FitnessSharingScheme <: FitnessScheme
  base::FitnessScheme
  radius::Float64
  alpha::Float64
  dist::Function
end

# Sharing function.
sh(s::FitnessSharingScheme, d::Float64) =
  d <= s.radius ? 1 - (d/s.radius) ^ s.alpha : 0

type MOGAFitnessScheme
  maximise::Vector{Bool}
end

type GoldbergFitnessScheme
  maximise::Vector{Bool}
end

type BelegunduFitnessScheme
  maximise::Vector{Bool}
end

function process!(s::BelegunduFitnessScheme, inds::Vector{Wrapper})
  for p1 in inds
    p1.fitness.rank = any(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds) ? 1 : 0
  end
end

function process!(s::MOGAFitnessScheme, inds::Vector{Wrapper})
  for p1 in inds
    p1.fitness.rank = 1 + count(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds)
  end
end

function process!(s::GoldbergFitnessScheme, inds::Vector{Wrapper})
  n = length(inds)
  j = k = rank = 1

  # Keep calculating each of the pareto fronts until all individuals have
  # been handled.
  while j <= n

    # Check each remaining member for inclusion in the current pareto front.
    # If the individual belongs to the pareto front then swap it with the 
    # first unsorted individual.
    for i in j:n
      p1 = inds[i]
      if all(p2 -> p1 == p2 || !dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds[j:end])
        p1.fitness.rank = rank
        inds[k], inds[i] = inds[i], inds[k]
        k += 1
      end
    end

    j = k
    rank += 1
  end
end

function process!(s::FitnessSharingScheme, inds::Vector{Wrapper})
  for i1 in inds
    i1.fitness.shared = score(i1.fitness.fitness) /
      sum(i2 -> sh(s, s.distance(i1, i2)), inds)
  end
end

pts = [

  # Pareto Front-1.
  Wrapper([0.0, 0.0]),

  # Pareto Front-2.
  Wrapper([0.5, 6.0]),
  Wrapper([1.0, 5.0]),
  Wrapper([1.5, 4.0]),
  Wrapper([2.0, 3.0]),
  Wrapper([3.0, 2.5]),
  Wrapper([4.0, 2.0]),
  Wrapper([5.0, 1.5]),
  Wrapper([6.0, 1.0]),

  # Pareto Front-3.
  Wrapper([2.0, 6.0]),
  Wrapper([2.5, 5.0]),
  Wrapper([3.0, 4.0]),
  Wrapper([4.0, 3.0]),
  Wrapper([5.0, 2.5]),
  Wrapper([6.0, 2.0]),

  # Pareto Front-4.
  Wrapper([4.0, 6.0]),
  Wrapper([5.0, 4.0]),
  Wrapper([7.0, 3.0])
]

#scheme = MOGAFitnessScheme([false, false])
#scheme = GoldbergFitnessScheme([false, false])
scheme = BelegunduFitnessScheme([false, false])

process!(scheme, pts)

for p in pts
  println("$(p.fitness.scores): $(p.fitness.rank)")
end
