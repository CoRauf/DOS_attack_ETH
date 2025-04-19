//SPDX-License-Identifer:MIT

pragma solidity ^0.8.18;

import {KingOfEther} from "./Vulnerable_KingOfEther.sol";

contract Fixed_KingOfEther is KingOfEther{

    mapping(address => uint256) public balanceOf;

    function claimThrone() public payable override{
        require(msg.value > balance, "Not enough ETH to take throne");

        balanceOf[king] += balance;

        king = msg.sender;
        balance = msg.value;
    }

    function withdraw() public {
        require(msg.sender != king, "Don't leave, you own the throne");
        uint256 amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "ETH not sent");

    }
}