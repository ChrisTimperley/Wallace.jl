type RandomSelection <: Selection; end

"""
Random selection operates by selecting individuals at random with
replacement.
"""
random() = RandomSelection()

select{I <: Individual}(::RandomSelection,
  ::Species,
  candidates::Vector{I},
  n::Int
) =
  I[candidates[rand(1:end)] for i in 1:num]
