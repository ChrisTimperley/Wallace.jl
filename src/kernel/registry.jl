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
    description::ASCIIString
    authors::Vector{ManifestAuthor}
    tags::Vector{ASCIIString}
    aliases::Vector{ASCIIString}
    imports::Vector{ASCIIString}
    properties::Dict{ASCIIString, Dict{ASCIIString, Any}}

    Manifest(id::String) =
      new(id, "", [], [], [], [], Dict{ASCIIString, Dict{ASCIIString, Any}}())
  end

  # Contents of the manifest registry.
  _contents = Dict{ASCIIString, Manifest}()

  # Searches the contents of the registry for a manifest with a given ID.
  lookup(id::String) = _contents[id]

  # Registers a manifest, encoded in a YAML format, with the registry.
  function register(path::String)
    yml = YAML.load_file(path)
    mfst = Manifest(yml["id"])

    # Add in each of the optional properties.
    mfst.description = get(yml, "description", "")
    mfst.tags = haskey(yml, "tags") ? ASCIIString[t for t in yml["tags"]] : []
    mfst.aliases = haskey(yml, "aliases") ? ASCIIString[a for a in yml["aliases"]] : []
    mfst.authors = haskey(yml, "authors") ? [ManifestAuthor(a) for a in yml["authors"]] : []
    mfst.imports = haskey(yml, "imports") ? ASCIIString[i for i in yml["imports"]] : []   

    # Manifest properties.
    if haskey(yml, "properties")
      for (k, v) in yml["properties"]
        mfst.properties[k] = v
      end
    end

    return register(mfst)
  end

  # Registers a given manifest with the registry.
  register(mfst::Manifest) = _contents[mfst.id] = mfst

end

using Registry
m = register("../types/operator/mutation/bit_flip/bit_flip.manifest.yml")
println(m)
