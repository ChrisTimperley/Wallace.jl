module Composer
  using  Wallace.Parser
  import Base.convert, Wallace.Registry
  export compose, compose_as, composer, compose_with
 
  # Composer register.
  register = Dict{String, Function}()

  # Retrieves a given composer by its alias.
  function composer(alias::String)
    if Registry.exists(alias)
      return Register.lookup(alias).composer
    else
      return register[alias]
    end
  end

  # Registers a composer with a given alias.
  composer(f::Function, alias::String) = register[alias] = f

  # Composes a given specification file into an object.
  function compose(file::String)
    s = parse_file(file)
    return compose_as(s, s["type"])
  end
  function compose_with(refinements::Function, file::String)
    s = parse_file(file)
    apply(refinements, [s])
    return compose_as(s, s["type"])
  end

  # Composes a given specification file into an object, using a predetermined composer.
  compose_as(file::String, as::String) =
    compose_as(parse_file(file), as)
  function compose_as_with(refinements::Function, file::String, as::String)
    s = parse_file(file)
    apply(refinements, [s])
    return compose_as(s, as)
  end

  # Composes a given specification object (in the form of a JSON object)
  # into the object it describes.
  compose_as(s::Dict{Any, Any}, as::String) =
    apply(composer(as), [s])
end
