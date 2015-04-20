load("../operator",  dirname(@__FILE__))

abstract Variation <: Operator

# Returns the representation used by inputs to this operator.
representation(v::Variation) = v.representation

# Returns the number of inputs to a given variation operator.
# Should be implemented by each variation operator.
num_inputs(v::Variation) =
  error("Unimplemented `num_inputs` function for: $(v).")

# Returns the number of outputs for a given variation operator.
# Should be implemented by each variation operator.
num_outputs(v::Variation) =
  error("Unimplemented `num_outputs` function for: $(v).")

# Prepares this variation operator for the breeding process.
# Why is this here?
prepare{I <: Individual}(v::Variation, m::Vector{I}) = I[]

operate!(v::Variation, inputs::Vector{Any}) =
  error("Unimplemented `operate!` function for: $(v).")

# For now...
#function call!{I <: Individual}(v::Variation, stage::String, inputs::Vector{I})
#  operate!(v, map(eval(parse("i -> i.$(stage)")), inputs))
#end

# Instead we could simply perform the "getter" operations within the breeder.
call!{I <: Individual}(v::Variation, getter::Function, inputs::Vector{I}) =
  operate!(v, getter(inputs))

register("variation", Variation)
