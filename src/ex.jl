abstract Individual

macro individual_type(name)
  println("hello")
  def = "type $(name) <: Individual; end"

  :(
  eval(:(function x(); println("goodbye"); end))
end

println(@individual_type())
x()
