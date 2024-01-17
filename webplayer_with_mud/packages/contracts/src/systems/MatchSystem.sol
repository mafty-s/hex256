// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {MatchingSingleton, Matches, MatchesData, CounterSingleton} from "../codegen/index.sol";


contract MatchSystem is System {

    function StartMatchmaking(uint8 nb_players) public returns (MatchesData memory){
        uint256 matching = MatchingSingleton.getValue();
        bytes32 matching_key = keccak256(abi.encode(matching));

        if (matching == 0 && Matches.getStartTime(matching_key) <= block.timestamp - 5) {
//            MatchingSingleton.setValue(game_uid);
            CounterSingleton.setValue(CounterSingleton.getValue() + 1);
            uint256 matching_id = CounterSingleton.getValue();
            bytes32 matching_key = keccak256(abi.encode(matching_id));
            Matches.setStartTime(matching_key, block.timestamp);
            Matches.setGame(matching_key, matching_id);
            Matches.setNbPlayers(matching_key, nb_players);

            MatchingSingleton.setValue(matching_id);
            Matches.pushPlayers(matching_key, _msgSender());

            return Matches.get(matching_key);
        } else {
            require(Matches.getItemPlayers(matching_key, 0) != _msgSender(), "You are already in the queue");
            Matches.pushPlayers(matching_key, _msgSender());
            MatchingSingleton.setValue(0);
            return Matches.get(matching_key);
        }
    }

    function CheckMatchmaking(uint256 matching_id) public view returns (MatchesData memory){
        bytes32 matching_key = keccak256(abi.encode(matching_id));
        return Matches.get(matching_key);
    }
}