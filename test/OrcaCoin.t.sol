// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/OrcaCoin.sol";

contract OrcaCoinTest is Test {
  OrcaCoin public orcaCoin;

  function setUp() public {
    orcaCoin = new OrcaCoin(address(this));
  }

  function testInitialSupply() public view {
    assert(orcaCoin.totalSupply() == 0);
  }

  function testMint() public {
    orcaCoin.mint(address(this), 10);
    assert(orcaCoin.balanceOf(address(this)) == 10);
  }

  function testMintUnauthorized() public {
    vm.expectRevert("You are not allowed to execute this command");
    vm.prank(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA);
    orcaCoin.mint(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA, 10);
  }

  function testUpdateStakeContractAddress() public {
    orcaCoin.updateStakeContractAddress(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA);
    vm.prank(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA);
    orcaCoin.mint(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA, 10);
    assert(orcaCoin.balanceOf(0x97a2420497Bdd31bff7Cf4Ad01b08f44002D63AA) == 10);
  }

}