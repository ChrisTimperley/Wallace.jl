load("../../fitness", dirname(@__FILE__))

type LexicographicFitnessScheme{T} <: FitnessScheme
  randomised::Bool
  preferences::Vector{Integer} 

  LexicographicFitnessScheme(r::Bool, o::Vector{Integer}) = new(r, o)
end

uses{T}(s::LexicographicFitnessScheme{T}) = Vector{T}

fitness{T}(s::LexicographicFitnessScheme{T}, v::Vector{T}) = v

function compare{T}(s::LexicographicFitnessScheme, x::Vector{T}, y::Vector{T})
  for i in (s.randomised ? shuffle(s.objectives) : s.objectives)
    if x[i] != y[i]
      return y[i] > x[i] ? 1 : -1
    end
  end
  return 0
end

register(joinpath(dirname(@__FILE__), "lexicographic.manifest.yml"))
