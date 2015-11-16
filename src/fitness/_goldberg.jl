type GoldbergFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

"""
Implements a pareto-based multiple-objective fitness scheme through the use
of Goldberg fitness ranking, wherein individuals are assigned a rank based
upon the number of individuals by whom they are dominated, as given by
the formula:

  Rank(i) = 1 + DominatedBy(i)

**Parameters:**

* `of:Type`, the base fitness type (default is Float).
* `maximise:Bool`, a flag, indicating whether fitness values are to be maximised
or minimised.
"""
function goldberg(s::Dict{Any, Any})
   s["of"] = eval(Base.parse(Base.get(s, "of", "Float")))
   GoldbergFitnessScheme{s["of"]}(s["maximise"])
end

function scale!{F}(s::GoldbergFitnessScheme, inds::Vector{Tuple{Int, F}})
  n = length(inds)
  j = k = rank = 1

  # Keep calculating each of the pareto fronts until all individuals have
  # been handled.
  while j <= n

    # Check each remaining member for inclusion in the current pareto front.
    # If the individual belongs to the pareto front then swap it with the 
    # first unsorted individual.
    for i in j:n
      (p1_id, p1_f) = inds[i]
      if all((p2_id, p2_f) -> p1_id == p2_id || !dominates(p2_f.scores, p1_f.scores, s.maximise), inds[j:end])
        p1_f.rank = rank
        inds[k], inds[i] = inds[i], inds[k]
        k += 1
      end
    end

    j = k
    rank += 1
  end
end
