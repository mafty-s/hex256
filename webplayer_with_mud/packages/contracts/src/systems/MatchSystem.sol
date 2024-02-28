// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {MatchingSingleton, Matches, MatchesData} from "../codegen/index.sol";


contract MatchSystem is System {

    function StartMatchmaking(uint8 nb_players) public returns (uint256, MatchesData memory){
        address player = _msgSender();
        uint256 matching_id = MatchingSingleton.getValue();
        if (matching_id == 0) {
            Matches.setStartTime(matching_id, block.timestamp);
            Matches.setNbPlayers(matching_id, nb_players);
        }
        uint256 start_time = Matches.getStartTime(matching_id);
        if (start_time < block.timestamp - 5 || Matches.lengthPlayers(matching_id) == 2) {
            matching_id = MatchingSingleton.getValue() + 1;
            Matches.setStartTime(matching_id, block.timestamp);
            Matches.setNbPlayers(matching_id, nb_players);
        }
        if(IsInPlayers(player, Matches.getPlayers(matching_id))){
            return (matching_id, Matches.get(matching_id));
        }
        Matches.pushPlayers(matching_id, player);
        MatchingSingleton.setValue(matching_id);
        return (matching_id, Matches.get(matching_id));
    }

    function CheckMatchmaking(uint256 matching_id) public view returns (MatchesData memory){
        return Matches.get(matching_id);
    }

    function IsInPlayers(address player, address[] memory players) internal pure returns (bool){
        for (uint i = 0; i < players.length; i++) {
            if (players[i] == player) {
                return true;
            }
        }
        return false;
    }
}