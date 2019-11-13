pragma solidity ^0.4.0;

contract SadamHuschain {
    struct Candidate {
        address id;
        uint8 score;
    }

    struct Voter {
        bool voted;
        address id;
    }

    mapping(address => Candidate) public candidateByAddress;
    mapping(address => Voter) public voterByAddress;
    
    function SadamHuschain(){

    }
}
