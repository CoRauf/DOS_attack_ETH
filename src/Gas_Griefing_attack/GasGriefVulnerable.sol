//SPDX-Lincense-Identifer:MIT

pragma solidity ^0.8.18;

contract GasGrief {
    address public highestBidder;
    address public owner;
    uint256 public highestBid;
    uint256 public auctionEnd;
    uint256 public remains = gasleft();

    constructor(){
        owner = msg.sender;
        // auctionEnd = block.timestamp + 1 days;
    }

    function bid() public payable {
        require(highestBid < msg.value, "Not higher than the hightestBidder");
        
        // require(auctionEnd < block.timestamp; "Auction has ended");

        if (highestBidder != address(0)){
            (bool sent, ) = payable(highestBidder).call{value: highestBid}("");
            require(sent, "ETH not sent");
        }
        
        
        highestBidder = msg.sender;
        highestBid = msg.value;
    }
}