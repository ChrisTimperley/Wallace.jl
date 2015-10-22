type RandomSelectionDefinition <: SelectionDefinition; end
type RandomSelection <: Selection; end

compose!(d::RandomSelectionDefinition) = RandomSelection()

"""
Random selection operates by selecting individuals at random with
replacement.
"""
random() = RandomSelectionDefinition()

select{I <: Individual}(::RandomSelection,
  ::Species,
  candidates::Vector{I},
  n::Int
) =
  I[candidates[rand(1:end)] for i in 1:num]
