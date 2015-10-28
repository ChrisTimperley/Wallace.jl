import Base
export IndividualStage, copy, describe, valid

"""
Used to contain the data for a stage of development for a given individual.

TODO:
- Explain more about individual stages.
"""
type IndividualStage{T}
  valid::Bool
  value::T

  """
  Constructs a new empty stage of development.
  """
  IndividualStage() = new(false)

  """
  Constructs a non-empty stage of development.
  """
  IndividualStage(v::T) = new(true, v)
end

"""
Produces a copy of a given stage of development.
"""
copy(s::IndividualStage) = if s.valid
  IndividualStage(s.value)
else
  IndividualStage()
end

"""
Returns a string description of a given stage of development.
"""
describe(s::IndividualStage) = if s.valid
  describe(s.value)
else
  "INVALID"
end

"""
Returns true if a given stage of development is valid.
"""
valid(s::IndividualStage) = s.valid

"""
Returns the value of a given stage of development.
"""
get{T}(s::IndividualStage{T}) = s.value

"""
Sets the value of a given stage of development, and marks it as valid.
"""
set{T}(s::IndividualStage{T}, v::T) = begin
  s.valid = true
  s.value = v
end
