"""
Defines common methods whose implementation belongs to a number of different
packages.

Should aim to reduce the number of methods in this package.
"""
module common
  importall Base
  export  compose!, rep, prepare, prepare!, get, set, scale!, breed!,
          compare, execute

  compare(::Any) = error("Common stub method: compare")

  execute(::Any) = error("Common stub method: execute")

  """
  Stub method for scale! functions.
  """
  scale!(::Any) = error("Common stub method: scale!")

  """
  Stub method for prepare functions.
  """
  prepare(::Any) = error("Common stub method: prepare")

  """
  Stub method for prepare! functions.
  """
  prepare!(::Any) = error("Common stub method: prepare!")

  """
  Stub method for breed! functions.
  """
  breed!(::Any) = error("Common stub method: breed!")

  """
  Should compose an object from its provided definition.
  """
  compose!(x::Any) = x

  """
  Should return the representation used by some given object.
  """
  rep(::Any) = error("Common stub method: rep")

  get(::Any) = error("Common stub method: get")

  set(::Any) = error("Common stub method: set")
end
