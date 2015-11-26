abstract GrammarToken

type GrammarLiteral <: GrammarToken
  value::AbstractString
end
type GrammarSymbol <: GrammarToken
  value::AbstractString
end

type Grammar
  root::AbstractString
  rules::Dict{AbstractString, Vector{Vector{GrammarToken}}}

  function Grammar(root::AbstractString, rules::Dict{AbstractString, Vector{AbstractString}})
    p_rules = Dict{AbstractString, Vector{Vector{GrammarToken}}}()
    for (sym, entries) in rules
      p_rules[sym] = [parse_rule_entry(entry) for entry in  entries]
    end
    new(root, p_rules)
  end
end

function derive(g::Grammar, s::Vector{Int}, max_wraps::Int)
  derivation = ""

  q = GrammarToken[GrammarSymbol(g.root)]
  i = 1
  len = length(s)
  wraps = 0

  while !isempty(q)
    token = shift!(q)

    if isa(token, GrammarLiteral)
      derivation = derivation * token.value
    else
      options = g.rules[token.value]
      if length(options) == 1
        prepend!(q, options[1])
      else
        if i >= len
          if wraps == max_wraps
            error("Genotype exhausted")
          end
          i = 1
          wraps += 1
        end
        prepend!(q, options[(s[i] % length(options)) + 1])
        i += 1
      end
    end
  end
  return derivation
end

function parse_rule_entry(entry::AbstractString)
  tokens = GrammarToken[]
  while !isempty(entry)
    left, tag, entry = partition(entry, r"<[^\<\>]+>")
    
    if !isempty(left)
      push!(tokens, GrammarLiteral(left))
    end
    if !isempty(tag)
      push!(tokens, GrammarSymbol(tag[2:end-1]))
    end
  end
  return tokens
end
