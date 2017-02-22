pragma solidity ^0.4.2;

import "./Congress.sol";

contract ActivityInterface is usingProperty{

    event biddingAdded(bool);
    address owner;



    struct Bidding{
        uint id;
        address bidOwner;
        uint propertyId;
        bytes32 name;
        uint256 startingPrice;
        uint256 currentPrice;
        uint startDate;
        uint closeDate;
        uint lastUpdateDate;
        address lastBidder;
    }

    Bidding[] biddingList;

    function ActivityInterface(){
        owner = msg.sender;
    }

    function addBidding(uint _propertyId, bytes32 _name, uint256 _startingPrice, uint256 _currentPrice, uint _closeDate) returns(bool success, uint _id){
        _id = biddingList.length++;

        biddingList[_id] = Bidding({
            id: _id,
            bidOwner : msg.sender,
            propertyId: _propertyId,
            name: _name,
            startingPrice: _startingPrice,
            currentPrice: _startingPrice,
            startDate: now,
            closeDate: _closeDate,
            lastUpdateDate: now,
            lastBidder: 0
        });


        biddingAdded(true);
    }

    function removeBidding(uint _id) returns(bool success){
        if (getBiddingListLength() == 0) throw;

        for (uint i = 0; i<biddingList.length-1; i++){
            biddingList[i] = biddingList[i+1];
        }
        delete biddingList[biddingList.length-1];
        biddingList.length--;

    }

    function queryBidding(uint _id) returns (uint, address, uint, bytes32, uint256, uint256, uint, uint, uint, address){
        Bidding temp = biddingList[_id];
        return (temp.id, temp.bidOwner, temp.propertyId, temp.name, temp.startingPrice, temp.currentPrice, temp.startDate, temp.closeDate, temp.lastUpdateDate, temp.lastBidder);
    }

    function getBiddingListLength() constant returns(uint){
        return biddingList.length;
    }


}

contract BuyerInterface is ActivityInterface{


    function BuyerInterface(){

    }

    function bid(uint _id, uint256 bidPrice, address buyAddress) returns (bool success){
        if (bidPrice <= biddingList[_id].currentPrice || now > biddingList[_id].closeDate || msg.sender == biddingList[_id].bidOwner) throw;
        biddingList[_id].currentPrice = bidPrice;
        biddingList[_id].lastBidder = msg.sender;
        biddingList[_id].lastUpdateDate = now;
    }

    function resourceRating(uint _id, uint rating){
        address CongressAddress = 0x1;
        Congress temp = Congress(CongressAddress);
        uint s_Id = temp.stakeholderId(msg.sender);
        propertyList[_id].rating[s_Id] = rating;



    }

}

contract SellerInterface is ActivityInterface{

    function SellerInterface(){

    }

}
