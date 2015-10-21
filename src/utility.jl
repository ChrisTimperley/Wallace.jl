module utility
export Float, each, flatten, identity, partition

# Load the submodules.
include("utility/reflect.jl")
using .Reflect
export anonymous_type, anonymous_module, define_function

if is(Int, Int64)
  typealias Float Float64
else
  typealias Float Float32
end

function partition(s::AbstractString, at::Union{AbstractString, Regex})
  i = search(s, at)
  i == 0:-1 ? (s, "", "") : (s[1:i.start-1], s[i], s[i.stop+1:end])
end

"""
Applies a given function to each member of a given array.
"""
each(f::Function, a::Array) = for e in a; f(e); end

identity(x::Any) = x

"""
Flattens a vector of vectors into a one-dimensional vector.

Credit to:
http://permalink.gmane.org/gmane.comp.lang.julia.user/860
"""
flatten{T}(a::Array{T,1}) =
  any(map(x -> isa(x, Array), a)) ? flatten(vcat(map(flatten, a)...)) : a
flatten{T}(a::Array{T}) = reshape(a, prod(size(a)))
flatten(a) = a
end
