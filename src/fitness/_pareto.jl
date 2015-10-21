"""
This scheme adds support for multiple-objective based fitness approaches,
through the addition of domination calculation and pareto rank-based fitness.
"""
abstract ParetoFitnessScheme{T} <: FitnessScheme

type ParetoFitness{T}
  scores::Vector{T}
  rank::Integer

  ParetoFitness(s::Vector{T}) = new(s)
end

uses{T}(::ParetoFitnessScheme{T}) = ParetoFitness{T}
maximise(::ParetoFitnessScheme) = false
assign{T}(::ParetoFitnessScheme{T}, v::Vector{T}) = ParetoFitness{T}(v)

function compare(::ParetoFitnessScheme, x::ParetoFitness, y::ParetoFitness)
  if x.rank != y.rank
    return y.rank > x.rank ? -1 : 1
  end
  return 0
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
