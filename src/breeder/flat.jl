type FlatBreeder <: Breeder
  selection::Selection
  mutation::Mutation
  crossover::Crossover

  FlatBreeder(s::Selection, m::Mutation, c::Crossover) =
    new(s, m, c)
end

type FlatBreederDefinition <: BreederDefinition
  selection::Selection
  mutation::Mutation
  crossover::Crossover
end

"""
Composes a flat breeder from its definition.
"""
compose!(d::FlatBreederDefinition) =
  FlatBreeder(d.selection, d.mutation, d.crossover)

"""
Performs the breeding process for each of the demes within the population
contained by a given state.
"""
breed!(b::FlatBreeder, s::State) =
  for d in s.population.demes; breed!(b, s, d); end

function breed!(b::FlatBreeder, ::State, d::Deme)
  n_crossover = num_required(b.crossover, d.num_offspring)
  parents = select(b.selection, d.members, n_crossover)
  proto = operate!(b.crossover, parents, n_crossover)
  operate!(b.mutation, proto, d.num_offspring)
end
