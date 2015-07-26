load("../../representation", dirname(@__FILE__))

immutable PermutationRepresentation{T} <: Representation
  alphabet::Vector{T}
  size::Integer

  PermutationRepresentation(a::Vector{T}) = new(a, length(a))
end

Base.rand(r::PermutationRepresentation) = shuffle(r.alphabet) 
chromosome{T}(r::PermutationRepresentation{T}) = Vector{T}

register(joinpath(dirname(@__FILE__), "manifest.yml"))
