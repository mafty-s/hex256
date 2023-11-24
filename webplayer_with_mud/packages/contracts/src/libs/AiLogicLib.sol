pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {EffectLib} from "./EffectLib.sol";
import {PlayerLogicLib} from "./PlayerLogicLib.sol";

library AiLogicLib {
    function Think(bytes32 player_key) internal {
        if(!CanPlay(player_key)){
            return;
        }


    }

    function CanPlay(bytes32 player_key) internal returns(bool){
        //todo
        return true;
    }
}