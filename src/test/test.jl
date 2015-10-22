module Common
  export hello
  hello() = error("Common stub method.")
end

module X
  importall Common
  hello(s1::AbstractString, s2::AbstractString) = "Hello $(s1) $(s2)"
end

module Y
  importall Common
  hello(s1::AbstractString) = "Hello $(s1)"
end

module All
  using Common, X, Y

  println(hello("Peter", "Griffin"))
end
