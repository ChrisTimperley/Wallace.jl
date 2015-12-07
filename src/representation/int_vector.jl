type IntVectorRepresentation <: Representation
  length::Int
  min::Int
  max::Int
  range::UnitRange{Int}

  IntVectorRepresentation(length::Int, min::Int, max::Int) =
    new(length, min, max, min:max)
end

"""
Int vectors are implemented as a fixed-length vector of Int objects.

**Parameters:**
* `length::Int`, the length of this vector. Defaults to 80, if no value is
supplied.
* `min::Float`, the minimum value that a component of this vector may assume.
Defaults to `typemin(Int)`, if no value is supplied.
* `max::Float`, the maximum value that a component of this vector may assume.
Defaults to `typemax(Int)`, if no value is supplied.
"""
int_vector{S <: AbstractString}(args::Dict{S, Any}) =
  int_vector( get(args, "length", 80),
              get(args, "min", typemin(Int)),
              get(args, "max", typemax(Int)))
int_vector() =
  int_vector(80, typemin(Int), typemax(Int))
int_vector(length::Int) =
  int_vector(length, typemin(Int), typemax(Int))
int_vector(length::Int, min::Float, max::Float) =
  IntVectorRepresentation(length, min, max)

minimum_value(r::IntVectorRepresentation) = r.min
maximum_value(r::IntVectorRepresentation) = r.max
codon_type(::IntVectorRepresentation) = Int
chromosome(::IntVectorRepresentation) = Vector{Int}
describe(i::Vector{Int}) = "($(join(i, ",")))"

"""
Generates an int vector at random using its representation.
"""
generate(r::IntVectorRepresentation) = Base.rand(r.range, r.length)
