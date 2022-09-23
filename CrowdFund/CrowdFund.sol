// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract CrowdFund {

    // the struct that it holds the campaign information
    struct Campaign {
        address creator;  
        uint goal;       
        uint32 startAt;   
        uint32 endAt;    
        bool claimed;     
        uint pledged;    
    }

    // Events for each function
    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Refund(uint indexed id, address indexed caller, uint amount);
    event Cancel(uint id);
    event Claim(uint id);


    IERC20 public immutable token; 
    uint public count;  // count of campaigns
    mapping(uint => Campaign) public campaigns; // list of campaigns with indexes
    mapping(uint => mapping(address => uint)) public pledgedAmount; // list of pledged amounts

    // inject the token via constructor
    constructor(address _token) {
        token = IERC20(_token);
    }

    // This function provides people can launch campaign via Campaign struct
    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        // Check the time space is available or not
        require(_startAt >= block.timestamp, "Start at < Now");
        require(_endAt >= _startAt, "End at < Start at");
        require(_endAt <= block.timestamp + 90 days, "End at > Max duration");

        // Create new campaign and add to campaigns
        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged : 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed : false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    // function for canceling campaign
    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        // Check msg.sender creater or not => Only creator of the campaign can cancel it 
        require(msg.sender == campaign.creator, "You're not a creator");
        // Check the campaign started or not
        require(block.timestamp < campaign.startAt, "Already started");
        // Delete the campaign info from campaigns
        delete campaigns[_id];
        // call Cancel event
        emit Cancel(_id);
    }

    // This function provides users can pledge tokens the campaign with the given parameters
    // _id => id of the campaign
    // _amount => amount of the pledge 
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        // Check the time is available or not
        require(block.timestamp >= campaign.startAt, "Not started");
        require(block.timestamp <= campaign.endAt, "Already ended");
        // Add the amount of the pledge of the campaign to pledgedAmount
        pledgedAmount[_id][msg.sender] += _amount;
        // Add pledged variable of the campaign the amount of the pledge and make the transfer via transferFrom 
        campaign.pledged += _amount;
        token.transferFrom(msg.sender, address(this), _amount);
        // call Pledge event
        emit Pledge(_id, msg.sender, _amount);
    }

    // This function provides users can get back tokens from the campaign with the given parameters while the campaign is still going
    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "Already ended"); 
        // Decreasing the campaing pledge via amount & update pledgedAmount
        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        // Send the tokens to user 
        token.transfer(msg.sender, _amount);
        // call Unpledge event
        emit Unpledge(_id, msg.sender, _amount);
    }

    // This function provides the creator of the campaign can claim all the tokens that were pledged 
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        // Check the caller creator or not
        require(msg.sender == campaign.creator, "You're not a creator");
        // Check the campaign ended or not
        require(block.timestamp > campaign.endAt, "Not ended"); 
        // Pledged must be greator than goal for claiming by creator
        require(campaign.pledged >= campaign.goal, "Pledged < Goal");
        // Check already claimed or not
        require(!campaign.claimed, "Already claimed");

        campaign.claimed = true;
        // Send tokens to creator
        token.transfer(msg.sender, campaign.pledged);
        // call Claim event
        emit Claim(_id);
    }

    // This function created for users can get back their tokens from campaign if the campaign could not reach goal amount
    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        // Campaign time must be ended for refund  
        require(block.timestamp > campaign.endAt, "Not ended"); 
        // Campaign pledged must be smaller than goal amount for refund
        require(campaign.pledged < campaign.goal, "Pledged >= Goal");

        // Send tokens to users back
        uint balance = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, balance);
        // call Refund event
        emit Refund(_id, msg.sender, balance);
    }

}