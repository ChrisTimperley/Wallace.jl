abstract ERC

type NumericERC{N} <: ERC
  min::N
  max::N
end

call{N}(erc::NumericERC{N}) = rand(erc.min, erc.max)

