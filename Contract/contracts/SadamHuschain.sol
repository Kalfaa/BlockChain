pragma solidity ^0.5.0;

contract SadamHuschain {
    struct Well {
        address id;
        uint8 score;
        string name;
        string localisation;
        string description;
        mapping(address => uint8) voteList;
    }

    struct Voter {
        address id;
        string name;
        bool voted;
    }

    mapping(address => Well) public wellByAddress;
    mapping(address => Voter) public voterByAddress;

    function createWell(string memory name,string memory localisation,string memory description) public   {
        Well memory wellToto = Well(msg.sender,0,name,localisation,description);
        wellByAddress[msg.sender] = wellToto;
    }

    function createVoter(string memory name) public  {
       Voter memory voter = Voter(msg.sender,name,false);
        voterByAddress[msg.sender] = voter;
    }

    function vote(address addrWell,uint8 a ) public returns (bool){
        if (a >= 0 && a< 11){
            wellByAddress[addrWell].voteList[msg.sender] = a;
            wellByAddress[addrWell].score = a;
            return true;
        }else{
            return false;
        }
    }
}
