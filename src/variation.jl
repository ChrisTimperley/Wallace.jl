module variation
using   core, representation
export  Variation, num_inputs, num_outputs, operate!, call!,
        VariationDefinition

"""
The base type used by all variation operator definitions.
"""
abstract VariationDefinition <: OperatorDefinition

"""
The base type used by all variation operators.
"""
abstract Variation <: Operator

"""
Returns the representation used by inputs to this operator.
"""
rep(v::Variation) = v.representation

"""
Returns the number of inputs to a given variation operator.
Should be implemented by each variation operator.
"""
num_inputs(v::Variation) =
  error("Unimplemented `num_inputs` function for: $(v).")

"""
Returns the number of outputs for a given variation operator.
Should be implemented by each variation operator.
"""
num_outputs(v::Variation) =
  error("Unimplemented `num_outputs` function for: $(v).")

"""
Prepares this variation operator for the breeding process.
Why is this here?
"""
prepare{I <: Individual}(v::Variation, m::Vector{I}) = I[]

operate!(v::Variation, inputs::Vector{Any}) =
  error("Unimplemented `operate!` function for: $(v).")

# Instead we could simply perform the "getter" operations within the breeder.
call!{I <: Individual}(v::Variation, getter::Function, inputs::Vector{I}) =
  operate!(v, getter(inputs))
end
