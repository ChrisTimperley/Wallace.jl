module representation
importall core, utility, individual, common
export  Representation, RepresentationDefinition, chromosome, convert!,
        describe, minimum_value, maximum_value

"""
The base type used by all representations.
"""
abstract Representation

"""
The base type used by all representation definitions.
"""
abstract RepresentationDefinition

"""
Returns the type used to implement instances of a given representation.
"""
chromosome(r::Representation) =
  error("No `chromosome` representation for $(typeof(r)).")

"""
Converts all instances of a given stage to another for a list of individuals.
"""
convert!(::Any) =
  error("Not yet implemented in updated Individual model.")

"""
Produces a string-based description of a given representation instance.
"""
describe(i::Any) = "$(i)"

# Load each of the representations.
include("representation/float_vector.jl")
include("representation/int_vector.jl")
include("representation/bit_vector.jl")
end
