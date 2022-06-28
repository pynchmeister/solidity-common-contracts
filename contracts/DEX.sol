// SPDX-License-Identifier: MIT
  
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEX is ERC20 {

  address public assetPairTokenAddress;
  
  constructor(address _AssetPairToken) ERC20("DEXContract LP Token", "DCLP") {
    require(__AssetPairToken != address(0), "Token address passed is a null value");
  }
  
  function getReserve() public view returns (uint) {
    return ERC20(assetPairTokenAddress).balanceOf(address(this));
  }
  
  function removeLiquidity(uint _amount) public returns (uint, uint) {
    require(_amount > 0, "_amount should be greater than zero");
    uint ethReserve = address(this).balance;
    uint _totalSupply = totalSupply();
    
    uint ethAmount = (ethReserve * _amount / _totalSupply);
    
    uint assetPairTokenAddress = (getReserve() * _amount) / _totalSupply;
    
    _burn(msg.sender, _amount);
    
    payable(msg.sender).transfer(ethAmount);
    
    ERC20(assetPairTokenAddress).transfer(msg.sender, assetPairTokenAddress);
    return (ethAmount, assetPairTokenAddress);
  }
  
  function getTokenAmount(
    uint256 inputAmount,
    uint256 inputReserve,
    uint256 outputReserve
  ) public pure returns (uint256) {
      require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
      
      uint256 inputAmountWithFee = inputAmount * 99;
      
      uint256 numerator = inputAmountWithFee * outputReserve;
      uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
      return numerator / denominator
  }
  
  function ethToDEXContractToken(uint _minTokens) public payable {
    uint256 tokenReserve  = getReserve();
    
    uint256 tokensBought = getAmountOfTokens(
      msg.value,
      address(this).balance - msg.value,
      tokenReserve
    );
    
    require(tokensBought >= _minTokens, "insufficient output amount");
    
    ERC20(assetPairTokenAddress).transfer(msg.sender, tokensBought);
  }
  
  function assetPairTokenToEth(uint _tokensSold, uint _minEth) public {
    uint256 tokenReserve = getReserve();
    
    uint256 ethBought = getAmountOfTokens(
      _tokensSold,
      tokenReserve,
      address(this).balance
    );
    
    require(ethBought >= _minEth, "insufficient output amount");
    
    ERC20(assetPairTokenAddress).transferFrom(
      msg.sender,
      address(this),
      _tokensSold
    );
    
    payable(msg.sender).transfer(ethBought);
  }
} 
