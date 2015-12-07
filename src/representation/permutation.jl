"""
Provides a (possibly incomplete) description of a permutation representation.
"""
type PermutationRepresentationDefinition{T} <: RepresentationDefinition
  alphabet::Vector{T}
end

immutable PermutationRepresentation{T} <: Representation
  """
  The alphabet of values (which may take any form, as specified by the type parameter, T)
  whose permutations are to be searched.
  """
  alphabet::Vector{T}

  """
  The number of values in the alphabet for this representation.
  """
  size::Int
end

"""
Composes a permutation representation from a provided definition.
"""
compose!{T}(def::PermutationRepresentationDefinition{T}) =
  PermutationRepresentation{T}(def.alphabet, length(def.alphabet))

"""
Builds a permutation representation using an alphabet defined by a given
unit range of values.
"""
permutation(range::UnitRange) =
  permutation(collect(range))

"""
Builds a permutation representation using an alphabet supplied as a vector
(i.e. a one-dimensional array) of values.
"""
permutation{T}(alphabet::Vector{T}) =
  PermutationRepresentationDefinition(alphabet)

"""
Returns the chromosome used by this permutation representation (which is always
implemented as a vector of some type, T, given by the permutation template
parameters).
"""
chromosome{T}(rep::PermutationRepresentation{T}) = Vector{T}

"""
Returns the codon type used by this permutation, given by its template
parameter, T.
"""
codon_type{T}(rep::PermutationRepresentation{T}) = T

#"""
#Produces a human-readable string representation of an instance of this
#permutation representation.
#"""
#describe{T}(::PermutationRepresentationDefinition{T}, ins::Vector{T}) = 

"""
Produces a random permutation using a provided permutation representation.
"""
generate{T}(r::PermutationRepresentation{T}) =
  shuffle(r.alphabet)
