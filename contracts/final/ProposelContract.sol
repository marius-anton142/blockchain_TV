// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/final/LibraryProposel.sol";
import "contracts/final/Interfaces.sol";

contract ProposelContract is  Ownable,  IProposelContract {

    address[] keys;
    Proposel[] proposels;
    uint private idCounter;

    constructor() Ownable(msg.sender) {
        idCounter = 1;
    }

    function getNexId() private returns (uint) {
        return idCounter++;
    }

    modifier proposelIdExists(uint proposelId) {
        require(UtilLibrary.checkIndex(proposels, proposelId), "Proposel does not exist");
        _;
    }

    modifier atleastOneProposel(){
         require(proposels.length > 0, "No proposels availabel");
        _;
    }

    function increaseVotes(uint proposel_id) public proposelIdExists(proposel_id) {
        uint i = UtilLibrary.getIndexInList(proposels, proposel_id);
        proposels[i].votes++;  
    }

    function decreaseVotes(uint proposel_id) public proposelIdExists(proposel_id){
        uint i = UtilLibrary.getIndexInList(proposels, proposel_id);
        proposels[i].votes--;
    }

    function removeWinningPropsel() public atleastOneProposel returns (Proposel memory){
        uint index = UtilLibrary.getIndexWithMaxVotes(proposels);
        Proposel memory removedProposel = proposels[index];
        for (uint256 i = index; i < proposels.length - 1; i++) {
            proposels[i] = proposels[i + 1];
        }
        proposels.pop();
        for (uint i = 0; i < proposels.length; i++) {
            proposels[i].votes = 0;
        }
        return removedProposel;
    }

    function addProposel(
        string memory name,
        string memory url
    ) public returns (Proposel memory)  {
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
        return newProposel;
    }
    
    function listProposels() public view returns (Proposel[] memory) {
        return proposels;
    }

    function getWinningProposel() public atleastOneProposel view returns (Proposel memory) {
        uint index = UtilLibrary.getIndexWithMaxVotes(proposels);
        return proposels[index];
    }
 
}
