module criterion
  export  is_satisfied,
          evaluations

  abstract Criterion

  type EvaluationsCriterion <: Criterion
    limit::Int
    EvaluationsCriterion(limit::Int) = new(limit)
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
  Determines whether a given evaluation limit has been hit by a provided
  algorithm state.
  """
  #is_satisfied(c::EvaluationsCriterion, s::State) = s.evaluations >= c.limit
end
