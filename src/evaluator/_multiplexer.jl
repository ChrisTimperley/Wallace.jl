"""
This evaluator is specialised for dealing with boolean multiplexer problems.
"""
type MultiplexerEvaluator <: SimpleEvaluator
  input_lines::Int
  select_lines::Int
  total_lines::Int
  permutations::Int
  inputs::Vector{Vector{Bool}}
  outputs::Vector{Bool}

  MultiplexerEvaluator(bits::Int) =
    build(new(2^bits, bits))
end

"""
Boolean multiplexer evaluator.

**Parameters:**

* `bits::Int`, the number of selection bits for this multiplexer.
"""
function multiplexer(bits::Int)
  e = MultiplexerEvaluator(bits)
  e.total_lines = e.input_lines + e.select_lines
  e.permutations = 2 ^ e.total_lines
  e.outputs = Array(Bool, e.permutations)
  e.inputs = Array(Vector{Bool}, e.permutations)

  for i in 1:e.permutations
    value = i
    divisor = e.permutations
    e.inputs[i] = Array(Bool, e.total_lines)

    for j in 1:e.total_lines
      divisor /= 2
      if value >= divisor
        e.inputs[i][j] = true
        value = divisor
      else
        e.inputs[i][j] = false
      end
    end
    
    choice = e.select_lines
    for (j, k) in enumerate(e.inputs[i][1:e.select_lines])
      if k
        choice += 2 ^ (j - 1)
      end
    end
    e.outputs[i] = e.inputs[i][choice]
  end

  return e
end

"""
function evaluate!(e::MultiplexerEvaluator, s::State, sc::FitnessScheme, c::Individual)
  outputs = Array(Bool, e.permutations)
  for i in 1:e.permutations
    inp = e.inputs[i]
    outputs[i] = execute(get(c.genome), inp[1], inp[2], inp[3],
      inp[4], inp[5], inp[6], inp[7], inp[8], inp[9], inp[10], inp[11]) 
  end

  hits = 0
  for i in 1:e.permutations
    if outputs[i] == e.outputs[i]
      hits += 1
    end
  end

  fitness(sc, hits)
end
"""
