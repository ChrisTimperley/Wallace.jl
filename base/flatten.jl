# encoding: utf-8
#
# Credit to:
# http://permalink.gmane.org/gmane.comp.lang.julia.user/860
flatten{T}(a::Array{T,1}) =
  any(map(x -> isa(x, Array), a)) ? flatten(vcat(map(flatten, a)...)) : a
flatten{T}(a::Array{T}) = reshape(a, prod(size(a)))
flatten(a) = a
