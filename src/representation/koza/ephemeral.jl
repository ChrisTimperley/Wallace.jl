"""
The base type used by all ephemeral random constants.
"""
abstract ERC

"""
Used to represent numerical ephemeral random constants.
"""
type NumericERC{N} <: ERC
  """
  The minimum value that the constant may take.
  """
  min::N
  
  """
  The maximum value that the constant may take.
  """
  max::N
end

"""
TODO ==========================================================================
This isn't right...
ERCs should be compiled and not called.
"""
call{N}(erc::NumericERC{N}) =
  rand(erc.min, erc.max)
