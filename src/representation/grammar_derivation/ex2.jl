"""
Two ways of implementing options:

<something, ?> OR ?[<something> and <something else>]

The latter is more powerful, but a bit trickier to parse.
For now we'll go with the former, since you can express a more complex optional
section as a separate rule.
"""

"""
Defines the RegEx pattern used to embed grammar rules within one another.
"""
const rule_regex = r"<[\w_]+(,\s*[\?|\+|\*])?>"

#grammar(max_wraps = 2) do g
#  # Should retreive <val> from grammar, rather than fetching rule each time
#  # it's called.
#  rule(g, "exp", "(<exp>)", "<val>", "<op>")
#  rule(g, "op", "<exp> * <exp>", "<exp> - <exp>", "<exp> + <exp>")
#  rule(g, "val", "x", "y", "<num>")
#  rule(g, "num", "<digit, +>") # this one is the trickiest to deal with.
#end

"""
The base type for all grammar rules.
"""
abstract Rule

type Grammar
  rules::Dict{AbstractString, Rule}
  # caching the root rule might reduce the number of look-ups.

  Grammar() = new(Dict{AbstractString, Rule}())
end

"""
Parses a single option for a grammar rule and returns a Rule object encoding
that rule.
"""
rule(g::Grammar, r::AbstractString) =
  search(r, rule_regex) != 0:-1 ? NonTerminalRule(r) : TerminalRule(parse(r))

"""
Creates a modified version of a given grammar rule, according to some provided
modifier string. This function is used to implement EBNF constructs, such as
ONE-OR-MORE, ZERO-OR-MORE and OPTIONAL.
"""
function rule(r::Rule, modifier::AbstractString)
  if      modifier == "+"
    OneOrMoreRule(r)
  elseif  modifier == "*"
    ZeroOrMoreRule(r)
  elseif  modifier == "?"
    OptionalRule(r)
  else
    error("Unrecognised rule modifier: $(modifier).")
  end
end

"""
Creates a single grammar rule from a provided rule definition string.
"""
rule(g::Grammar, name::AbstractString, def::String) =
  g.rules[name] = rule(g, def)

"""
Creates a named OR rule for a given grammar, using a list of possible options,
each given by a rule definition string.
"""
rule(g::Grammar, name::AbstractString, defs...) =
  g.rules[name] = OptionRule(Rule[rule(g, def) for def in defs])

"""
An OR rule allows a given grammar rule to be interpreted in a number of
different ways.
"""
immutable OrRule <: Rule
  num_options::Int
  options::Vector{Rule}

  OrRule(options::Vector{Rule}) = new(length(options), options)
end

"""
The ONE-OR-MORE rule (<x, +>) allows a grammar rule to be applied more than
once and at least once.
"""
immutable OneOrMoreRule <: Rule
  rule::Rule
end

"""
The ZERO-OR-MORE rule (<x, *>) allows a grammar rule to be applied
an arbitrary number of times, or not applied at all.
"""
immutable ZeroOrMoreRule <: Rule
  rule::Rule
end

"""
The OPTIONAL rule (<x, ?>) allows a grammar rule to be optionally applied at
most once.
"""
immutable OptionalRule <: Rule
  rule::Rule
end

"""
Due to Julia's current implementation of anonymous functions, this type isn't
quite as efficient as it could be.
"""
immutable NonTerminalRule <: Rule
  non_terminals::Vector{Rule}
  builder::Function # (Grammar, NonTerminalRule, Task) -> Expr

  NonTerminalRule(nts::Vector{Rule}, builder::Function) = new(nts, builder)
end

immutable TerminalRule <: Rule
  value

  TerminalRule(val) = new(val)
end

"""
Selects an interpretation of a given OR rule according to an index provided by
a given codon sequence.
"""
derive(g::Grammar, r::OrRule, nxt::Task) =
  derive(g, g.options[(consume(nxt) % num_options) + 1], nxt)

derive(g::Grammar, r::TerminalRule, nxt::Task) =
  r.value

derive(g::Grammar, r::NonTerminalRule, nxt::Task) =
  r.builder(g, nxt)

derive(g::Grammar, nxt::Task) =
  derive(g, g.rules["root"], nxt)

"""
Derives a Julia expression (in the form of an Expr) using a provided sequence
of codons, a maximum number of wrappings, and a given grammar.
"""
function derive(g::Grammar, r::Rule, nxt::Task)
  i1 = derive(g, g.rules[:num], nxt)
  i2 = derive(g, g.rules[:num], nxt)
  Expr(:call, :add, i1, i2)
end

function parse_non_terminal_rule(g::Grammar, r::AbstractString)

  # Create an array to hold the non-terminal symbols within the given rule,
  # and another to hold their associated (possibly modified) rules.
  tags = AbstractString[]
  nts = Rule[]

  # Replace each grammar symbol in the given string with an associated
  # placeholder tag.
  function replacer(tag::AbstractString)
    push!(tags, string(tag))
    "__WALLACE_GRAMMAR_TAG_$(length(tags))__"
  end
  r = replace(r, rule_regex, replacer)

  # Now parse the rule definition to a Julia expression and then back into
  # Julia code (in the form a string).
  r = expr_to_def_s(Base.parse(r))

  # Replace each placeholder with a call to the appropriate function, and
  # build the list of rules used by the symbols within this non-terminal.
  for (i, tag) in enumerate(tags)
    parts = split(tag[2 : (length(tag) - 1)], r",\s+")
    tag_rule_name, modifier = parts[1], Base.get(parts, 2, "")
    tag_rule = g.rules[tag_rule]

    # Apply any modifiers to the rule for this symbol.
    tag_rule = modifier == "" ? tag_rule : rule(tag_rule, modifier)

    push!(nts, tag_rule)

    # Replace the placeholder for this symbol within the Expr object with a
    # call to derive, along with the appropriate rule.
    r = replace(r, ":__WALLACE_GRAMMAR_TAG_$(i)__", "derive(g, r.non_terminals[$(i)], nxt)")
  end

  # Construct the lambda function for this non-terminal.
  r = "(g::Grammar, r::NonTerminalRule, nxt::Task)::Expr -> $(r)"
  builder = eval(r)

end

"""
Converts a given Expr into a string containing Julia code capable of
reproducing that Expr.
"""
expr_to_def_s(ex::Expr) =
  "Expr($(join(vcat([":$(ex.head)"], map(expr_to_def_s, ex.args)), ", ")))"
expr_to_def_s(sym::Symbol) = ":$(sym)"
expr_to_def_s(a::Any) = string(a)

"""
TESTING!
"""
example = "add(<num>, <num>)"

g = Grammar()
g.rules["num"] = TerminalRule("blah")

parse_non_terminal_rule(g, example)
