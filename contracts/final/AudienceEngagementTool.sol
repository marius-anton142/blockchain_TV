// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "contracts/final/Models.sol";
import "contracts/final/LibraryAudianceEngagementTool.sol";
import "contracts/final/Interfaces.sol";

contract AudienceEngagementTool is Ownable, Initializable  {

    mapping(address => uint) votes;
    address[] keys;
    uint periodStart;
    uint periodEnd;
    Proposel public lastWinningProposal;
    IProposelContract proposelContract;
    address ownerAccount;
    AggregatorV3Interface internal priceFeed;
    uint internal fee;

    event ProposelAdded(string name, string url, uint timestamp, uint votes, uint id);
    event VoteCasted(address voter, uint proposel_id);
    event VoteUncasted(address voter, uint proposel_id);
    event RemovedProposel(uint proposel_id);
    event ResetPeriod(string url);

    constructor(address IProposelContractAddress) Ownable(msg.sender){
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        proposelContract =  IProposelContract(IProposelContractAddress);
        periodStart = block.timestamp;
        periodEnd = periodStart + 300;
        fee = 1;
        ownerAccount = msg.sender;
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

    function getLatestPrice() public view returns (uint256) {
        (
            ,
            int price,
            ,
            ,
        ) = priceFeed.latestRoundData();
        return uint256(price) / 1e8;
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
        if( proposelContract.listProposels().length > 0){
            lastWinningProposal = proposelContract.getWinningProposel();
            proposelContract.removeWinningPropsel();
        }
        emit ResetPeriod(lastWinningProposal.url);
    }

    function setFee(uint newFee) public onlyOwner {
        fee = newFee;
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
        keys = UtilLibrary.removeElement(keys, UtilLibrary.getIndex(keys, msg.sender));
        emit VoteUncasted(msg.sender, proposelId);
    }

    function listProposels() public view returns (Proposel[] memory) {        
        return proposelContract.listProposels();
    }

    function getWinningPoposel() public view returns (Proposel memory) {
        return proposelContract.getWinningProposel();
    }

    function makeTransfer(address to) payable external {
        payable(to).transfer(msg.value);
    }

    function getVotes() view public returns(address[] memory){
        return keys;
    }

    function getFee() public view returns(uint) {
        return fee;
    }

    function getLastWinningProposal() public view returns (Proposel memory) {
        return lastWinningProposal;
    }
}
