load("../representation", dirname(@__FILE__))

type IntVectorRepresentation <: Representation
  length::Int
  min::Int
  max::Int
  range::UnitRange{Int}

  IntVectorRepresentation(length::Int, min::Int, max::Int) =
    new(length, min, max, min:max)
end

minimum_value(r::IntVectorRepresentation) = r.min
maximum_value(r::IntVectorRepresentation) = r.max
codon_type(::IntVectorRepresentation) = Int
chromosome(::IntVectorRepresentation) = Vector{Int}
describe(i::Vector{Int}) = "($(join(i, ",")))"
Base.rand(r::IntVectorRepresentation) = rand(r.range, r.length)

composer("representation/int_vector") do s
  IntVectorRepresentation(
    Base.get(s, "length", 80),
    Base.get(s, "min", typemin(Int)),
    Base.get(s, "max", typemax(Int)))
end
