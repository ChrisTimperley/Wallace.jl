#type LinearBreeder <: Breeder
#  threads::Integer
#  stages::Vector{BreederStage}
#end
#
#function breed!(b::LinearBreeder, d::Deme)
#  d.offspring = breed!(d.species, b.source, d, d.num_offspring, b)
#
#  # Single-threaded, for now.
#
#
#  for stage in stages
#    
#    # Perform the operation the requisite number of times, storing the
#    # proto-offspring in the buffer.
#    execute!(stage, input_buffer, output_buffer)
#
#    # Swap the input and output buffers around.
#    input_buffer, output_buffer = output_buffer, input_buffer
#
#    # Sync operation.
#    sync!(stage, buffer[1:needed])
#
#  end
#
#  # Copy the contents of the buffer to the deme offspring array.
#  #d.offspring = 
#
#end

register(joinpath(dirname(@__FILE__), "linear.manifest.yml"))
