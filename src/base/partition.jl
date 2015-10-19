module Partition
  export partition
  function partition(s::AbstractString, at::Union{AbstractString, Regex})
    i = search(s, at)
    i == 0:-1 ? (s, "", "") : (s[1:i.start-1], s[i], s[i.stop+1:end])
  end
end
