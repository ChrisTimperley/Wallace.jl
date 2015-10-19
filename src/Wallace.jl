module Wallace
  export register, compose

  # Define some useful type aliases.
  if is(Int, Int64)
    typealias Float Float64
  else
    typealias Float Float32
  end

  # Load and import the base and kernel modules.
  include(joinpath(dirname(@__FILE__), "base/identity.jl"))
  include("base/partition.jl")
  include("base/each.jl")
  include("base/Reflect.jl")
  include("kernel/parser.jl")
  include("kernel/registry.jl")
  include("kernel/composer.jl")
  include("kernel/example.jl")
  include("kernel/help.jl")

  using .Each
  using .Reflect
  using .Partition
  using .Registry
  using .Parser
  using .Composer
  using .Help
  using DataStructures
  using StatsBase

  # Imports a file into the Wallace environment, relative to a given directory.
  function load(file::AbstractString, from::AbstractString)
    
    # Ensure the ".jl" suffix is added to the end of the file.
    if !(length(file) > 2 && file[end-2:end] == ".jl")
      file = string(file, ".jl") 
    end

    # Compute the absolute file path.
    file = normpath(joinpath(from, file))

    # Check that the file hasn't been loaded previously.
    if !in(file, loaded_files)
      push!(loaded_files, file)
      include(file)
    end

    return file
  end

  # Imports a file into the Wallace environment, relative to the current
  # working directory.
  load(file::AbstractString) = load(file, pwd())

  # Imports all files within a given directory into the Wallace environment
  # recursively.
  function load_all(directory::AbstractString)
    for f in readdir(directory)
      f = joinpath(directory, f)
      if endswith(f, ".jl")

        # I dislike this...
        # Things need a little tweaking here.
        load(basename(f), directory)

      elseif isdir(f)
        load_all(f)
      end
    end
  end

  # Initialise the type registry and the list of loaded files.
  type_registry = Dict{AbstractString, Type}()
  loaded_files = AbstractString[]

  # Load all of the built-in types.
  load_all(joinpath(dirname(@__FILE__), "types"))

end
