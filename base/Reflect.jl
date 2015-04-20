module Reflect

  export anonymous_type, anonymous_module, define_function

  # Stores the ID of the next anonymous type.
  global __counter = zero(Int)
  global __counter_mod = zero(Int)

  # Generates and returns the name of the next anonymous type.
  fresh() = "Anon$(global __counter += 1)"
  fresh_mod() = "AnonMod$(global __counter_mod += 1)"

  # Generates an empty anonymous type.
  anonymous_type(m::Module) = anonymous_type(m, "type;end")

  # Generates an anonymous module from a provided definition.
  function anonymous_module(d::String)
    name = fresh_mod()
    d = "module $(name)\n$(d)\nend"
    eval(parse(d))
    return eval(parse(name))
  end

  # Generates an anonymous type from a provided definition.
  function anonymous_type(m::Module, d::String)
    # Insert the name of the type after the first modifier.
    name = fresh()
    d = replace(d, r"(?<=\w)\b", " $(name)", 1)

    # Format the constructors using the name of the type.
    d = replace(d, r"constructor(?=\()", name)

    eval(m, parse(d))
    return eval(m, parse(name))
  end

  define_inline_function(m::Module, n::ASCIIString, args::Vector{ASCIIString}, body::ASCIIString) =
    eval(m, parse("$(n)($(join(args, ",")) = $(body)"))

  # Never generates one-line functions (FOR NOW).
  # Won't work with less specific "String" type?
  define_function(m::Module, n::ASCIIString, args::Vector{ASCIIString}, body::ASCIIString) =
    eval(m, parse("function $(n)($(join(args, ",")));$(body);end"))

end
