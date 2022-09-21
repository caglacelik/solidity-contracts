// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

    // Fee Collector is 
contract FeeCollector { 
    
    address public owner; // owner of the contract
    uint256 public balance; // variable that we hold the balance of the contract
    
    // assigning msg.sender to the owner
    constructor() {
        owner = msg.sender; 
    }
    
    // This function provides us adding the balance to the balance variable via coming from value property of the message object (ether)
    receive() payable external {
        balance += msg.value; 
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can withdraw");
        _;
    }
    
    // This function exists to allow us to send eth to the address which is one of the parameters of function => destAddr
    // Decrease the balance of the contract => amount
    function withdraw(uint amount, address payable destAddr) public onlyOwner {
        require(amount <= balance, "Insufficient funds");
        destAddr.transfer(amount);
        balance -= amount;
    }
}