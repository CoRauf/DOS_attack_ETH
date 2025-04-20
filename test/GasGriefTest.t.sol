//SPDX-License-Identifer: MIT

pragma solidity ^0.8.18;


import {console, Test} from "forge-std/Test.sol";
import {GasGrief} from "../src/Gas_Griefing_attack/GasGriefVulnerable.sol";
import {Attacker} from "../src/Gas_Griefing_attack/GasGriefAttack.sol";

contract GasGriefTest is Test{

    GasGrief public grief;
    Attacker public attack;
    function setUp() public {
        grief = new GasGrief();
        attack = new Attacker(address(grief));
    }

    function test_bid() public {
        hoax(address(1), 15.35 ether);
        grief.bid{value: 9 ether}();
        console.log(grief.highestBid(), grief.highestBidder());

        hoax(address(2), 15 ether);
        grief.bid{value : 10 ether}();
        console.log(grief.highestBid(), grief.highestBidder());

        hoax(address(3), 17.54651616 ether);
        vm.expectRevert("Not higher than the hightestBidder");
        grief.bid{value : 5 ether}();
        
        console.log(grief.highestBid(), grief.highestBidder());
        

    }

    function test_attack() public {

        // hoax(address(attack), 20 ether);
        console.log(gasleft(), grief.remains());
        attack.attack_deposit{value : 5 ether}();
        console.log(grief.highestBid(), grief.highestBidder());

        hoax(address(8), 15.35 ether);
        vm.expectRevert();
        grief.bid{value: 9 ether}();
        console.log(grief.highestBid(), grief.highestBidder());

        hoax(address(2), 15 ether);
        vm.expectRevert();
        grief.bid{value : 10 ether}();
        console.log(grief.highestBid(), grief.highestBidder());
        console.log(gasleft(), grief.remains());
        
    }
        //Do contract in foundty already have gas in them
        //who is calling the attacker function or does it call itself
}