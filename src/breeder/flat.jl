type FlatBreeder <: Breeder
  selection::Selection
  mutation::Mutation
  crossover::Crossover

  FlatBreeder(s::Selection, m::Mutation, c::Crossover) =
    new(s, m, c)
end

type FlatBreederDefinition <: BreederDefinition
  selection::SelectionDefinition
  mutation::MutationDefinition
  crossover::CrossoverDefinition

  FlatBreederDefinition() = new()
  FlatBreederDefinition(s::SelectionDefinition, m::MutationDefinition, c::CrossoverDefinition) =
    new(s, m, c)
end

"""
Composes a flat breeder from its definition.
"""
compose!(d::FlatBreederDefinition, sp::Species) =
  FlatBreeder(compose!(d.selection),
              compose!(d.mutation, sp),
              compose!(d.crossover, sp))

"""
TODO: Document flat breeders.
"""
function flat(f::Function)
  def = FlatBreederDefinition()
  f(def)
  def
end

"""
Performs the breeding process for each of the demes within the population
contained by a given state.
"""
function breed!{F}(b::FlatBreeder, sp::Species, members::IndividualCollection{F}, n::Int)
  n_crossover = num_required(b.crossover, n)
  parents = select(b.selection, sp, members, n_crossover)

  println(parents)
  proto = crossover.operate!(b.crossover, parents, n_crossover)
  mutation.operate!(b.mutation, proto, d.num_offspring)
end
