// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OrcaCoin is ERC20 {

  address private stakeContractAddress;
  address private owner;

  constructor(address _stakeContractAddress) ERC20("OrcaCoin", "ORCA") {
    stakeContractAddress = _stakeContractAddress;
    owner = msg.sender;
  }
  
  function updateStakeContractAddress(address _stakeContractAddress) public {
    require(msg.sender == owner, "You are not allowed to execute this command");
    stakeContractAddress = _stakeContractAddress;
  }

  function mint(address to, uint amt) public {
    require(msg.sender == stakeContractAddress, "You are not allowed to execute this command");
    _mint(to, amt);
  }

}