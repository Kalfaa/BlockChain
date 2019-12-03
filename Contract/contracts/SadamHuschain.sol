pragma solidity ^0.5.12;
pragma experimental ABIEncoderV2;

contract SadamHuschain {

    struct Well {
        address id;
        uint8 score;
        string name;
        string localisation;
        string description;
        mapping(address => uint) voteList;
        address[] voterList;
    }


    struct WellJson {
        string name;
        string localisation;
        string description;
    }

    struct Voter {
        address id;
        string name;
        bool voted;
    }

    struct VoteList {
        mapping(address=>uint8) voteList;
    }

    address[] public wellAddressList;


    mapping(address => Well)  public wellByAddress;
    mapping(address => Voter) public voterByAddress;

    function createWell(string memory name,string memory localisation,string memory description) public   {
        address[] memory addressArray ;
        Well memory wellToto = Well(msg.sender,0,name,localisation,description,addressArray);
        wellByAddress[msg.sender] = wellToto;
        wellAddressList.push(msg.sender);
    }

    function createVoter(string memory name) public {
       Voter memory voter = Voter(msg.sender,name,false);
        voterByAddress[msg.sender] = voter;
    }

    function getMyVoter() public returns (Voter memory) {
        return voterByAddress[msg.sender];
    }

    function getMyWell() public returns (WellJson memory) {
            Well memory well = wellByAddress[msg.sender];
            return WellToWellJson(well);
    }

    function getWellList() public returns(WellJson[] memory){
        uint len = wellAddressList.length;
        WellJson[] memory wellList = new WellJson[](len);
        for (uint i=0; i<wellAddressList.length; i++) {
            wellList[i] = WellToWellJson(wellByAddress[wellAddressList[i]]);
        }
        return wellList;
    }

    function getWellNumber() public returns(uint256){
        return wellAddressList.length;
    }


    function vote(address addrWell,uint8 a ) public returns (bool){
        if (a >= 0 && a< 11){
            wellByAddress[addrWell].voteList[msg.sender] = a;
            wellByAddress[addrWell].score = a;
            address[] storage addressList = wellByAddress[addrWell].voterList;
            addressList.push(msg.sender);
            wellByAddress[addrWell].voterList= addressList;
            wellAddressList.push(msg.sender);
            return true;
        }else{
            return false;
        }
    }

    function WellToWellJson(Well memory well) private returns (WellJson memory){
        return WellJson(well.name,well.localisation,well.description);
    }
}
