// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Base {
    uint256 number;
    string public name = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    function store(uint256 num) public {
        number = num;
    }

    function retrieve() public view returns (uint256) {
        return number;
    }
}
