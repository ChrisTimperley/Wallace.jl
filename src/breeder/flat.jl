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
end

"""
Composes a flat breeder from its definition.
"""
compose!(d::FlatBreederDefinition, sp::Species) =
  FlatBreeder(compose!(d.selection, sp),
              compose!(d.mutation, sp),
              compose!(d.crossover, sp))

"""
Performs the breeding process for each of the demes within the population
contained by a given state.
"""
function breed!{F}(b::FlatBreeder, members::IndividualCollection{F})
  n_crossover = num_required(b.crossover, d.num_offspring)
  parents = select(b.selection, d.members, n_crossover)
  proto = operate!(b.crossover, parents, n_crossover)
  operate!(b.mutation, proto, d.num_offspring)
end
