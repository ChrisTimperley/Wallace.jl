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

function nondominated(p1::Wrapper, pts::Vector{Wrapper})
  for p2 in pts
    if dominates(p2, p1)
      return false
    end
  end
  return true
end

function pareto_sets(pts::Vector{Wrapper})
  fronts = Vector{Wrapper}[[pts[1]]]
  for p in pts[2:end]

    # Does this point dominate any point in the pareto front?
    # If so, create a new pareto front containing this point and push the
    # others back.
    if any(p2 -> dominates(p, p2), fronts[1])
      unshift!(fronts, {p})
    else
      # Is this point dominated by any members of this front?
      # If not, then add it to this front.
      found = false
      for (j, f) in enumerate(fronts)
        if nondominated(p, f)
          push!(f, p)
          found = true
          break
        end
      end

      # If this point is dominated by all others, creating a new front
      # for it.
      if !found
        push!(fronts, {p})
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

  # Pareto Front-1.
  Wrapper({0.0, 0.0}),

  # Pareto Front-2.
  Wrapper({0.5, 6.0}),
  Wrapper({1.0, 5.0}),
  Wrapper({1.5, 4.0}),
  Wrapper({2.0, 3.0}),
  Wrapper({3.0, 2.5}),
  Wrapper({4.0, 2.0}),
  Wrapper({5.0, 1.5}),
  Wrapper({6.0, 1.0}),

  # Pareto Front-3.
  Wrapper({2.0, 6.0}),
  Wrapper({2.5, 5.0}),
  Wrapper({3.0, 4.0}),
  Wrapper({4.0, 3.0}),
  Wrapper({5.0, 2.5}),
  Wrapper({6.0, 2.0}),

  # Pareto Front-4.
  Wrapper({4.0, 6.0}),
  Wrapper({5.0, 4.0}),
  Wrapper({7.0, 3.0})
]

# Shuffle the points about
shuffle!(pts)

describe(pareto_sets(pts))
