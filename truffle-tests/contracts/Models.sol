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

contract ModelsContarct{

}