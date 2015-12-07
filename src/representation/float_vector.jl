type FloatVectorRepresentation <: Representation
  length::Int
  min::Float
  max::Float
  range::FloatRange

  FloatVectorRepresentation(length::Int, min::Float, max::Float) =
    new(length, min, max, min:eps():max)
end

"""
Float vectors are implemented as a fixed-length vector of floating point
numbers.

**Parameters:**
* `length::Int`, the length of this vector. Defaults to 80, if no value is
supplied.
* `min::Float`, the minimum value that a component of this vector may assume.
Defaults to 0.0, if no value is supplied.
* `max::Float`, the maximum value that a component of this vector may assume.
Defaults to 1.0, if no value is supplied.
"""
float_vector{S <: AbstractString}(args::Dict{S, Any}) =
  float_vector( get(args, "length", 80),
                get(args, "min", 0.0),
                get(args, "max", 1.0))
float_vector() = float_vector(80, 0.0, 1.0)
float_vector(length::Int) = float_vector(length, 0.0, 1.0)
float_vector(length::Int, min::Float, max::Float) =
  FloatVectorRepresentation(length, min, max)

minimum_value(r::FloatVectorRepresentation) = r.min
maximum_value(r::FloatVectorRepresentation) = r.max
codon_type(::FloatVectorRepresentation) = Float
chromosome(r::FloatVectorRepresentation) = Vector{Float}
describe(i::Vector{Float}) = "($(join(i, ", ")))"

"""
Generates a float vector at random using its representation.
"""
generate(r::FloatVectorRepresentation) = Base.rand(r.range, r.length)
