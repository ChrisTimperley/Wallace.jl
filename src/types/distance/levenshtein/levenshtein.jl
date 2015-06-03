load("../../distance.jl", dirname(@__FILE__))

immutable LevenshteinDistance <: Distance
end

function distance(::LevenshteinDistance, x::DirectIndexString, y::DirectIndexString)
  
end
