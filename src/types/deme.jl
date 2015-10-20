module deme
  export Deme

  type Deme{T}
    capacity::Int
    breeder::Breeder
    species::Species
    num_offspring::Int
    offspring::Vector{T}
    members::Vector{T}

    Deme(capacity::Int, breeder::Breeder, species::Species, num_offspring::Int = capacity) =
      new(capacity, breeder, species, num_offspring, [], [T() for i in 1:capacity])
  end

  # Prepares a deme for the evolutionary process, by allocating the
  # offspring array. This way we operate on the same array for the rest of
  # the process.
  prepare!{T}(d::Deme{T}) = d.offspring = Array(T, d.num_offspring)

  # Produces the offspring for a given deme at each generation.
  breed!(d::Deme) = breed!(d.breeder, d)

  # Returns a list of all the individuals, both current members and offspring,
  # belonging to a given deme.
  contents{I <: Individual}(d::Deme{I}) = vcat(d.offspring, d.members)
end
