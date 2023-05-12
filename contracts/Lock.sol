// SPDX-License-Identifier

pragma solidity ^0.8.18;

contract Will2 {
    address public owner;
    uint256 public fortune;
    address[] inheritorsArray;
    mapping(address => uint) inherites;
    uint lastPing;

    // constructor(address _owner) {
    //     owner = _owner;
    //     fortune = msg.value;
    // }

    constructor() payable{
        owner = msg.sender;
        fortune = msg.value;
    }

    // function addInheritor(address inhr) external {
    //     if(owner == msg.sender) {
    //         inheritorsArray.push(inhr);
    //     }
    // }

    function addInheritor(address _inheritor, uint _value) external payable{
        require(msg.sender == owner, "Only owner can perform this action");
        require(_value <= fortune, "Not Sufficient Fortune");
        require(inherites[_inheritor] == 0, "Already added");
        inheritorsArray.push(_inheritor);
        inherites[_inheritor] = _value;
        fortune -= _value;
    }

    function ping() public ownerCheck{
            lastPing = block.timestamp;
    }


    modifier ownerCheck {
        require(msg.sender == owner, "Only the owner can do that");
        _;
    }

    function increaseFortune(uint valor) external payable ownerCheck{
        fortune += valor;
        ping();
    }

    modifier isInheritor {
        require(inherites[msg.sender] > 0, "Only Inheritors can call this functions");
        _;
    }

    function splitFortune() external payable{
        require(block.timestamp - lastPing > 7 days);
        for(uint i = 0; i < inheritorsArray.length; i++) {
            address inher = inheritorsArray[i];
            (bool success,) = payable(inher).transfer(inherites[inher]);
            require(success, "Splitting failed");
        }
        // self.destruct(adr); // to do self destruct and send the possible remaining to the entered address
    }
}