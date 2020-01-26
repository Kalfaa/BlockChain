pragma solidity ^0.5.12;
pragma experimental ABIEncoderV2;

contract SadamHuschain {

    struct Well {
        address id;
        uint score;
        uint voter;
        string name;
        uint finalScore;
        string localisation;
        string description;
        mapping(address => uint) voteList;
        address[] voterList;
    }

    struct Sadam {
        address id;
    }

    struct WellJson {
        string name;
        string localisation;
        string description;
        uint finalScore;
    }

    struct Voter {
        address id;
        string name;
        bool voted;
    }

    struct VoteList {
        mapping(address=>uint8) voteList;
    }

    string[] public wellNameList;

    Sadam public sadam;
    bool public voteStarted = false;
    bool public voteEnded = false;
    bool mediane;
    mapping(string => Well) public wellByName;
    mapping(address => Voter) public voterByAddress;


    modifier isSadam(address addr) {
        require (addr == sadam.id);
        _;
    }


    function createWell(string memory name,string memory localisation,string memory description) public isSadam(msg.sender)  {
        if(voteStarted == false){
            address[] memory addressArray ;
            Well memory well = Well(msg.sender,0,0,name,0,localisation,description,addressArray);
            wellByName[name] = well;
            wellNameList.push(name);
        }
    }

    function createVoter(string memory name) public {
       Voter memory voter = Voter(msg.sender,name,false);
        voterByAddress[msg.sender] = voter;
    }

    function createSadam() public returns (bool){
        if(sadam.id == address(0)){
            sadam = Sadam(msg.sender);
            return true;
        }
        return false;
    }

    function isSadamInit() public returns (bool){
        if(sadam.id == address(0)){
            return false;
        }
        return true;
    }

    function isThisSadam() public returns (bool){
        if(msg.sender == sadam.id){
            return true;
        }
        return false;
    }

    function getMyVoter() public view returns (Voter memory) {
        return voterByAddress[msg.sender];
    }

    function getAWell(string memory name) public returns (WellJson memory) {
            Well memory well = wellByName[name];
            return WellToWellJson(well);
    }

    function getWellList() public view returns(WellJson[] memory){
        uint len = wellNameList.length;
        WellJson[] memory wellList = new WellJson[](len);
        for (uint i=0; i< wellNameList.length; i++) {
            wellList[i] = WellToWellJson(wellByName[wellNameList[i]]);
        }
        return wellList;
    }

    function getWellNumber() public returns(uint256){
        return wellNameList.length;
    }

    function vote(string memory name,uint8 a ) public returns (bool){
        bool isNameExist = false;
        for(uint i = 0; i<wellNameList.length;i++){
            if(keccak256(abi.encodePacked((wellNameList[i]))) == keccak256(abi.encodePacked((name)))){
                isNameExist = true;
                break;
            }
        }
        if(voteStarted==true && isNameExist == true){
            wellByName[name].voteList[msg.sender] = a;
            wellByName[name].score += a;
            wellByName[name].voter+=1;
            address[] storage voteListWell = wellByName[name].voterList;
            voteListWell.push(msg.sender);
            wellByName[name].voterList = voteListWell;
            return true;
        }
        return false;
    }


    function isVoteStarted() public view returns(bool){
        return voteStarted;
    }

    function startVote() public isSadam(msg.sender) {
        voteStarted = true;
    }

    function WellToWellJson(Well memory well) private view returns (WellJson memory){
        return WellJson(well.name,well.localisation,well.description,well.finalScore);
    }

    function endVote() public isSadam(msg.sender){
        voteEnded = true ;
        for (uint i = 0 ; i<wellNameList.length;i++){
            string memory name = wellNameList[i];
            Well storage well= wellByName[name];
            if(well.voter!=0){
                well.finalScore = well.score / well.voter;
            }
        }
        return;
    }
}
