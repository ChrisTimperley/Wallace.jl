"""
Need to add a deme composer
"""
module deme
  using core, breeder, species
  export Deme, prepare!, breed!, contents, deme

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

  # TODO: Needs lots of work!
  function deme(s::Dict{Any, Any})
    println("- building deme.")
    s["species"] = Dict{Any, Any}(s["species"])
    s["breeder"] = Dict{Any, Any}(s["breeder"])

    println("- about to compose species: $(typeof(s["species"]))")
    s["species"] = compose_as(s["species"], Base.get(s["species"], "type", "species"))
    s["breeder"]["species"] = s["species"]

    println("-- building breeder.")
    s["breeder"] = compose_as(s["breeder"], s["breeder"]["type"])
    s["capacity"] = Base.get(s, "capacity", 100)
    s["offspring"] = Base.get(s, "offspring", s["capacity"])

    Deme{ind_type(s["species"])}(s["capacity"], s["breeder"], s["species"], s["offspring"])
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
