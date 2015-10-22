"""
TODO: Description of _deme_ module.
"""
module _deme_
using core, breeder, species
export Deme, prepare!, breed!, contents, deme, DemeDefinition

type Deme{T}
  capacity::Int
  breeder::Breeder
  species::Species
  num_offspring::Int
  offspring::Vector{T}
  members::Vector{T}

  Deme(capacity::Int, breeder::Breeder, species::Species, num_offspring::Int) =
    new(capacity, breeder, species, num_offspring, [], [T() for i in 1:capacity])
end

"""
Used to provide a definition for building a deme.
"""
type DemeDefinition
  """
  The number of individuals within this deme.
  """
  capacity::Int

  """
  The number of offspring produced by this deme at each generation.
  If set to `0`, the number of offspring will default to being equal to
  the capacity of the deme.
  """
  offspring::Int

  """
  The species to which all members of this deme belong.
  """
  species::species.SpeciesDefinition

  """
  The breeder used to produce the offspring for this deme.
  """
  breeder::breeder.BreederDefinition

  """
  Constructs a partial deme specification using default values.
  """
  DemeSpecification() = new(100, -1)
  DemeSpecification(capacity::Int,
    offspring::Int,
    species::species.SpeciesDefinition,
    breeder::breeder.BreederDefinition
  ) =
    new(capacity, offspring, species, breeder)
end

"""
Composes a deme from a provided specification.
"""
function compose!(d::DemeDefinition)
  species = compose!(d.species)
  breeder = compose!(d.breeder, species)
  ind_type = ind_type(species)
  if d.offspring == 0
    d.offspring = d.capacity
  end
  Deme{ind_type}(d.capacity, breeder, species, d.offspring)
end

"""
TODO: Description of deme models.

**Properties:**

* `capacity::Int`, the number of individuals that this deme may hold.
* `offspring::Int`, the number of offspring that should be produced by this
deme at every generation.
* `species::SpeciesSpecification`, the species to which the individuals in the
deme belong.
* `breeder::BreederSpecification`, the breeder used to produce the offspring
for this deme.
"""
deme( capacity::Int,
      offspring::Int,
      species::species.SpeciesDefinition,
      breeder::breeder.BreederDefinition) =
  DemeDefinition(capacity, offspring, species, breeder)

function deme(spec::Function)
  ds = DemeDefinition()
  spec(ds)
  ds
end

"""
Prepares a deme for the evolutionary process, by allocating the
offspring array. This way we operate on the same array for the rest of
the process.
"""
prepare!{T}(d::Deme{T}) = d.offspring = Array(T, d.num_offspring)

"""
Produces the offspring for a given deme at each generation.
"""
breed!(d::Deme) =
  d.offspring = breed!(d.breeder, d.species, d.members, d.capacity, d.num_offspring)

"""
Returns a list of all the individuals, both current members and offspring,
belonging to a given deme.
"""
contents{I <: Individual}(d::Deme{I}) = vcat(d.offspring, d.members)
end
