module Wallace

  # Define some useful type aliases.
  if is(Int, Int64)
#    typealias UInt  UInt64
    typealias Float Float64
  else
#    typealias UInt  UInt32
    typealias Float Float32
  end

  # Load and import the base modules.
  require("base/partition.jl")
  require("base/each.jl")
  require("base/Reflect.jl")
  
  using Each
  using Reflect
  using Partition

  # Returns true if a provided string ends with a given suffix, else
  # it returns false.
  function ends_with(str::ASCIIString, suffix::ASCIIString)
    len = length(suffix)
    length(str) >= len && str[end-len+1:end] == suffix
  end

  # Imports a file into the Wallace environment, relative to a given directory.
  function load(file::ASCIIString, from::ASCIIString)
    
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
  load(file::ASCIIString) = load(file, pwd())

  # Imports all files within a given directory into the Wallace environment
  # recursively.
  function load_all(directory::ASCIIString)
    for f in readdir(directory)
      f = joinpath(directory, f)
      if ends_with(f, ".jl")

        # I dislike this...
        # Things need a little tweaking here.
        load(basename(f), directory)

      elseif isdir(f)
        load_all(f)
      end
    end
  end

  # Initialise the type registry and the list of loaded files.
  type_registry = Dict{ASCIIString, Type}()
  loaded_files = ASCIIString[]

  # Registers a Julia type under a given alias in the Wallace kernel.
  function register(alias::ASCIIString, t::Type)
    type_registry[alias] = t
  end

  # Returns a register Julia type by its alias.
  t(alias::ASCIIString) =
    haskey(type_registry, alias) ? type_registry[alias] : error("Requested type not found: $alias.")

  # Constructs an instance of a Julia type.
  i(alias::ASCIIString, positionals...; keywords...) =
    i(t(alias), positionals...; keywords...)

  i(t::Type, positionals...; keywords...) = 
    apply(t, positionals...; keywords...)

  # Load all of the kernel files.
  load_all(joinpath(dirname(@__FILE__), "kernel"))

  # Load all of the built-in types.
  load_all(joinpath(dirname(@__FILE__), "types"))

end
