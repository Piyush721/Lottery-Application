//SPDX-License-Identifier: GPL-3.0  

pragma solidity >=0.5 <=0.9;

contract Lottery{

    address public Manager;
    address payable[] public participants;

    constructor(){
        Manager=msg.sender; //global variable
    }

    receive() external payable{
        require(msg.value>=1 ether,"Cannot transfer less than 1 ether");
        participants.push(payable(msg.sender));
    }

    function participants_length() public view returns(uint){
        return participants.length;
    }

    function getBalance() public view returns(uint){
        require(msg.sender==Manager,"Only Manager can access the balance");
        return address(this).balance;
    }

    function random() public view returns(uint)
    {
    return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
    function decide() public {

        require(msg.sender==Manager,"Only Manager can decide the winner");
        require(participants_length()>=3,"Minimum participants should be 3");
        uint rand=random();
        uint index=rand % participants.length;
        address payable winner=participants[index];
        winner.transfer(getBalance());
        participants=new address payable[](0);  //resetting the lottery
    }

}