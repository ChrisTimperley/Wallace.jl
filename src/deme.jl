"""
Need to add a deme composer
"""
module deme
using core, breeder, species
export Deme, prepare!, breed!, contents, deme, compose!, DemeSpecification

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

"""
Used to provide a specification for building a deme.
"""
type DemeSpecification
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
  species::Species

  """
  The breeder used to produce the offspring for this deme.
  """
  breeder::Breeder

  DemeSpecification() = new(100, -1)
end

"""
Composes a deme from a provided specification.
"""
function compose!(d::DemeSpecification)
  species = compose!(d.species)
  breeder = compose!(d.breeder, species)
  ind_type = ind_type(species)
  d.offspring == 0 && d.offspring = d.capacity
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
function deme(spec::Function)
  ds = DemeSpecification()
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

# Produces a requested number of (proto-)offspring from a multiple breeding source.
function breed!{I <: Individual}(
  sp::Species,
  s::MultiBreederSource,
  inds::Vector{I},
  n::Int,
  caller::Union{FastBreeder, BreederSource}
)
  proportions = proportion(n, s.proportions)
  vcat([breed!(s.sources[i], d, proportions[i], caller) for i in 1:length(s.sources)])
end

# Produces a requested number of individuals for breeding using a given selection source.
# Each selected individual is cloned to avoid changes to the original population.
function breed!(
  sp::Species,
  s::SelectionBreederSource,
  d::Deme,
  n::Int,
  caller::Union{FastBreeder, BreederSource}
)# =
#  sync(s.eigen, caller.eigen, sp, map!(clone, select(s.operator, d.members, n)))
  inds = select(s.operator, d.species, d.members, n)
  map!(clone, inds)
  sync(s.eigen, caller.eigen, sp, inds)
end

function breed!{I <: Individual}(
  sp::Species,
  s::VariationBreederSource,
  d::Deme{I},
  n::Int64,
  caller::Union{FastBreeder, BreederSource}
)
  # Full-time cache?

  # Cache the number of inputs and outputs to this operator.
  op_inputs = num_inputs(s.operator)
  op_outputs = num_outputs(s.operator)

  # Cache.
  buffer_individuals = Array(I, op_inputs)

  # Calculate the number of calls to the operator that are necessary to
  # produce the desired number of individuals.
  calls = ceil(Integer, n / op_outputs)

  # Generate the necessary input proto-offspring.
  inputs = breed!(sp, s.source, d, calls * op_outputs, s)

  # Now we need to synchronise the representation graph of our proto-offspring, such
  # that the stage that this operator works on is marked as clean.
  
  # If we're calling another variator directly, then we simply need to call a
  # lambda function, "prepare", which is applied to a homogeneous array of individuals.

  # But if our individuals come from a multi-source, we need to prepare each source
  # in a different way.

  # Produce the offspring.
  outputs = Array(I, calls * op_outputs)
  outputs_to = 0
  for c in 1:calls
    inputs_to = op_inputs * c
    inputs_from = inputs_to - op_inputs + 1

    outputs_to = op_outputs * c
    outputs_from = outputs_to - op_outputs + 1

    # Lots of room for optimisation.
    buffer_individuals = inputs[inputs_from:inputs_to]
    
    call!(s.operator, s.stage_getter, buffer_individuals)
    #operate!(s.operator, map(s.stage, buffer_individuals))

    outputs[outputs_from:outputs_to] = buffer_individuals
  end

  # Limit the number of produced offspring to the number desired.
  # (Is it faster to limit, or to not produce more than you need?)
  return sync(s.eigen, caller.eigen, sp, outputs[1:n])
end

"""
Returns a list of all the individuals, both current members and offspring,
belonging to a given deme.
"""
contents{I <: Individual}(d::Deme{I}) = vcat(d.offspring, d.members)
end
