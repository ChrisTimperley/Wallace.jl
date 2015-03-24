# Applies a given function to each member of a given array.
module Each
  export each
  each(f::Function, a::Array) = for e in a; f(e); end
end
