type ParetoFitness <: Fitness
  objectives::Vector{Float} # Flatten this into a single object?
  rank::Integer
  score::Float

  ParetoFitness(obj::Vector{Float}) = new(obj)
end

type MOGAFitnessScheme
  maximise::Vector{Bool}
end

type LexicographicFitnessScheme
  preference::Vector{Integer}
end

# Could specialise this for each set of preferences?
compare(x::Vector{Float}, y::Vector{Float}) = 
  

register(s::FitnessScheme, obj::Vector{Float})
