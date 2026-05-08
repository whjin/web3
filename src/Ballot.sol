// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

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

    constructor(bytes32[] memory proposalNames) {
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

    // 投票给提案 proposals[uint proposal].name
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, unicode"已投票");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    // 计算最终胜出的提案
    function winningProposal() public view returns (uint _winningProposal) {
        uint winningVoteCount = 0;

        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                _winningProposal = p;
            }
        }
    }

    // 调用 winningProposal 函数获取最终获胜者的索引和名称
    function winningName() public view returns (bytes32 _winningName) {
        _winningName = proposals[winningProposal()].name;
    }
}
