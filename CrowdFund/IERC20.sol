// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
        function transfer(address to, uint256 amount) external returns (bool);
        function transferFrom(address from, address to, uint256 amount) external returns (bool);
        function approve(address spender, uint amount) external returns (bool);

        event Transfer(address indexed from, address indexed to, uint value);
        event Approval(address indexed owner, address indexed spender, uint value);
}

contract ERC20 is IERC20 {

        uint public totalSupply;
        mapping(address => uint) public balanceOf;
        mapping(address => mapping(address => uint)) public allowance;

        function transfer(address recipient, uint amount) external returns (bool) {
            balanceOf[msg.sender] -= amount;
            balanceOf[recipient] += amount;
            emit Transfer(msg.sender, recipient, amount);
            return true;
    }

        function transferFrom(address sender, address recipient, uint amount) external returns (bool) {
            allowance[sender][msg.sender] -= amount;
            balanceOf[sender] -= amount;
            balanceOf[recipient] += amount;
            emit Transfer(sender, recipient, amount);
            return true;
    }

        function mint(uint amount) external {
            balanceOf[msg.sender] += amount;
            totalSupply += amount;
            emit Transfer(address(0), msg.sender, amount);
    }

        function approve(address spender, uint amount) external returns (bool) {
            allowance[msg.sender][spender] = amount;
            emit Approval(msg.sender, spender, amount);
            return true;
    }
}