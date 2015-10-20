"""
State objects are used to represent the state of the search at any given moment.
We choose to implement separate state objects, rather than having an implicit
state embedded within an algorithm instance, in order to make state
interactions cleaner, and not dependent on the exact nature of the algorithm
used.
"""
module state
  using population
  export State, reset!

  """
  Represents the state of an evolutionary algorithm at a given moment in time.
  """
  type State
    population::Population
    iterations::Int
    evaluations::Int

    State() = State(Population())
    State(p::Population) = new(p, 0, 0)
  end

  """
  Resets a given state, setting its iteration and evaluation counters to zero.
  """
  function reset!(s::State)
    s.iterations = s.evaluations = 0
  end
end
