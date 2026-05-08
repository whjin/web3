// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <=0.9.0;

// 委托投票
contract Ballot {
    struct Voter {
        uint weight; // 计票权重
        bool voted;
        address delegate; // 被委托人
        uint vote; // 投票提案索引
    }

    struct Proposal {
        bytes32 name;
        uint voteCount; // 得票数
    }

    address public chairperson;

    // 状态变量
    mapping(address => Voter) public voters;

    // 动态数组
    Proposal[] public proposals;

    constructor(bytes32[] proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    // 授权 voter 对（投票表决）进行投票
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            unicode"只有 chairperson 可以调用该函数"
        );
        require(!voters[voter].voted, unicode"voter 已经准备好投票");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    // 把投票委托到投票者 to
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, unicode"你已经投票了");
        require(to != msg.sender, unicode"不允许自我授权");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, unicode"发现了循环授权");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage _delegate = voters[to];
        if (_delegate.voted) {
            proposals[_delegate.vote].voteCount += sender.weight;
        } else {
            _delegate.weight += sender.weight;
        }
    }

    function vote(uint proposal) public {
        
    }
}
