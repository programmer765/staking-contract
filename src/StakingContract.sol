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
  uint256 private rewardRate = 100; // Example reward rate, can be adjusted

  struct UserInfo {
    uint256 amountStaked;
    uint256 rewardDebt;
    uint256 lastUpdateTime;
  }

  mapping(address => UserInfo) public userInfo;

  constructor(address _orcaCoinAddress) {
    owner = msg.sender;
    orcaCoinAddress = _orcaCoinAddress;
  }

  function _updateRewards(address user) internal {
    uint256 lastUpdate = userInfo[user].lastUpdateTime;
    userInfo[user].lastUpdateTime = block.timestamp;
    if (userInfo[user].amountStaked == 0) {
      return;
    }
    uint256 timeDiff = block.timestamp - lastUpdate;
    uint256 rewards = (userInfo[user].amountStaked * rewardRate * timeDiff) / 1e18;
    userInfo[user].rewardDebt += rewards;
  }

  function stake() public payable {
    uint256 amt = msg.value;
    require(amt > 0, "Please send a valid amount");
    // uint amtToStake = amt / 1e18;
    _updateRewards(msg.sender);
    totalStaked += amt;
    userInfo[msg.sender].amountStaked += amt;
  }

  function unstake(uint amt) public {
    require(userInfo[msg.sender].amountStaked >= amt, "Not enough staked");
    (bool success, ) = payable(msg.sender).call{value: amt}("");
    require(success, "Transfer failed");
    _updateRewards(msg.sender);
    totalStaked -= amt;
    userInfo[msg.sender].amountStaked -= amt;
  }

  function getRewards() public view returns (uint256) {
    uint256 timeDiff = block.timestamp - userInfo[msg.sender].lastUpdateTime;
    uint256 rewards = (userInfo[msg.sender].amountStaked * rewardRate * timeDiff) / 1e18;
    return rewards;
  }

  function claimRewards() public {
    _updateRewards(msg.sender);
    uint256 rewardsToClaim = userInfo[msg.sender].rewardDebt;
    require(rewardsToClaim > 0, "No rewards to claim");
    IOrcaCoin(orcaCoinAddress).mint(msg.sender, rewardsToClaim);
    userInfo[msg.sender].rewardDebt = 0;
  }

  function getBalance(address _address) public view returns (uint256) {
    return userInfo[_address].amountStaked;
  }

}
