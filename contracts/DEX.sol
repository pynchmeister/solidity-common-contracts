// SPDX-License-Identifier: MIT
  
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DEX is ERC20 {

  address public assetPairTokenAddress;
  
  constructor(address _AssetPairToken) ERC20("DEXContract LP Token", "DCLP") {
    require(__AssetPairToken != address(0), "Token address passed is a null value");
  }
} 
