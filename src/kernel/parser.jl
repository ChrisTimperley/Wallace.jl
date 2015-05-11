module Parser
  import JSON, DataStructures.OrderedDict
  export load_specification, compose, compose_as, composer, compose_with
 
  # Composer register.
  composer_register = Dict{String, Function}()

  # Retrieves a given composer by its alias.
  composer(alias::String) = composer_register[alias]

  # Registers a composer with a given alias.
  composer(f::Function, alias::String) = composer_register[alias] = f

  # Composes a given specification file into an object.
  function compose(file::String)
    s = load_specification(file)
    return compose_as(s, s["type"])
  end
  function compose_with(refinements::Function, file::String)
    s = load_specification(file)
    apply(refinements, [s])
    return compose_as(s, s["type"])
  end

  # Composes a given specification file into an object, using a predetermined composer.
  compose_as(file::String, as::String) =
    compose_as(load_specification(file), as)
  function compose_as_with(refinements::Function, file::String, as::String)
    s = load_specification(file)
    apply(refinements, [s])
    return compose_as(s, as)
  end

  # Composes a given specification object (in the form of a JSON object)
  # into the object it describes.
  compose_as(s::OrderedDict{String, Any}, as::String) =
    apply(composer(as), [s])

  # Insertion point functions.
  is_ins(::Any) = false
  is_ins(s::OrderedDict{String, Any}) = collect(keys(s)) == ["\$"]

  match_ins(s::OrderedDict{String, Any}, loc::String) =
    match_ins(s, String[ss for ss in split(loc, ".")])
  match_ins(s::OrderedDict{String, Any}, loc::Vector{String}) =
    length(loc) == 1 ? s[loc[1]] : match_ins(s[shift!(loc)], loc)
  match_ins(s::Vector{Any}, loc::Vector{String}) =
    length(loc) == 1 ? s[parseint(loc[1])] : match_ins(s[parseint(shift!(loc))], loc)

  inj_ins!(s::OrderedDict{String, Any}) = inj_ins!(s, s)
  inj_ins!(s::OrderedDict{String, Any}, ss::Any) = return
  function inj_ins!(s::OrderedDict{String, Any}, ss::OrderedDict{String, Any})
    for (k,v) in ss
      is_ins(v) ? ss[k] = match_ins(s, v["\$"]) : inj_ins!(s, v)
    end
  end
  function inj_ins!(s::OrderedDict{String, Any}, ss::Vector{Any})
    for (i,v) in enumerate(ss)
      is_ins(v) ? ss[i] = match_ins(s, v["\$"]) : inj_ins!(s, v)
    end
  end

  # Locate and parse each type tag within the document, line-by-line.
  function handle_type_tags(s::String)
    i = 1
    lines = split(s, "\n")
    while i <= length(lines)

      loc = search(lines[i], r"<\w+>:")
      if loc.stop != -1
        typ = lines[i][loc.start+1:loc.stop-2]

        # Inline block handling.
        bloc = search(lines[i], '{', loc.stop+1)
        if bloc != 0
          lines[i] = lines[i][1:bloc] * " type: $(typ), " * lines[i][bloc+1:end]
     
        # Indented block handling.
        # - Determine correct indent from the line below.
        elseif isblank(lines[i][loc.stop+1:end])
          insert!(lines, i+1, "$(indent_of(lines[i+1]))type: $(typ)")

        # Tried injecting type tags into unsupported element.
        else
          error("Failed to handle type tags; used in an unsupported context (Line $(i)).")
        end

        # Remove the tag from the line.
        lines[i] = lines[i][1:loc.start-1] * ":" * lines[i][loc.stop+1:end]
      end

      i += 1
    end

    return join(lines, "\n")
  end

  # Returns the leading indent for a given string.
  function indent_of(s::String)
    indent = ""
    i = 1
    while isblank(s[i])
      indent *= "$(s[i])"
      i += 1
    end
    return indent
  end

  # Parses a Wallace specification file into a JSON object.
  function parse(s::String)

    # Temporarily remove all strings from the specification text.
    i = 0
    strings = String[]
    s = replace(s, r"\"(\\.|[^\"])*\"", x -> begin
      push!(strings, x)
      i += 1
      "<STR_$i>"
    end)
    
    # Remove all comments.
    s = replace(s, r"#.*", "")

    # Format each insertion point into an object.
    s = replace(s, r"\$\(\w+\)", x -> "{\"\$\":\"$(x[3:end-1])\"}")

    # Inject the type properties into each object.
    s = replace(s, r"(\w|\/)+\s+{", x -> "{type: \"$(strip(x[1:end-1]))\", ")

    # Remove any unnecessary commas introduced by the former operation.
    s = replace(s, r",\s+}", x -> "}")

    # Wrap all unwrapped property names.
    s = replace(s, r"\b\w+:", x -> "\"$(x[1:end-1])\":")

    # Remove all empty lines.
    s = replace(s, r"\s*\n*\s{2,}", "\n")

    # Add a comma to the end of each property, except for the last of
    # each object.
    s = replace(s, r"(?<!{|^|,|\[)\n(?!}|\]|$)", ",\n")

    # Reinsert each of the removed strings.
    for i in 1:length(strings)
      s = replace(s, "<STR_$i>", strings[i])
    end

    # Parse as a JSON file.
    j = JSON.parse(s; ordered=true)
    inj_ins!(j)
    return j

  end

  load_specification(f::String) = parse(open(readall, f))

end
