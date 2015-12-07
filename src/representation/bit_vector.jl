type BitVectorRepresentation <: Representation
  length::Int

  BitVectorRepresentation(length::Int) =
    new(length)
end

"""
Provides a definition for a bit vector representation.
"""
type BitVectorRepresentationDefinition <: RepresentationDefinition
  length::Int

  BitVectorRepresentationDefinition(length::Int) =
    new(length)
end

"""
Composes a bit vector representation from its provided definition.
"""
compose!(r::BitVectorRepresentationDefinition) =
  BitVectorRepresentation(r.length)

"""
Bit vector representations operate on a fixed-length vector of binary values,
implemented as a vector of Int objects (for now).

**Parameters:**
* `length::Int`, the length of this bit vector. Defaults to `100` if no value
is supplied.
"""
bit_vector() = bit_vector(100)
bit_vector(length::Int) = BitVectorRepresentationDefinition(length)

minimum_value(::BitVectorRepresentation) = 0
maximum_value(::BitVectorRepresentation) = 1
codon_type(::BitVectorRepresentation) = Int
chromosome(::BitVectorRepresentation) = Vector{Int}

"""
Generates a bit vector at random using its representation.
"""
generate(r::BitVectorRepresentation) = Base.rand(0:1, r.length)

# Converts a given bit vector chromosome into an int vector chromosome, destructively.
function convert!(r_from::BitVectorRepresentation,
  r_to::IntVectorRepresentation,
  c_from::IndividualStage{Vector{Int}},
  c_to::IndividualStage{Vector{Int}}
)
  c_to.value = Array(Int, r_to.length)
  for i in 1:r_to.length
    j = ((i - 1) * 8) + 1
    c_to.value[i] = parseint(join(c_from.value[j:j+7]), 2)
  end
end

function convert!(r_from::IntVectorRepresentation,
  r_to::BitVectorRepresentation,
  c_from::IndividualStage{Vector{Int}},
  c_to::IndividualStage{Vector{Int}}
)
  c_to.value = Array(Int, r_to.length)
  for i in 1:r_from.length
    offset = ((i - 1) * 8)
    binary = bin(c_from.value[i], 8)
    for p in 1:8
      j = offset + p
      c_to.value[j] = int(binary[p:p])
    end
  end
end
