type SimplePopulationDefinition <: PopulationDefinition
  size::Int
  offspring::Int
  species::SpeciesDefinition
  breeder::BreederDefinition

  SimplePopulationDefinition() =
    new(80, 0)
  SimplePopulationDefinition(size::Int,
    offspring::Int,
    species::species.SpeciesDefinition,
    breeder::breeder.BreederDefinition
  ) =
    new(size, offspring, species, breeder)
end

"""
Composes a simple population from a provided definition.
"""
function compose!(def::SimplePopulationDefinition)
  dd = deme(def.size, def.offspring, def.species, def.breeder)
  dm = _deme_.compose!(dd)
  Population(Deme[dm]) 
end

"""
Simple populations consist of a single fixed-size deme containing individuals of
the same species.

**Properties:**

* `size::Int`, the number of individuals within the population.
* `offspring::Int`, the number of offspring that should be produced at each
  generation.
* `species::Species`, the species to which all individuals within this
  population belong.
* `breeder::Breeder`, the breeder used to generate the offspring for this
  population at each generation.
"""
function simple(def::Function)
  d = SimplePopulationDefinition()
  def(d)
  d
end
