pragma solidity >=0.7.0 <0.9.0;

contract Lottery{

    address public manager; //only 1 manager to manage the system
    
    //array of participnts as there will be many pasricipants
    address payable[] public participants;    //made paybale as when a participant wins they will be transfered the ether amount 

    constructor(){
        manager = msg.sender;   //global variable
    }

    receive() external payable //recieve fn used only once just to transfer ether 
    {   
        require(msg.value == 1 ether); 
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    //to generate random number
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,participants.length)));                    //keccak is a fn - google 
    }

    // to select winner - selected by manager
    function selectWinner() public{
        require(msg.sender == manager);
        require(participants.length>=3);
        uint r = random();  //r will contain a big random value
        address payable winner; //winner is payable - winner will be transfered winning amount
        uint index = r % participants.length;    // index will contain a random value which will be less than player.length always
        winner =  participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);


    } 


    

}