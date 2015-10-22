"""
Used to specify the properties of simple breeders.
"""
type SimpleBreederDefinition

  """
  The selection operator to be used by this breeder.
  """
  selection::Selection

  """
  The mutation operator to be used by this breeder.
  """
  mutation::Mutation

  """
  The crossover operator to be used by this breeder.
  """
  crossover::Crossover

  SimpleBreederDefinition() = new()
end

"""
Composes a simple breeder for a given species from a provided definition.
"""
function compose!(def::SimpleBreederDefinition, s::Species)
  compose!(linear([b.selection, b.mutation, b.crossover]), s)
  b
end

"""
Simple breeders operator are composed of a selection operation, followed by a
crossover operation, and then a mutation operation. For most simple problems,
this breeder will suffice.

**Parameters:**

* `selection::Selection`, the selection operator to be used by this breeder.
* `mutation::Mutation`, the mutation operator to be used by this breeder.
* `crossover::Crossover`, the crossover operator to be used by this breeder.
"""
function simple(f::Function)
  b = SimpleBreederDefinition()
  f(b)
  b
end
