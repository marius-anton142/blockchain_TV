// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct Proposel {
        address owner;
        string name;
        string url;
        uint256 timestamp;
        uint votes;
        uint id;
        bytes32 uniqueHash;
    }
struct PeriodInterval {
        uint periodStart;
        uint periodEnd;
    }

interface IPriceConsumerV3 {
    function getLatestPrice() external view returns (uint256);
}

library UtilLibrary {
    
    function toString(uint256 value) public pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

     function combineElemnets(string memory a, string memory b, uint number1, uint number2) public pure returns (string memory) {
        return string(abi.encodePacked(a, b, toString(number1), toString(number2)));
    }

    function gethash(string memory str) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(str));
    }

    function getIndex(address[] memory keys, address key)public pure returns (uint) {
        for (uint i = 0; i < keys.length; i++) {
            if (keys[i] == key) {
                return i;
            }
        }
        return 0;
    }

    function getIndexInList(Proposel[] memory proposels, uint id) public pure returns (uint) {
        for (uint i = 0; i < proposels.length; i++) {
            if (proposels[i].id == id) {
                return i;
            }
        }
        return 0;
    }

    function getIndexWithMaxVotes(Proposel[] memory proposels) public pure returns (uint) {
        uint maxVotes = 0;
        uint index = 0;
        for (uint i = 0; i < proposels.length; i++) {
            if (proposels[i].votes > maxVotes) {
                maxVotes = proposels[i].votes;
                index = i;
            }
        }
        return index;
    }

    function checkIndex(Proposel[] memory proposels, uint proposelId) public pure returns (bool) {
        for(uint i=0; i<proposels.length; i++){
            if(proposels[i].id == proposelId){
                return true;
            }
        }
        return false;
    }

    function pop( address[] memory array) public pure returns (address[] memory){
        address[] memory newArray = new address[](array.length - 1);
        for (uint i = 0; i < array.length - 1; i++) {
            newArray[i] = array[i];
        }
        return newArray;
    }

    function popPorposel( Proposel[] memory array) public pure returns (Proposel[] memory){
        Proposel[] memory newArray = new Proposel[](array.length - 1);
        for (uint i = 0; i < array.length - 1; i++) {
            newArray[i] = array[i];
        }
        return newArray;
    }

    function removeElement(address[] memory array, uint256 index) public pure returns (address[] memory){
        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        return pop(array);
    }
}

