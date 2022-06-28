// SPDX-License-Identifier: MIT

/**
* @title Escrow
* @dev Basic Escrow contract for fund transfers between two parties trustlessly
*/

pragma solidity ^0.8.10;

contract Escrow {

  address public funder;
  
  address public recipient;
  
  function fund(address counterparty) public payable {
    recipient = counterparty;
    
    funder = msg.sender;
  }

  function release() public payable {
    if (msg.sender == funder) {
    
      payable(recipent).transfer(address(this).balance);
  }
}

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}
