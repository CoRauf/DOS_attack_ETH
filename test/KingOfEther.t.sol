//SPDX-License-Identifer:MIT
pragma solidity ^0.8.18;

import {console, Test} from "forge-std/Test.sol";
import {KingOfEther} from "../src/Vulnerable_KingOfEther.sol";
import {AttackingDOS} from "../src/AttackingDOS.sol";

contract KingOfEtherTest is Test {

    KingOfEther public kingOf;
    AttackingDOS public attack;
    address attacker = address(0xBEEF);

    function setUp() public {
        kingOf = new KingOfEther();
        attack = new AttackingDOS(address(kingOf));
        deal(attacker, 10 ether);
    }

    function test_attack() public {
        hoax(address(1), 6 ether);
        kingOf.claimThrone{value: 3 ether}();

        assertEq(address(1), kingOf.king());
        assertEq(address(1).balance, 6 ether - 3 ether);


        vm.prank(attacker);
        attack.attack{value: 5 ether}();

        assertEq(address(attack), kingOf.king());
        assertEq(attacker.balance, 10 ether - 5 ether);


        hoax(address(2), 17 ether);
        vm.expectRevert();
        kingOf.claimThrone{value: 10 ether}();

        assert(address(1) != kingOf.king());
        assert(address(1).balance != 17 ether - 10 ether);
    }
}