pragma solidity >=0.7.0 <0.9.0;
contract simpleAuction {
    // Variable
    address payable public beneficiary;
    uint public auctionEndTime;

    uint public highestBid;
    address public highestBidder;

    bool ended = false;

    mapping(address => uint) public pendingReturns;

    event highestBidIncrease(address bidder, uint amount);
    event auctionEnded(address winner, uint amount);

    constructor (uint _biddingTime, address payable _beneficiary){
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

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
        if (amount >0)  {
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
    function auctionEnd() public {
        if (ended = false) {
            revert("Auction has ended");
        } 
        if(block.timestamp < auctionEndTime) {
            revert("Auction hasn't ended");
        }
        ended = true;
        emit auctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }
}