"""
Defines common methods whose implementation belongs to a number of different
packages.
"""
module common
  export compose!

  """
  Should compose an object from its provided definition.
  """
  compose!(x::Any) = x

  """
  Should return the representation used by some given object.
  """
  rep(::Any) = error("Common stub method.")
end
