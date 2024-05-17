// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import  "./Interfaces.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ProposelContract is  Ownable,  IProposelContract {

    address[] keys;
    Proposel[] proposels;
    uint private idCounter;

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


    function getIndexInList(Proposel[] memory proposelsList, uint id) public pure returns (uint) {
        for (uint i = 0; i < proposelsList.length; i++) {
            if (proposelsList[i].id == id) {
                return i;
            }
        }
        return 0;
    }

    function getIndexWithMaxVotes(Proposel[] memory proposelsList) public pure returns (uint) {
        uint maxVotes = 0;
        uint index = 0;
        for (uint i = 0; i < proposelsList.length; i++) {
            if (proposelsList[i].votes > maxVotes) {
                maxVotes = proposelsList[i].votes;
                index = i;
            }
        }
        return index;
    }

    function checkIndex(Proposel[] memory proposelsList, uint proposelId) public pure returns (bool) {
        for(uint i=0; i<proposelsList.length; i++){
            if(proposelsList[i].id == proposelId){
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

    function removeElement(address[] memory array, uint256 index) public pure returns (address[] memory){
        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        return pop(array);
    }


    constructor() Ownable(msg.sender) {
        idCounter = 1;
    }

    function getNexId() private returns (uint) {
        return idCounter++;
    }

    modifier proposelIdExists(uint proposelId) {
        require(checkIndex(proposels, proposelId), "Proposel does not exist");
        _;
    }

    modifier atleastOneProposel(){
         require(proposels.length > 0, "No proposels availabel");
        _;
    }

    function increaseVotes(uint proposel_id) public proposelIdExists(proposel_id) {
        uint i = getIndexInList(proposels, proposel_id);
        proposels[i].votes++;  
    }

    function decreaseVotes(uint proposel_id) public proposelIdExists(proposel_id){
        uint i = getIndexInList(proposels, proposel_id);
        proposels[i].votes--;
    }

    function removeWinningPropsel() external atleastOneProposel() returns (Proposel memory) {

        uint index = getIndexWithMaxVotes(proposels);
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
            uniqueHash: gethash(combineElemnets(name, url, block.timestamp, id))
        });

        proposels.push(newProposel);
        return newProposel;
    }
    
    function listProposels() public view returns (Proposel[] memory) {
        return proposels;
    }


    function getWinningProposel() public atleastOneProposel view returns (Proposel memory) {
        uint index = getIndexWithMaxVotes(proposels);
        return proposels[index];
    }
 
}
