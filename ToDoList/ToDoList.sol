// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TodoList {

    struct Todo {
        string text;
        bool IsComplete;
        
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({
            text: _text,
            IsComplete: false
        }));
    }

    function UpdateText (uint _index, string calldata _text) external {
        Todo storage todo = todos[_index]; 
        todo.text = _text;
    }

    function get(uint _index) external view returns (string memory, bool){
        Todo storage todo = todos[_index];
        return (todo.text, todo.IsComplete);
    }

    function Complete(uint _index) external {
        todos[_index].IsComplete = !todos[_index].IsComplete;
    }

}