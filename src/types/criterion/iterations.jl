load("../criterion", dirname(@__FILE__))

type IterationsCriterion <: Criterion
  limit::Int
  IterationsCriterion(limit::Int) = new(limit)
end

is_satisfied(c::IterationsCriterion, s::State) = s.iterations >= c.limit

register(joinpath(dirname(@__FILE__), "iterations.manifest.yml"))
