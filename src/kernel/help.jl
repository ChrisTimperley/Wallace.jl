# Contains various helper functions.
module Help
  export version, help
  import Wallace.Registry
  import Wallace.Registry.Manifest

  # Wallace version number.
  version() = v"0.2.0-alpha"

  help(q::String) =
    contains(q, ":") ? help_property(q) : help_type(q)

  function help_type(q::String)
    if !Registry.exists(q)
      println("No documentation found for the requested type: $q.")
    else
      println(describe(Registry.lookup(q)))
    end
  end

  function help_property(q::String)
    println("Unimplemented feature.")
  end

  function describe(mfst::Manifest)
    desc = ["ID: $(mfst.id)"]
    
    if !isempty(mfst.description)
      push!(desc, "\n$(mfst.description)")
    end

    if !isempty(mfst.properties)
      push!(desc, "\nProperties:")
      for p in mfst.properties
        push!(desc, "- $(p.name)")
      end
    end

    join(desc, "\n")
  end
end
