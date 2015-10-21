"""
TODO: Add description of distance module.
"""
module distance
using utility
export dist, Distance

"""
The base type used by all distance metrics.
"""
abstract Distance

# Load each of the distance metrics.
include("distance/euclidean.jl")
include("distance/hamming.jl")
include("distance/levenshtein.jl")
end
