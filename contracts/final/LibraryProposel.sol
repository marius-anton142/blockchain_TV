// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "contracts/final/Models.sol";

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

    function removeElement(address[] memory array, uint256 index) public pure returns (address[] memory){
        for (uint256 i = index; i < array.length - 1; i++) {
            array[i] = array[i + 1];
        }
        return pop(array);
    }
}