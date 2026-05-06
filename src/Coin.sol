// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Coin {
    // 关键字“public”让这些变量可以从外部读取
    address public minter;
    mapping(address => uint) public balances;

    // 轻客户端可以通过事件针对变化作出高效的反应
    event Sent(address from, address to, uint amount);
}
