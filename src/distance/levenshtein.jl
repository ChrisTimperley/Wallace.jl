immutable LevenshteinDistance <: Distance
end

"""
The Levenshtein distance between two sequences is the minimum number of
single element edits, which may be insertions, deletions, or substitutions,
that are required to transform one sequence into the other.
"""
levenshtein() = LevenshteinDistance()

dist(::LevenshteinDistance, x::DirectIndexString, y::DirectIndexString) =
  error("Not implemented!")
