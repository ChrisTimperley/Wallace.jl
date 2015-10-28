"""
The `criterion` module is used to implement various termination (or restart
criteria), such as the number of generations or evaluation passed, or the
amount of an resource consumed, in a flexible manner.
"""
module criterion
  using   state
  export  is_satisfied,
          Criterion,
          EvaluationsCriterion,
          IterationsCriterion

  abstract Criterion

  """
  Limits the number of evaluations an algorithm may perform.
  """
  type EvaluationsCriterion <: Criterion
    limit::Int
    EvaluationsCriterion(limit::Int) = new(limit)
  end

  """
  Limits the number of iterations, or generations, an algorithm may run for.
  """
  type IterationsCriterion <: Criterion
    limit::Int
    IterationsCriterion(limit::Int) = new(limit)
  end

  """
  Limits the algorithm to a fixed number of evaluations. Treated as a hard
  limit, i.e. algorithms should be guaranteed not to exceed this limit, even if
  there are several candidates pending evaluation in the current generation.

  **Parameters:**\n
  `limit::Int`, the evaluation limit.
  """
  evaluations(limit::Int) = EvaluationsCriterion(limit)

  """
  Limits the number of iterations that an algorithm may run for.

  **Parameters:**\n
  `limit::Int`, the iteration limit.
  """
  iterations(limit::Int) = IterationsCriterion(limit)

  """
  Limits the number of generations that an algorithm may run for.

  **Parameters:**\n
  `limit::Int`, the maximum number of generations.
  """
  generations = iterations

  """
  Determines whether a given evaluation limit has been hit by a provided
  algorithm state.
  """
  is_satisfied(c::EvaluationsCriterion, s::State) = s.evaluations >= c.limit

  """
  Determines whether a given iteration limit has been reached by a provided
  algorithm state.
  """
  is_satisfied(c::IterationsCriterion, s::State) = s.iterations >= c.limit
end
