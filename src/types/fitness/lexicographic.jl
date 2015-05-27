type LexicographicFitnessScheme <: FitnessScheme
  randomised::Bool
  objectives::Vector{Integer} 
end

function compare{T}(s::LexicographicFitnessScheme, x::Vector{T}, y::Vector{T})
  # If randomised, shuffle the objectives.
  for i in s.objectives
    if x[i] != y[i]
      return y[i] > x[i] ? 1 : -1
    end
  end
  return 0
end
