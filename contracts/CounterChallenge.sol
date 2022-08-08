// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

contract CounterChallenge {
    uint private count = 0;
    uint public goal = 0;
    uint public contribution = 0;

    // 1 eth = 1 * 10 ** 18 wei

    address payable owner;
    address payable public recipient;
    

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor(
        address payable _owner,
        address payable _recipient,
        uint _goal
    ) {
        owner = _owner;
        recipient = _recipient;
        goal = _goal;
    }

    function setRecipient(address payable _addr) 
        public 
        isOwner
    {
        recipient = _addr;
    }

    function addToPool(uint _value)
        payable 
        public
        isOwner 
    {
        require(_value > 0);
        uint value = _value * 10 ** 18;
        owner.transfer(value);
    }

    function setGoal(uint _goal) 
        public
        isOwner 
    {
        require(_goal > 0);
        goal = _goal;
    }

    function incrCounter() 
        public 
        isOwner
    {
        count += 1;
    }

    function getCount() public view returns (uint) {
        return count;
    }

    function releasePay() 
        public
        payable
        isOwner
    {
        require(count >= goal, "Counter must exceed or equal to goal");
        require(address(this).balance >= contribution, "Contract has enough for payout");

        recipient.transfer(contribution);
    }


    function contributeToPool() 
        public
        payable
    {
        // at least 1 eth for participate
        require(msg.value >= 1 * (10 ** 18), "Minimum at least one eth");

        // to the address 
        recipient.transfer(msg.value);
    }

    // how much money in the contract
    function balanceOf() public view returns (uint) {
        return address(this).balance;
    }
}
