load("individual",  dirname(@__FILE__))
load("species",     dirname(@__FILE__))
load("breeder",     dirname(@__FILE__))

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

register("deme", Deme)
composer("deme") do s
  s["species"] = compose_as(s["species"], "species")
  s["breeder"]["species"] = s["species"]
  s["breeder"] = compose(s["breeder"], s["breeder"]["type"])
  s["capacity"] = Base.get(s, "capacity", 100)
  s["offspring"] = Base.get(s, "offspring", s["capacity"])

  Deme{ind_type(s["species"])}(s["capacity"], s["breeder"], s["species"], s["offspring"])
end
