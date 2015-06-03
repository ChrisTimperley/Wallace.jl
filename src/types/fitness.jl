abstract Fitness

abstract FitnessScheme

# Responsible for generating a fitness value according to a given scheme.
fitness(s::FitnessScheme) =
  error("No 'fitness' function defined for this fitness scheme.")

# Returns the type of object by this fitness scheme to store fitness values.
uses(s::FitnessScheme) =
  error("No 'uses' function defined for this fitness scheme.")

# Performs any necessary post-processing on the individuals using this fitness
# scheme.
scale!{I <: Individual}(::FitnessScheme, ::Vector{I}) = return

Wallace.register(joinpath(dirname(@__FILE__), "fitness.manifest.yml"))
