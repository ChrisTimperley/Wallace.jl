# Contains various helper functions.
module Help
  export version
  import Wallace.Registry

  # Wallace version number.
  version() = v"0.2.0-alpha"

  help(q::String) =
    contains(q, ":") ? help_property(q) : help_type(q)

  function help_type(q::String)
    if !Registry.exists(q)
      println("No documentation found for the requested type: $q.")
    else
      println(description(q))
    end
  end

  function help_property(q::String)
    println("Unimplemented feature.")
  end
end
