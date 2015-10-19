module Composer
  using  Wallace.Parser
  import Base.convert, Wallace.Registry
  export compose, compose_as, composer, compose_with

  # Retrieves a given composer by its alias.
  composer(alias::AbstractString) = Registry.lookup(alias).composer

  # Composes a given specification file into an object.
  function compose(file::AbstractString)
    s = parse_file(file)
    return compose_as(s, s["type"])
  end
  function compose_with(refinements::Function, file::AbstractString)
    s = parse_file(file)
    refinements(s)
    return compose_as(s, s["type"])
  end

  # Composes a given specification file into an object, using a predetermined composer.
  compose_as(file::AbstractString, as::AbstractString) =
    compose_as(parse_file(file), as)

  function compose_as_with(refinements::Function, file::AbstractString, as::AbstractString)
    s = parse_file(file)
    refinements(s)
    return compose_as(s, as)
  end

  # Composes a given specification object (in the form of a JSON object)
  # into the object it describes.
  function compose_as(s::Dict{Any, Any}, as::AbstractString)
    println("composing as: $(as)")
    c = composer(as)
    c(s)
  end
end
