// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Counter {

    uint private count;

    // This function is created to increment the count by 1
    function inc() external returns(bool) {
        count+=1;
        return true;
    }

    // This function is created to decrement the count by 1
    function dec() external returns(bool) {
        require(count > 0, "Count is already at its min value: 0");
        count-=1;
        return true;
    }

    // This function is created to get value of count variable
    function get() external view returns(uint) {
        return count;
    }
}