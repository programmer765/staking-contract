// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakingContract.sol";

contract StakingContractTest is Test {
  StakingContract public stakingContract;

  receive() external payable {}

  function setUp() public {
    stakingContract = new StakingContract(address(this));
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
}