load("../representation", dirname(@__FILE__))
load("int_vector.jl",     dirname(@__FILE__))

type BitVectorRepresentation <: Representation
  length::Int

  BitVectorRepresentation(length::Int) =
    new(length)
end

minimum_value(::BitVectorRepresentation) = 0
maximum_value(::BitVectorRepresentation) = 1
codon_type(::BitVectorRepresentation) = Int
chromosome(::BitVectorRepresentation) = Vector{Int}
Base.rand(r::BitVectorRepresentation) = Base.rand(0:1, r.length)

# Converts a given bit vector chromosome into an int vector chromosome, destructively.
function convert!(r_from::BitVectorRepresentation, r_to::IntVectorRepresentation, c_from::IndividualStage{Vector{Int}}, c_to::IndividualStage{Vector{Int}})
  c_to.value = Array(Int, r_to.length)
  for i in 1:r_to.length
    j = ((i - 1) * 8) + 1
    c_to.value[i] = parseint(join(c_from.value[j:j+7]), 2)
  end
end

function convert!(r_from::IntVectorRepresentation, r_to::BitVectorRepresentation, c_from::IndividualStage{Vector{Int}}, c_to::IndividualStage{Vector{Int}})
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

register("representation/bit_vector", BitVectorRepresentation)
composer("representation/bit_vector") do s
  BitVectorRepresentation(Base.get(s, "length", 100)) 
end
