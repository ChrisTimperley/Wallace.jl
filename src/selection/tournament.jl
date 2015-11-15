type TournamentSelectionDefinition <: SelectionDefinition
  size::Int

  TournamentSelectionDefinition(size::Int) = new(size)
end

type TournamentSelection <: Selection
  size::Int
  TournamentSelection(size::Int) = new(size)
end

compose!(def::TournamentSelectionDefinition) =
  TournamentSelection(def.size)

"""
TODO: Description of tournament selection.

**Parameters:**
* `size::Int`, the number of each individuals in each tournament. Defaults to
`7`, if no value is provided.
"""
tournament() = tournament(7)
tournament(size::Int) = TournamentSelectionDefinition(size)

"""
Selects a given number of individuals from a set of candidate individuals
according to a tournament selection method.
"""
function select{F}(s::TournamentSelection,
  sp::Species,
  candidates::Vector{Tuple{Int, F}},
  n::Int
)
  # Pre-allocate an array of winners and an array to hold the participants
  # in each tournament.
  winners = Array(I, n)
  participants = Array(I, s.size)
  for i in 1:n
    for j in 1:s.size
      participants[j] = candidates[rand(1:end)]
    end
    winners[i] = best(sp.fitness, participants)
  end
  return winners
end
