load("population", dirname(@__FILE__))

type State
  population::Population
  iterations::Int64
  evaluations::Int64

  State() = State(Population())
  State(p::Population) = new(p, 0, 0)
end

function reset!(s::State)
  s.iterations = s.evaluations = 0
end
