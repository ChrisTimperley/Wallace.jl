"""
The base type used by all terminals within a Koza tree.
"""
abstract KozaTerminal <: KozaNode

function compose_terminal(inputs::Vector{KozaInput}, def::AbstractString)
  label = def[1:Base.search(def, ':')-1]
  ty = def[Base.last(Base.search(def, "::"))+1:end]
  
  # Compose the unique type for this non-terminal.
  src = "type <: KozaTerminal
    parent::KozaParent
    constructor() = new()
    constructor(p::KozaParent) = new(p)
  end"
  t = anonymous_type(koza, src)

  # Compose the label function.
  eval(koza, Base.parse("label(::$(t)) = $(label)"))

  # Compose the "fresh" function.
  eval(koza, Base.parse("fresh(::$(t), p::KozaParent) = $(t)(p)"))

  # Compose the execution function.
  src = join(vcat(["::$(t)"], ["$(i.label)::$(i.ty)" for i in inputs]), ",")
  src = "execute($(src)) = $(label)"
  eval(koza, Base.parse(src))
  return t
end

"""
Produces a clone of a provided terminal node from a Koza tree.
"""
clone{T <: KozaTerminal}(n::T, p::KozaParent) = T(p)
isterminal(::KozaTerminal) = true
num_nodes(n::KozaTerminal) = 1
height(n::KozaTerminal) = 1
describe(n::KozaTerminal) = label(n)
