load("../criterion", dirname(@__FILE__))

type IterationsCriterion <: Criterion
  limit::Int
  IterationsCriterion(limit::Int) = new(limit)
end

is_satisfied(c::IterationsCriterion, s::State) = s.iterations >= c.limit

composer("criterion/iterations") do s
  IterationsCriterion(s["limit"])
end
