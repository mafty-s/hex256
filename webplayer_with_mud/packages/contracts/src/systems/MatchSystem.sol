// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {MatchingSingleton,Matches,MatchesData,CounterSingleton} from "../codegen/index.sol";


contract MatchSystem is System {

    function StartMatchmaking(uint8 nb_players ) public returns(MatchesData memory){
        uint256 matching = MatchingSingleton.getValue();
        if(matching == 0){
//            MatchingSingleton.setValue(game_uid);
            CounterSingleton.setValue(CounterSingleton.getValue() + 1);
            uint256 matching_id = CounterSingleton.getValue();
            bytes32 matching_key = keccak256(abi.encode(matching_id));
            Matches.setGame(matching_key, matching_id);
            Matches.setNbPlayers(matching_key, nb_players);

            MatchingSingleton.setValue(matching_id);
            Matches.pushPlayers(matching_key,_msgSender());

            return Matches.get(matching_key);
        }else{
            bytes32 matching_key = keccak256(abi.encode(matching));
            require(Matches.getItemPlayers(matching_key,0) != _msgSender(),"You are already in the queue");
            Matches.pushPlayers(matching_key,_msgSender());
            MatchingSingleton.setValue(0);
            return Matches.get(matching_key);
        }
    }
}