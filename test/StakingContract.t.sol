// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakingContract.sol";
import "../src/OrcaCoin.sol";

contract StakingContractTest is Test {
  StakingContract public stakingContract;
  OrcaCoin public orcaCoin;

  receive() external payable {}

  function setUp() public {
    orcaCoin = new OrcaCoin(address(this));
    stakingContract = new StakingContract(address(orcaCoin));
    orcaCoin.updateStakeContractAddress(address(stakingContract));
  }

  function testStake() public {
    stakingContract.stake{value: 1 ether}();
    assert(stakingContract.getBalance(address(this)) == uint(1 ether));
    
  }

  function testUnstake() public {
    vm.deal(address(this), 10 ether);
    stakingContract.stake{value: 2 ether}();
    stakingContract.unstake(1 ether);
    assert(stakingContract.getBalance(address(this)) == uint(1 ether));
  }

  function test_Revert_Unstake() public {
    vm.deal(address(this), 10 ether);
    stakingContract.stake{value: 1 ether}();
    vm.expectRevert("Not enough staked");
    stakingContract.unstake(2 ether);
  }

  function testGetRewards() public {
    vm.deal(address(this), 10 ether);
    stakingContract.stake{value: 1 ether}();
    // Simulate time passing
    vm.warp(block.timestamp + 1 days);
    uint256 rewards = stakingContract.getRewards();
    // console.log("Rewards after 1 day:", rewards);
    assert(rewards > 0);
  }

  function testClaimRewards() public {
    vm.deal(address(this), 10 ether);
    stakingContract.stake{value: 1 ether}();
    // Simulate time passing
    vm.warp(block.timestamp + 1 days);
    stakingContract.claimRewards();
    // Assuming the mint function works correctly, we would check the balance of OrcaCoin here
    // For this test, we will just check that rewards have been reset to 0
    uint256 rewardsAfterClaim = stakingContract.getRewards();
    assert(rewardsAfterClaim == 0);
  }

  function test_Revert_IF_ClaimRewards() public {
    vm.deal(address(this), 10 ether);
    stakingContract.stake{value: 1 ether}();
    // Simulate time passing
    vm.warp(block.timestamp + 1 days);
    stakingContract.claimRewards();
    // Attempt to claim rewards again immediately, should revert since rewards are reset
    vm.expectRevert("No rewards to claim");
    stakingContract.claimRewards();
  }
}