// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library UtilLibrary {
    
    function getIndex(address[] memory keys, address key)public pure returns (uint) {
        for (uint i = 0; i < keys.length; i++) {
            if (keys[i] == key) {
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
}