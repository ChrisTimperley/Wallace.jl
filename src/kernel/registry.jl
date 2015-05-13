module Registry
  import YAML
  export lookup, register

  # Data structure for recording information about a given author of a
  # particular manifest.
  type ManifestAuthor
    name::ASCIIString
    email::ASCIIString

    ManifestAuthor(mfst::Dict{Any, Any}) =
      new(mfst["name"], get(mfst, "email", ""))
  end

  # Holds the details for a given manifest.
  type Manifest
    id::ASCIIString
    path::ASCIIString
    description::ASCIIString
    authors::Vector{ManifestAuthor}
    tags::Vector{ASCIIString}
    aliases::Vector{ASCIIString}
    imports::Vector{ASCIIString}
    properties::Dict{ASCIIString, Dict{ASCIIString, Any}}
    has_composer::Bool
    composer::Function

    Manifest(id::String, path::String) =
      new(id, path, "", [], [], [], [], Dict{ASCIIString, Dict{ASCIIString, Any}}(), false)
  end

  # Stores the composer for a given manifest.
  function composer(f::Function, m::Manifest)
    m.composer = f
    m.has_composer = true
  end

  # Contents of the manifest registry.
  _contents = Dict{ASCIIString, Manifest}()

  # Searches the contents of the registry for a manifest with a given ID.
  lookup(id::String) = _contents[id]

  # Determines whether a manifest with a given ID exists within the
  # registry.
  exists(id::String) = haskey(_contents, id)

  # Registers a manifest, encoded in a YAML format, with the registry.
  function register(path::String)
  
    # Ensure the given path is an absolute one.
    path = abspath(path) 

    # Load the contents of the YAML file and begin transformation into a
    # Manifest data structure.
    yml = YAML.load_file(path)
    mfst = Manifest(yml["id"], path)

    # Add in each of the optional properties.
    mfst.description = get(yml, "description", "")
    mfst.tags = haskey(yml, "tags") ? ASCIIString[t for t in yml["tags"]] : []
    mfst.aliases = haskey(yml, "aliases") ? ASCIIString[a for a in yml["aliases"]] : []
    mfst.authors = haskey(yml, "authors") ? [ManifestAuthor(a) for a in yml["authors"]] : []
    
    # Convert the path for each import into an absolute one.
    mfst.imports = haskey(yml, "imports") ? ASCIIString[joinpath(path, i) for i in yml["imports"]] : []   

    # Manifest properties.
    if haskey(yml, "properties")
      for (k, v) in yml["properties"]
        mfst.properties[k] = v
      end
    end

    # Composer.
    if haskey(yml, "composer")
      Base.eval(Base.parse("composer(mfst) do s\n$(yml["composer"])\nend"))
    end

    return register(mfst)
  end

  # Registers a given manifest with the registry.
  function register(mfst::Manifest)
    # Ignore all imports, for now.
    #for i in mfst.imports
    #  println("Importing: $i")
    #  require(i)  
    #end
    _contents[mfst.id] = mfst
  end

end
