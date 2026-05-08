// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SimpleAuction {
    address public beneficiary;
    uint public auctionEndTime;

    // 拍卖状态
    address public highestBidder;
    uint public highestBid;

    // 取回之前的出价
    mapping(address => uint) pendingReturns;

    bool ended;

    // 变更触发的事件
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    /// 受益者地址消息提示
    constructor(uint _biddingTime, address _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function bid() public payable {
        // 能接收以太币的函数，关键字 payable 是必须的
        require(block.timestamp <= auctionEndTime, unicode"拍卖已经结束");

        require(msg.value > highestBid, unicode"已经有更高的出价");

        if (highestBid != 0) {
            // 安全做法：让接收方自己提取金钱
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// 取回出价（当该出价已被超越）
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // 首先要设置零值
            // 接收者在 send 返回之前，重新调用该函数
            pendingReturns[msg.sender] = 0;

            if (!payable(msg.sender).send(amount)) {
                // 重置未付款
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// 拍卖结束，并把最高出价发送给受益人
    function auctionEnd() public {
        require(block.timestamp >= auctionEndTime, unicode"拍卖已经结束");
        require(!ended, unicode"拍卖结束函数已经被调用");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        payable(beneficiary).transfer(highestBid);
    }
}