contract AudienceEngagementTool {

    mapping(address => uint) votes;
    address[] keys;
    Proposel[] proposels;
    Proposel public lastWinningProposal;
    uint periodStart;
    uint periodEnd;

    uint private idCounter;

    uint internal fee;

    address owner;

    event ProposelAdded(string name, string url, uint timestamp, uint votes, uint id);
    event VoteCasted(address voter, uint proposel_id);
    event VoteUncasted(address voter, uint proposel_id);
    event RemovedProposel(uint proposel_id);
    event ProposalThresholdReached(uint proposalId, uint voteCount);
    event SignificantVoteChange(uint proposalId, int change);

    IPriceConsumerV3 priceConsumer;
    constructor(address _priceConsumerAddress) {
        owner = msg.sender;
        periodStart = block.timestamp;
        periodEnd = periodStart + 300;
        fee = 1;
        idCounter = 1;
        priceConsumer = IPriceConsumerV3(_priceConsumerAddress);
    }

    function getLatestPrice() public view returns (uint256) {
        uint256 ethPrice = priceConsumer.getLatestPrice();
        return ethPrice;
    }

    function getNexId() private returns (uint) {
        return idCounter++;
    }

    modifier proposelIdExists(uint proposelId) {
        require(UtilLibrary.checkIndex(proposels, proposelId), "Proposel does not exist");
        _;
    }

    modifier isVotingPeriod() {
        require(block.timestamp < periodEnd, "Voting period has ended");
        _;
    }

    modifier alreadyVoted() {
        require(votes[msg.sender] == 0, "You already voted");
        _;
    }

    modifier notVotedYet() {
        require(votes[msg.sender] != 0, "You haven't voted yet");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Only the owner can acces this function");
        _;
    }

    modifier hasFounds() {
        require(msg.sender.balance > fee, "Insuficient founds!");
        _;
    }

    modifier rightFeeValue() {
        require(msg.value == fee, "Invalid fee value");
        _;
    }

    function increaseVotes(uint proposalId) private {
        uint index = UtilLibrary.getIndexInList(proposels, proposalId);
        proposels[index].votes++;
        
        if (proposels[index].votes == 1) {
            emit ProposalThresholdReached(proposalId, proposels[index].votes);
        }

        if (proposels[index].votes % 10 == 0) {
            emit SignificantVoteChange(proposalId, 10);
        }
    }

    function decreaseVotes(uint proposel_id) private proposelIdExists(proposel_id){
        uint i = UtilLibrary.getIndexInList(proposels, proposel_id);
        proposels[i].votes--;
    }

    function resetProposels() private {
        uint index = UtilLibrary.getIndexWithMaxVotes(proposels);
        emit RemovedProposel(proposels[index].id);

        for (uint256 i = index; i < proposels.length - 1; i++) {
            proposels[i] = proposels[i + 1];
        }
        proposels.pop();

        for (uint i = 0; i < proposels.length; i++) {
            proposels[i].votes = 0;
        }
    }

    function resetVotes() private {
        for (uint i = 0; i < keys.length; i++) {
            delete votes[keys[i]];
        }
        delete keys;
    }

    function resetPeriod() public isOwner {
        if (proposels.length > 0) {
            uint index = UtilLibrary.getIndexWithMaxVotes(proposels);
            lastWinningProposal = proposels[index];
        }
        periodStart = block.timestamp;
        periodEnd = periodStart + 300;
        resetVotes();
        resetProposels();
    }

    function setFee(uint newFee) public isOwner {
        fee = newFee;
    }

    function getPeriodInterval() public view returns (PeriodInterval memory) {
        return PeriodInterval({periodEnd: periodEnd, periodStart: periodStart});
    }

    function setProposel(
        string memory name,
        string memory url
    ) external payable hasFounds rightFeeValue {
        uint id = getNexId();

        // to do verificare daca propunerea exista deja
        Proposel memory newProposel = Proposel({
            name: name,
            url: url,
            timestamp: block.timestamp,
            votes: 0,
            id: id,
            owner: msg.sender,
            uniqueHash: UtilLibrary.gethash(UtilLibrary.combineElemnets(name, url, block.timestamp, id))
        });

        proposels.push(newProposel);
        payable(owner).transfer(msg.value);
        emit ProposelAdded(name, url, block.timestamp, 0, newProposel.id); 

    }

    function vote(uint proposel_id)  isVotingPeriod alreadyVoted external {       
        votes[msg.sender] = proposel_id;
        keys.push(msg.sender);
        increaseVotes(proposel_id);
        emit VoteCasted(msg.sender, proposel_id);
    }

    function unvote() isVotingPeriod notVotedYet external {
        uint proposel_id = votes[msg.sender];
        votes[msg.sender] = 0;
        decreaseVotes(proposel_id);
        keys = UtilLibrary.removeElement(keys, UtilLibrary.getIndex(keys, msg.sender));
        emit VoteUncasted(msg.sender, proposel_id);
    }

    function listProposels() public view returns (Proposel[] memory) {
        return proposels;
    }

    function getWinningPoposel() public view returns (Proposel memory) {
        Proposel memory proposel = Proposel({
            name: "",
            url: "",
            timestamp: 0,
            votes: 0,
            id: 0,
            owner: address(0),
            uniqueHash: bytes32(0)
        });
        return UtilLibrary.getIndexWithMaxVotes(proposels) >= 0 ? proposels[UtilLibrary.getIndexWithMaxVotes(proposels)] : proposel;
    }

    function getLastWinningProposal() public view returns (Proposel memory) {
        return lastWinningProposal;
    }

    function getFee() public view returns(uint) {
        return fee;
    }

    function makeTransfer(address to) payable external {
        payable(to).transfer(msg.value);
    }

    function getVotes() view public returns(address[] memory){
        return keys;
    } 
}
