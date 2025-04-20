//SPDX-License-Identifer:MIT

pragma solidity ^0.8.18;

import {console, Test} from "forge-std/Test.sol";
import {Voting } from "../src/Gas_Griefing_attack/Voting_Vulnerable.sol";

contract voteTest is Test {

        Voting public vote;
    function setUp() public {
        vote = new Voting();
    }

    function test_private() public {
        bytes32 value = vm.load(address(vote), bytes32(uint256(1)));
        uint256 votes = uint256(value);

        assertEq(votes, 23);
    }
}