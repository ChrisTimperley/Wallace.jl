"""
Description of individual model.
"""
module individual
using fitness
export Individual, sort, sort!, isbetter, compare, best, scale!, individual

# Load contents.
include("individual/stage.jl")

"""
The base type used by all individuals.
"""
abstract Individual

function individual(s::Dict{Any, Any})
  # Create an array to hold each of the lines of the type definition.
  # Add the evaluated and species properties.
  definition = ["evaluated::Bool"]#, "species::Species"]

  # Generate a property for each stage of development for this individual.
  # The genotype must be placed first; in order to do this, we generate a list
  # of stages, search for the genotype, and swap the stage at the first index
  # with the genotype stage.
  stages = collect(values(s["stages"]))
  for i in length(stages)
    if root(stages[i])
      t = stages[1]
      stages[1] = stages[i]
      stages[i] = t
    end
  end

  # With the stages in a safe order, proceed to generate a property
  # definition for each of them.
  for stage in stages
    push!(definition, "$(stage.label)::IndividualStage{$(chromosome(stage))}")
  end

  # Add the fitness property.
  push!(definition, "fitness::$(uses(s["fitness"]))")
  
  # Build the empty constructor.
  push!(definition, "constructor() = new(" * 
    join(vcat(["false"], ["IndividualStage{$(chromosome(stages[i]))}()" for i in 1:length(stages)]), ",") *  
    ")"
  )

  # Build the full constructor.
  push!(definition, "constructor(" *
    join(["s$(i)::IndividualStage{$(chromosome(stages[i]))}" for i in 1:length(stages)], ",") *
    ") = new(" *
    join(vcat(["false"], ["s$(i)" for i in 1:length(stages)]), ",") *
    ")"
  )

  # Add the header and footer to the type definition, before composing it
  # into an anonymous type.
  unshift!(definition, "type <: Individual")
  push!(definition, "end")
  t = anonymous_type(Wallace, join(definition, "\n"))

  # Build the cloning operation for this type.
  cloner = join(["i.$(stage.label)" for stage in stages], ",")
  cloner = "clone(i::$(t)) = $(t)($(cloner))"
  eval(Wallace, Base.parse(cloner))

  # Build the describe operation for this type.
  describer = join(vcat(["fitness: \$(describe(i.fitness))"], ["$(stage.label):\n\$(describe(i.$(stage.label)))" for stage in stages]), "\n")
  describer = "describe(i::$(t)) = \"$(describer)\""
  eval(Wallace, Base.parse(describer))
  
  # Return the generated individual type.
  return t
end

"""
Sorts a list of individuals in descending order of fitness, from best to worst.
"""
sort{I <: Individual}(s::FitnessScheme, l::Vector{I}) =
  sort(l, lt = (x, y) -> isbetter(s, x, y)) 

"""
Sorts a list of individuals in descending order of fitness, from best to worst,
in place.
"""
sort!{I <: Individual}(s::FitnessScheme, l::Vector{I}) =
  sort!(l, lt = (x, y) -> isbetter(s, x, y))

"""
Compares an individual X to an individual Y to determine whether X is an
improvement upon Y.
"""
isbetter(s::FitnessScheme, x::Individual, y::Individual) =
  compare(s, x, y) == -1
compare{I <: Individual}(s::FitnessScheme, x::I,  y::I) =
  !x.evaluated ? 1 : compare(s, x.fitness, y.fitness)

"""
Returns the "best" individual from a provided list, according to a given
fitness scheme.

Fails if the if list of individuals is empty.
"""
function best{I <: Individual}(s::FitnessScheme, inds::Vector{I})
  bst = inds[1]
  for i in inds
    if isbetter(s, i, bst)
      bst = i
    end
  end
  return bst
end

"""
Performs any necessary post-processing on the individuals using this fitness
scheme.
"""
scale!{I <: Individual}(::FitnessScheme, ::Vector{I}) = return
end
