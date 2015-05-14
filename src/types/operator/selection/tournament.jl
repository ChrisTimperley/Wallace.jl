load("../selection", dirname(@__FILE__))

type TournamentSelection <: Selection
  size::Int

  # Could maintain a static buffer?
  TournamentSelection(size::Int) = new(size)
end

# Selects a given number of individuals from a set of candidate individuals
# according to a tournament selection method.
function select{I <: Individual}(s::TournamentSelection, candidates::Vector{I}, n::Int)

  # Pre-allocate an array of winners and an array to hold the participants
  # in each tournament.
  winners = Array(I, n)
  participants = Array(I, s.size)

  for i in 1:n
    for j in 1:s.size
      participants[j] = candidates[rand(1:end)]
    end
    winners[i] = best(participants)
  end
  return winners
  
end

# Selects a number of candidate individuals.
function select!{I <: Individual}(
  selector::TournamentSelection,
  candidates::Vector{I},
  num::Int)
  winners = Array(I, num)
  for i in 1:num
    participants = I[candidates[rand(1:end)] for i in 1:selector.size]
    winners[i] = best(participants)
  end
  return winners
end

register(joinpath(dirname(@__FILE__), "tournament.manifest.yml"))
