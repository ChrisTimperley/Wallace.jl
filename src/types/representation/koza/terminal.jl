load("input", dirname(@__FILE__))
load("node", dirname(@__FILE__))

abstract KozaTerminal <: KozaNode
function ComposeKozaTerminal(inputs::Vector{KozaInput}, def::String)
  label = def[1:Base.search(def, ':')-1]
  ty = def[Base.last(Base.search(def, "::"))+1:end]
  
  # Compose the unique type for this non-terminal.
  src = "type <: KozaTerminal
    parent::KozaParent
    constructor() = new()
    constructor(p::KozaParent) = new(p)
  end"
  t = anonymous_type(Wallace, src)

  # Compose the label function.
  eval(Wallace, Base.parse("label(::$(t)) = $(label)"))

  # Compose the "fresh" function.
  eval(Wallace, Base.parse("fresh(::$(t), p::KozaParent) = $(t)(p)"))

  # Compose the execution function.
  src = join([["::$(t)"], ["$(i.label)::$(i.ty)" for i in inputs]], ",")
  src = "execute($(src)) = $(label)"
  eval(Wallace, Base.parse(src))

  return t
end

clone{T <: KozaTerminal}(n::T, p::KozaParent) = T(p) 
isterminal(::KozaTerminal) = true
num_nodes(n::KozaTerminal) = 1
height(n::KozaTerminal) = 1
describe(n::KozaTerminal) = label(n)
