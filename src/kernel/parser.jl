module Parser
  import YAML
  export parse, parse_file
 
  # Insertion point functions.
  is_ins(::Any) = false
  is_ins(s::Dict{Any, Any}) = collect(keys(s)) == ["\$"]

  match_ins(s::Dict{Any, Any}, loc::String) =
    match_ins(s, String[ss for ss in split(loc, ".")])
  match_ins(s::Dict{Any, Any}, loc::Vector{String}) =
    length(loc) == 1 ? s[loc[1]] : match_ins(s[shift!(loc)], loc)
  match_ins(s::Vector{Any}, loc::Vector{String}) =
    length(loc) == 1 ? s[parseint(loc[1])] : match_ins(s[parseint(shift!(loc))], loc)

  inj_ins!(s::Dict{Any, Any}) = inj_ins!(s, s)
  inj_ins!(s::Dict{Any, Any}, ss::Any) = return
  function inj_ins!(s::Dict{Any, Any}, ss::Dict{Any, Any})
    for (k,v) in ss
      is_ins(v) ? ss[k] = match_ins(s, v["\$"]) : inj_ins!(s, v)
    end
  end
  function inj_ins!(s::Dict{Any, Any}, ss::Vector{Any})
    for (i,v) in enumerate(ss)
      is_ins(v) ? ss[i] = match_ins(s, v["\$"]) : inj_ins!(s, v)
    end
  end

  # Locate and parse each type tag within the document, line-by-line.
  function handle_type_tags(s::String)
    i = 1
    lines = split(s, "\n")
    while i <= length(lines)
      loc = search(lines[i], r"<[\w\/\\-]+>:")
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
      
      # Only proceed to the next line if there were no changes to the line
      # during this pass. This allows supports for multiple type tags on a
      # single line (useful when nesting inline documents).
      else
        i += 1
      end
    end
    return join(lines, "\n")
  end

  # Replaces each range object definition within a given Wallace DSL file
  # with a 
  function handle_range_objects(s::String)
    # ^\s*\w+:\s+\d+:\d+
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

  # Parses a Wallace specification file as a pre-processed YAML file.
  parse_file(f::String) = parse(readall(f))
  function parse(s::String)
   
    # Remove all comments.
    s = replace(s, r"#.*", "")

    # Handle all type tags.
    s = handle_type_tags(s)

    # Prepare range objects.
    s = replace(s, r"^\s*\w+:\s+((\d+):(\d+))$"m, ss -> (
      pts = rsplit(ss, ":", 3); "$(pts[1]): {\"_range_object\": true, \"start\": $(pts[2]), \"end\": $(pts[3])}"
    ))

    # Format each insertion point into an object.
    s = replace(s, r"\$\(\w+\)", x -> "{\"\$\":\"$(x[3:end-1])\"}")

    # Parse as a YAML document, before handling insertion points and range
    # objects.
    d = YAML.load(s)
    inj_ins!(d)

    return d
  end

end
