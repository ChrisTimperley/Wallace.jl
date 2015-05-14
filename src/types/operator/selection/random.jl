load("../selection", dirname(@__FILE__))

type RandomSelection <: Selection; end

# Selects a given number of individuals from a set of candidate individuals
# according to a random selection method.
select{I <: Individual}(s::RandomSelection, candidates::Vector{I}, n::Int64) =
  Individual[candidates[rand(1:end)] for i in 1:num]

# Selects a number of candidate individuals.
function select!(
  selector::RandomSelection,
  candidates::Array{Individual, 1},
  num::Int64)
  Individual[candidates[rand(1:end)] for i in 1:num]
end

register(joinpath(dirname(@__FILE__), "random.manifest.yml"))
