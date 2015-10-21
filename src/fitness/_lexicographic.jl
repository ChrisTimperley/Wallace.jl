type LexicographicFitnessScheme{T} <: FitnessScheme
  randomised::Bool
  preferences::Vector{Integer} 

  LexicographicFitnessScheme(r::Bool, o::Vector{Integer}) = new(r, o)
end

"""
TODO: Add description of lexicographic fitness scheme.

TODO: Could make this lazy?

**Properties:**
  
* `randomised::Bool`, a flag indicating whether the preference for specific
objectives should be randomised at each comparison.
* `preferences::Vector{Int}`, a list, specifying the order in which each of
objectives should be compared, given as a list of objective indices
(one-indexed).
"""
lexicographic(s::Dict{Any, Any}) =
  lexicographic(Base.get(s, "randomised", false), s["preferences"])

lexicographic(randomised::Bool, preferences::Vector{Int}) =
  LexicographicFitnessScheme(randomised, preferences)

lexicographic(preferences::Vector{Int}) =
  lexicographic(false, preferences)

uses{T}(s::LexicographicFitnessScheme{T}) = Vector{T}

assign{T}(s::LexicographicFitnessScheme{T}, v::Vector{T}) = v

function compare{T}(s::LexicographicFitnessScheme, x::Vector{T}, y::Vector{T})
  for i in (s.randomised ? shuffle(s.objectives) : s.objectives)
    if x[i] != y[i]
      return y[i] > x[i] ? 1 : -1
    end
  end
  return 0
end
