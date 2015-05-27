abstract Fitness

abstract FitnessScheme

# Returns the type of object by this fitness scheme to store fitness values.
uses(s::FitnessScheme) =
  error("No 'uses' function defined for this fitness scheme.")

Wallace.register(joinpath(dirname(@__FILE__), "fitness.manifest.yml"))
