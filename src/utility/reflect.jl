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
  function anonymous_module(d::AbstractString)
    name = fresh_mod()
    d = "module $(name)\n$(d)\nend"
    eval(Base.parse(d))
    return eval(Base.parse(name))
  end

  # Generates an anonymous type from a provided definition.
  function anonymous_type(m::Module, d::AbstractString)
    # Insert the name of the type after the first modifier.
    name = fresh()
    d = replace(d, r"(?<=\w)\b", " $(name)", 1)

    # Format the constructors using the name of the type.
    d = replace(d, r"constructor(?=\()", name)

    eval(m, Base.parse(d))
    return eval(m, Base.parse(name))
  end
end
