type Wrapper
  scores::Vector{Float64}
end

# Need to add maximisation/minimisation flag.
dominates(w1::Wrapper, w2::Wrapper) =
  dominates(w1.scores, w2.scores)

function dominates(x::Vector{Float64}, y::Vector{Float64})
  dom = false
  for (i, xi) in enumerate(x)
    if xi > y[i]
      return false
    elseif xi < y[i]
      dom = true
    end
  end
  return dom
end

function pareto_sets(pts::Vector{Wrapper})
  nfronts = 0
  fronts = Vector{Wrapper}[]
  for p in pts

    # Does this point dominate any point in the pareto front?
    # If so, create a new pareto front containing this point and push the
    # others back.
    if isempty(fronts) || dominates(p, fronts[1][1])
      unshift!(fronts, {p})
      nfronts += 1
    else
      # Does this point belong to any existing pareto fronts? 
      found = false
      for f in 1:nfronts
        if !dominates(fronts[f][1], p)
          push!(fronts[f], p)
          found = true
          break
        end
      end

      # If this point is dominated by all others, creating a new front
      # for it.
      if !found
        push!(fronts, {p})
        nfronts += 1
      end
    end
  end
  return fronts
end

function describe(fronts::Vector{Vector{Wrapper}})
  for (i, f) in enumerate(fronts)
    println("Front-$i:")
    println(join(map(w -> w.scores, f), ", "))
    println()
  end
end

pts = [

  # Pareto Front-1
  Wrapper({0.5, 6.0}),
  Wrapper({1.0, 5.0}),
  Wrapper({1.5, 4.0}),
  Wrapper({2.0, 3.0}),
  Wrapper({3.0, 2.5}),
  Wrapper({4.0, 2.0}),
  Wrapper({5.0, 1.5}),
  Wrapper({6.0, 1.0})

]

describe(pareto_sets(pts))
