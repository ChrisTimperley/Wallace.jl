"""

ex = num

sum = e("@ex + @ex")
prod = e("@ex * @ex")
div = e("@ex / @ex")
num = digit
digit = 0:9

digit excluding zero = "1" | "2" | "3"


"""

@grammar begin
  start = block
  command = turnleft | turnright | forward | if_statement | loop
  turnleft = E("turn_left(ant)") # -> expr
  turnright = E("turn_right(ant)") # -> expr
  forward = E("forward(world, ant)") # -> expr
  if_statement = E("if @condition; @block else @block") # expr
  if_statement = Expr(:if, condition, block, block)
  condition = food_ahead
  food_ahead = Expr(:call, :food_ahead, :world, :ant)
  loop = Expr(:for, Expr(:(=), :i, Expr(:(:), 1, digit)), block) # this is nasty
  block[make_block] = (command)^(1:5)
  digit = 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
end
