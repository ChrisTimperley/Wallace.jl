"""
Description of individual model.
"""
module individual
importall common
using fitness, core, utility
export sort, sort!, isbetter, compare, best, scale!

# Load contents.
include("individual/stage.jl")

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
