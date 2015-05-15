load("../representation", dirname(@__FILE__))

type FloatVectorRepresentation <: Representation
  length::Int
  min::Float
  max::Float
  range::FloatRange

  FloatVectorRepresentation(length::Int, min::Float, max::Float) =
    new(length, min, max, min:max)
end

minimum_value(r::FloatVectorRepresentation) = r.min
maximum_value(r::FloatVectorRepresentation) = r.max
codon_type(::FloatVectorRepresentation) = Float
chromosome(r::FloatVectorRepresentation) = Vector{Float}
describe(i::Vector{Float}) = "($(join(i, ", ")))"
Base.rand(r::FloatVectorRepresentation) = rand(r.range, r.length)

register(joinpath(dirname(@__FILE__), "float_vector.manifest.yml"))
