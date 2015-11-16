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

operate!(::Any) = error("Common stub method: operate!")
end
