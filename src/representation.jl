module representation
importall individual, core, utility
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
function convert!{I <: Individual}(
  r_from::Representation,
  r_to::Representation,
  n_from::AbstractString,
  n_to::AbstractString,
  inds::Vector{I}
)
  getter = eval(parse("i -> i.$(n_from)"))
  setter = eval(parse("i -> i.$(n_to)"))
  for i in inds
    convert!(r_from, r_to, getter(i), setter(i))
  end
  return inds
end

"""
Produces a description of a provided individual.

TODO: Why is this ::Any, and not ::Individual?
"""
describe(i::Any) = "$(i)"

# Load each of the representations.
include("representation/float_vector.jl")
include("representation/int_vector.jl")
include("representation/bit_vector.jl")
end
