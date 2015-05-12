load("node", dirname(@__FILE__))
load("input", dirname(@__FILE__))

type KozaNonTerminalArgument
  label::String
  ty::String
  KozaNonTerminalArgument(def::String) = new(def[1:Base.search(def, ':')-1],
    def[Base.last(Base.search(def, "::"))+1:end])
end

abstract KozaNonTerminal <: KozaNode
function ComposeKozaNonTerminal(inputs::Vector{KozaInput}, def::String)
  label = def[1:Base.search(def, '(')-1]
  returns = Base.strip(def[last(Base.search(def, ")::"))+1:Base.search(def, '=')-1])
  body = Base.strip(def[Base.search(def, '=')+1:end])
  accepts = [KozaNonTerminalArgument(Base.strip(ss))
    for ss in Base.split(def[Base.search(def, '(')+1:Base.search(def, ')')-1], ',')]

  # Compose the unique type for this non-terminal.
  src = "type <: KozaNonTerminal
    parent::KozaParent
    children::Vector{KozaNode}

    constructor() = new()
    constructor(p::KozaParent) =
      new(p, Array(KozaNode, $(length(accepts))))
    constructor($(
      join([["p::KozaParent"], ["c$(i)::KozaNode" for i in 1:length(inputs)]], ",")
    )) =
      new($(
      join([["p"], ["c$(i)" for i in 1:length(inputs)]], ",")
    ))
  end"
  t = anonymous_type(Wallace, src)

  # Compose the "fresh" function.
  eval(Wallace, Base.parse("fresh(::$(t), p::KozaParent) = $(t)(p)"))

  # Compose the label function.
  eval(Wallace, Base.parse("label(::$(t)) = $(label)"))

  # Compose the arity function.
  eval(Wallace, Base.parse("arity(::$(t)) = $(length(accepts))"))

  # Compose the execution function.
  input_list = [i.label for i in inputs]
  src = join([["n::$(t)"], ["$(i.label)::$(i.ty)" for i in inputs]], ",")
  src = "function execute($(src))\n"

  # Find each argument in the function body and replace with an execution call.
  for (i, a) in enumerate(accepts)
    body = replace(body, Regex("\\b$(a.label)\\b"),
      "execute($(join([["n.children[$(i)]"], input_list], ", ")))")
  end
  src = src * body * "\nend"
  eval(Wallace, Base.parse(src))

  # Compose the clone function.
  src = "clone(n::$(t), p::KozaParent) = $(t)($(
    join([["p"], ["clone(n.children[$(i)], n)" for i in 1:length(inputs)]], ",")
  ))"
  eval(Wallace, Base.parse(src))

  return t
end

isterminal(::KozaNonTerminal) = false
execute(::KozaNonTerminal) = error("No execution method for this non-terminal.")
arity(::KozaNonTerminal) = error("No arity method for this non-terminal.")
#num_nodes(n::KozaNonTerminal) = 1 + sum(Int[num_nodes(c) for c in n.children])
#height(n::KozaNonTerminal) = 1 + maximum(Int[height(c) for c in n.children])
describe(n::KozaNonTerminal) = "$(label(n))($(join([describe(n) for c in n.children], ",")))"

function num_nodes(n::KozaNonTerminal)
  i = 0
  for c in n.children
    i += num_nodes(c)
  end
  return i + 1
end

function height(n::KozaNonTerminal)
  i = 0
  for c in n.children
    i = max(i, height(c))
  end
  return i + 1
end
