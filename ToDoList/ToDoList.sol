// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TodoList {

    // Task struct which contains;
    // content of the task : string text
    // info which the task is completed or not : bool IsComplete 

    struct Todo {
        string text;
        bool IsComplete;
    }
    // Array of the task 
    Todo[] public todos;

    // Creating a new task with the ToDo struct type and pushing the todos array
    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            IsComplete: false
        }));
    }

    // This function helps us to update the task info assigning the new values as parameters
    function UpdateText (uint _index, string calldata _text) external {
        Todo storage todo = todos[_index]; 
        todo.text = _text;
    }

    // This function gets and returns the special task info with the given index as a parameter from todos array
    function get(uint _index) external view returns (string memory, bool){
        Todo storage todo = todos[_index];
        return (todo.text, todo.IsComplete);
    }

    // This function provides us completing the task with the given index as a parameter => IsComplete value changing the true
    function Complete(uint _index) external {
        todos[_index].IsComplete = !todos[_index].IsComplete;
    }

}