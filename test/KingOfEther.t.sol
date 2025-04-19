//SPDX-License-Identifer:MIT
pragma solidity ^0.8.18;

import {console, Test} from "forge-std/Test.sol";
import {KingOfEther} from "../src/Revert_Based_DOS/Vulnerable_KingOfEther.sol";
import {AttackingDOS} from "../src/Revert_Based_DOS/AttackingDOS.sol";
import {Fixed_KingOfEther} from "../src/Revert_Based_DOS/FIxed_KingOfEther.sol";

contract KingOfEtherTest is Test {

    KingOfEther public kingOf;
    AttackingDOS public attack;
    Fixed_KingOfEther public fixed_kingOf;
    address attacker = address(0xBEEF);

    function setUp() public {
        kingOf = new KingOfEther();
        attack = new AttackingDOS(address(kingOf));
        fixed_kingOf = new Fixed_KingOfEther();
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

    function test_fixedKing() public {

        hoax(address(1), 15 ether);
        fixed_kingOf.claimThrone{value: 6 ether}();

        vm.prank(address(1));
        vm.expectRevert("Don't leave, you own the throne");
        fixed_kingOf.withdraw();


        hoax(address(2), 15 ether);
        fixed_kingOf.claimThrone{value: 7 ether}();

        vm.prank(address(1));
        fixed_kingOf.withdraw();

        fixed_kingOf.balanceOf(address(2));


    }
}