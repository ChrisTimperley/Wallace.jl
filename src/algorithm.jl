"""
TODO: Description of algorithm module.
"""
module algorithm
importall common
export run!

"""
The base type used by all algorithms.
"""
abstract Algorithm

"""
Runs a given algorithm instance provided by the user, before returning its
state.
"""
run!(a::Algorithm) = 
  error("No `run!` method defined for this algorithm: $(a).")

# Load each of the algorithms.
include("algorithm/genetic.jl")
end
