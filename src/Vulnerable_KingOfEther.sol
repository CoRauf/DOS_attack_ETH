//SPDX-License-Identifer-MIT
pragma solidity ^0.8.18;

/*
    The king of Ether is more like a biding contract;
    The first user that claims the throne with a certain amount of ETH is the king;
    Any user that sends a larger amount of ETH than the previous king is the new KING;

    Here the issue. Once a user is detroned, he gets sent his ETHer right away i the same function call, which could lead to the contract falling prey to a REVERT_BASED_DOS attack. Denying all other users from taking the throne even if they sent triple the amount of the current king;
 */
contract KingOfEther{

    address public king;
    uint public balance; 

    function claimThrone() external payable{
        require(msg.value > balance, "Not enough to take the throne");

        (bool ok, ) = payable(king).call{value: balance}("");
        require(ok, "ETH not sent");

        balance = msg.value;
        king = msg.sender;
    }
}