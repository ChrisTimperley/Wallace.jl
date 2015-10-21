"""
Fitness objects are used to provide an empirical means of assessing the
relative quality of one potential solution to another.
"""
module fitness

abstract Fitness

"""
Base type used by all fitness schemes.
"""
abstract FitnessScheme

# Load each of the fitness schemes.
include("fitness/_pareto.jl")
include("fitness/_aggregate.jl")
include("fitness/_belegundu.jl")
include("fitness/_goldberg.jl")

"""
Responsible for generating a fitness value according to a given scheme.
"""
fitness(s::FitnessScheme) =
  error("No 'fitness' function defined for this fitness scheme.")

"""
Returns the type of object by this fitness scheme to store fitness values.
"""
uses(s::FitnessScheme) =
  error("No 'uses' function defined for this fitness scheme.")

"""
Returns a flag indicating whether or not fitness values produced by a given
scheme should be maximised or minimised.
"""
maximise(::FitnessScheme) =
  error("No 'maximise' function defined for this fitness scheme.")
end