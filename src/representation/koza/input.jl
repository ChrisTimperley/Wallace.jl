"""
Represents an input to a program implemented by a Koza tree.
"""
type KozaInput
  """
  The label, or name of this input.
  """
  label::AbstractString

  """
  The (name of the) type used by this argument.
  """
  ty::AbstractString

  KozaInput(def::AbstractString) = new(def[1:Base.search(def, ':')-1],
    def[Base.last(Base.search(def, "::"))+1:end])
end

"""
Compiles an ordered list of koza inputs into a partial function header
signature.
"""
compile(il::Vector{KozaInput}) =
  join(["$(i.label)::$(i.ty)" for i in il], ",")
