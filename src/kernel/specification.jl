type Specification
  path::AbstractString
  root::SubSpecification
end

type SubSpecification
  specification::Specification
  contents::Dict{Any, Any}
end

getindex(s::SubSpecification, key) = s.contents[key]
setindex!(s::SubSpecification, value, key) = s.contents[key] = value
