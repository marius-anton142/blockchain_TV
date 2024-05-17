// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {Proposel} from "./Models.sol";

interface IProposelContract {
    function addProposel(string memory name, string memory url) external returns (Proposel memory);

    function listProposels() external view returns (Proposel[] memory);

    function getWinningProposel() view external returns (Proposel memory);

    function removeWinningPropsel() external returns (Proposel memory) ;

    function decreaseVotes(uint proposel_id) external;
    
    function increaseVotes(uint proposel_id)  external ;
}