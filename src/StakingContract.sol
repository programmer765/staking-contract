// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./OrcaCoin.sol";
import { console } from "forge-std/console.sol";

interface IOrcaCoin {
  function mint(address to, uint amt) external;
}

contract StakingContract { 
  address private owner;
  address private orcaCoinAddress;
  uint256 private totalStaked;
  mapping(address => uint256) public stakes;

  constructor(address _orcaCoinAddress) {
    owner = msg.sender;
    orcaCoinAddress = _orcaCoinAddress;
  }

  function stake() public payable {
    uint256 amt = msg.value;
    require(amt > 0, "Please send a valid amount");
    // uint amtToStake = amt / 1e18;
    totalStaked += amt;
    stakes[msg.sender] += amt;
  }

  function unstake(uint amt) public {
    require(stakes[msg.sender] >= amt, "Not enough staked");
    (bool success, ) = payable(msg.sender).call{value: amt}("");
    require(success, "Transfer failed");
    totalStaked -= amt;
    stakes[msg.sender] -= amt;
  }

  function getRewards() public {

  }

  function claimRewards() public {

  }

  function getBalance(address _address) public view returns (uint256) {
    return stakes[_address];
  }

}
