abstract ParetoFitnessScheme{T} <: FitnessScheme

type ParetoFitness{T}
  scores::Vector{T}
  rank::Integer

  ParetoFitness(s::Vector{T}) = new(s)
end

uses{T}(::ParetoFitnessScheme{T}) = ParetoFitness{T}

fitness{T}(::ParetoFitnessScheme{T}, v::Vector{T}) = ParetoFitness{T}(v)

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
