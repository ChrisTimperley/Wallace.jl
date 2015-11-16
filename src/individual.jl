"""
Description of individual model.
"""
module individual
importall common
using fitness, core, utility
export sort, sort!, isbetter, best!, best

# Load contents.
include("individual/stage.jl")

"""
Sorts a list of individuals in descending order of fitness, from best to worst.
"""
sort{F}(s::FitnessScheme, l::Vector{Tuple{Int, F}}) =
  sort(l, lt = (x, y) -> isbetter(s, x, y)) 

"""
Sorts a list of individuals in descending order of fitness, from best to worst,
in place.
"""
sort!{F}(s::FitnessScheme, l::Vector{Tuple{Int, F}}) =
  sort!(l, lt = (x, y) -> isbetter(s, x, y))

"""
Compares an individual X to an individual Y to determine whether X is an
improvement upon Y.
"""
isbetter{F}(s::FitnessScheme, x::Tuple{Int, F}, y::Tuple{Int, F}) =
  compare(s, x, y) == -1
compare{F}(s::FitnessScheme, x::Tuple{Int, F},  y::Tuple{Int, F}) =
  compare(s, x[2], y[2])

"""
Returns the "best" individual from a provided list, according to a given
fitness scheme.

Fails if the if list of individuals is empty.
"""
function best{F}(s::FitnessScheme, inds::Vector{Tuple{Int, F}})
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
scale!{F}(::FitnessScheme, ::Vector{Tuple{Int, F}}) = return
end
