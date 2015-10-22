"""
Used to specify the properties of simple breeders.
"""
type SimpleBreederDefinition <: BreederDefinition

  """
  The selection operator to be used by this breeder.
  """
  selection::SelectionDefinition

  """
  The mutation operator to be used by this breeder.
  """
  mutation::MutationDefinition

  """
  The crossover operator to be used by this breeder.
  """
  crossover::CrossoverDefinition

  SimpleBreederDefinition() = new()
end

"""
Composes a simple breeder for a given species from a provided definition.
"""
compose!(def::SimpleBreederDefinition, s::Species) =
  compose!(linear([def.selection, def.mutation, def.crossover]), s)

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
