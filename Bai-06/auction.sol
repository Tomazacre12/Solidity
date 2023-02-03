pragma solidity >=0.7.0 <0.9.0;
contract simpleAuction {
    // Variable
    uint public auctionEndTime;

    uint public highestBid;
    address public highestBidder;

    mapping(address => uint) public pendingReturns;

    event highestBidIncrease(address bidder, uint amount);

    // Function
    function bid() public payable {
        if (block.timestamp > auctionEndTime) {
            revert("the auction time has ended");
        }
        if (msg.value <= highestBid) {
            revert("your value is not the highest value");
        }
        if (highestBid !=0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit highestBidIncrease(msg.sender, msg.value);
    }
    function withdraw() public returns(bool) {
        uint amount = pendingReturns[msg.sender];
    }
    function auctionEnd() public {

    }
}