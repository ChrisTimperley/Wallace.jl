module Manifests
  import YAML
  export manifest

  type ManifestAuthor
    name::String
    email::String

    ManifestAuthor(mfst::Dict{Any, Any}) =
      new(mfst["name"], get(mfst, "email", ""))
  end

  type Manifest
    id::String
    description::String
    authors::Vector{ManifestAuthor}
    tags::Vector{String}
    aliases::Vector{String}
    imports::Vector{String}
    properties::Dict{String, Dict{String, Any}}

    Manifest(id::String) =
      new(id, "", [], [], [], [], Dict{String, Dict{String, Any}}())
  end

  function manifest(path::String)
  
    # Load the contents of the manifest file at the specified location.
    f = YAML.

  end

end
