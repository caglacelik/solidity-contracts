// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FeeCollector { 
    
    address public owner; // owner of the contract
    uint256 public balance; // variable that we hold the balance of the contract
    
    // assigning msg.sender to the owner
    constructor() {
        owner = msg.sender; 
    }
    
    // This function provides us adding the balance to the balance variable via coming from value property of the msg object
    receive() payable external {
        balance += msg.value; 
    }

    // Modifier created for attaching the functions which checks the msg.sender is owner or not 
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can withdraw");
        _;
    }
    
    // This function exists to allows us to send eth to the given address via parameter which is destAddr
    // Decrease the balance of the contract via parameter which is amount
    function withdraw(uint amount, address payable destAddr) public onlyOwner {
        require(amount <= balance, "Insufficient funds");
        destAddr.transfer(amount);
        balance -= amount;
    }
}