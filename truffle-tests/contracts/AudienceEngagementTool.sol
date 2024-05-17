// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Models.sol";
import "./Interfaces.sol";

contract AudienceEngagementTool is Ownable, Initializable  {

    mapping(address => uint) votes;
    address[] keys;
    uint periodStart;
    uint periodEnd;

    IProposelContract proposelContract;

    uint internal fee;

    address public ownerAccount;

    event ProposelAdded(string name, string url, uint timestamp, uint votes, uint id);
    event VoteCasted(address voter, uint proposel_id);
    event VoteUncasted(address voter, uint proposel_id);
    event RemovedProposel(uint proposel_id);

    constructor(address IProposelContractAddress) Ownable(msg.sender){
        proposelContract =  IProposelContract(IProposelContractAddress);
        periodStart = block.timestamp;
        periodEnd = periodStart + 300;
        fee = 0;
        ownerAccount = msg.sender;
    }

    function getIndex(address[] memory keysList, address key)public pure returns (uint) {
        for (uint i = 0; i < keysList.length; i++) {
            if (keysList[i] == key) {
                return i;
            }
        }
        return 0;
    }

    function pop( address[] memory array) public pure returns (address[] memory){
        address[] memory newArray = new address[](array.length - 1);
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

    modifier isVotingPeriod() {
        require(block.timestamp < periodEnd, "Voting period has ended");
        _;
    }

    modifier alreadyVoted() {
        require(votes[msg.sender] != 0, "You haven't voted yet");
        _;
    }

    modifier notVotedYet() {
        require(votes[msg.sender] == 0, "You already voted");
        _;
    }

    modifier hasFounds(uint value) {
        require(msg.sender.balance > value, "Insuficient founds!");
        _;
    }

    modifier rightFeeValue() {
        require(msg.value == fee, "Invalid fee value");
        _;
    }

    function setProposelContractAddress(address IProposelContractAddress) public onlyOwner{
        proposelContract =  IProposelContract(IProposelContractAddress);
    }

    function resetVotes() private {
        for (uint i = 0; i < keys.length; i++) {
            delete votes[keys[i]];
        }
        delete keys;
    }

    function resetPeriod() public onlyOwner {
        periodStart = block.timestamp;
        periodEnd = periodStart + 300;
        resetVotes();
        if(proposelContract.listProposels().length > 0){
             proposelContract.removeWinningPropsel();
        }
    }

    function setFee(uint newFee) public onlyOwner {
        fee = newFee;
    }

    function setOwnerAccount(address newOwnerAccount) public onlyOwner {
        ownerAccount = newOwnerAccount;
    }

    function getPeriodInterval() public view returns (PeriodInterval memory) {
        return PeriodInterval({periodEnd: periodEnd, periodStart: periodStart});
    }

    function setProposel(
        string calldata name,
        string calldata url
    ) external payable hasFounds(fee) rightFeeValue {
        Proposel memory newProposel = proposelContract.addProposel(name,url);
        payable(ownerAccount).transfer(msg.value);
        emit ProposelAdded(name, url, block.timestamp, 0, newProposel.id); 
    }

    function vote(uint proposelId)  isVotingPeriod notVotedYet external {       
        votes[msg.sender] = proposelId;
        keys.push(msg.sender);
        proposelContract.increaseVotes(proposelId);
        emit VoteCasted(msg.sender, proposelId);
    }

    function unvote() isVotingPeriod alreadyVoted external {
        uint proposelId = votes[msg.sender];
        votes[msg.sender] = 0;
        proposelContract.decreaseVotes(proposelId);
        keys = removeElement(keys, getIndex(keys, msg.sender));
        emit VoteUncasted(msg.sender, proposelId);
    }

    function listProposels() public view returns (Proposel[] memory) {        
        return proposelContract.listProposels();
    }

    function getWinningProposel() public view returns (Proposel memory) {
        return proposelContract.getWinningProposel();
    }

    function makeTransfer(address to) payable external {
        payable(to).transfer(msg.value);
    }

    function getVotes() view public returns(address[] memory){
        return keys;
    } 

    function getFee() view public returns(uint){
        return fee;
    }
}
