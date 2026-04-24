// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract MkErc20 {
    string public name = "MuKe Token";
    string public symbol = "$";
    uint8 public decimals = 4;
    mapping(address => uint256) public balanceOf;

    function transfer(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        return true;
    }
}
