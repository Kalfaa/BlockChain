pragma solidity ^0.5.0;

contract SadamHuschain {
    struct Well {
        address id;
        uint8 score;
        string name;
        mapping(address => uint8) voteList;
        string localisation;
        string description;
    }

    struct Voter {
        string name;
        bool voted;
        address id;
    }

    mapping(address => Well) public wellByAddress;
    mapping(address => Voter) public voterByAddress;

    function createWell(string name,string localisation,string description) public   {
        wellToto = Well(msg.sender,0,nom,voteList[],localisation,description);
        wellByAddress[msg.sender] = wellToto;
    }

    function createVoter(string name) public  {
        voter = Voter(msg.sender,0,nom,voteList[],localisation,description);
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
