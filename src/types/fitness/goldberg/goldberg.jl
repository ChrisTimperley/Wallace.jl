type GoldbergFitnessScheme{T} <: ParetoFitnessScheme{T}
  maximise::Vector{Bool}
end

function process!{I <: Individual}(s::GoldbergFitnessScheme, inds::Vector{I})
  n = length(inds)
  j = k = rank = 1

  # Keep calculating each of the pareto fronts until all individuals have
  # been handled.
  while j <= n

    # Check each remaining member for inclusion in the current pareto front.
    # If the individual belongs to the pareto front then swap it with the 
    # first unsorted individual.
    for i in j:n
      p1 = inds[i]
      if all(p2 -> p1 == p2 || !dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds[j:end])
        p1.fitness.rank = rank
        inds[k], inds[i] = inds[i], inds[k]
        k += 1
      end
    end

    j = k
    rank += 1
  end
end
