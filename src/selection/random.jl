type RandomSelectionDefinition <: SelectionDefinition; end
type RandomSelection <: Selection; end

"""
Composes a random selection operator from its definition.
"""
compose!(d::RandomSelectionDefinition) = RandomSelection()

"""
Random selection operates by selecting individuals at random with
replacement.
"""
random() = RandomSelectionDefinition()

select_ids(::RandomSelection, ::Species, ic::IndividualCollection, n::Int) =
  rand(1:length(ic.fitnesses), n)
