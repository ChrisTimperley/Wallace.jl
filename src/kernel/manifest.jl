module Manifests
  import YAML
  export manifest

  type ManifestAuthor
    name::ASCIIString
    email::ASCIIString

    ManifestAuthor(mfst::Dict{Any, Any}) =
      new(mfst["name"], get(mfst, "email", ""))
  end

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

  function manifest(path::String)
  
    # Load the contents of the manifest file at the specified location
    # in their YAML form.
    yml = YAML.load_file(path)

    # Construct a manifest object from the YAML document.
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

    # Return the composed manifest.
    return mfst

  end

end

using Manifests
manifest("../types/operator/mutation/bit_flip/bit_flip.manifest.yml")

