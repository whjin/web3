// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
// 0xd9145CCE52D386f254917e481eB44e9943F39138
contract MkErc20 {
    string public name = "MuKe Token";
    string public symbol = "$";
    uint8 public decimals = 4;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(uint totalAmount) {
        balanceOf[msg.sender] = totalAmount;
        totalSupply = totalAmount;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address from = msg.sender;
        uint256 fromb = balanceOf[from];
        uint256 tob = balanceOf[to];
        balanceOf[from] = fromb - amount;
        balanceOf[to] = tob + amount;
        return true;
    }
}
