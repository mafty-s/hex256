pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {EffectLib} from "./EffectLib.sol";

library AbilityLib {

    function DoEffects(bytes32 ability_key, bytes32 caster_key) internal {
        bytes4[] memory effects = Ability.getEffects(ability_key);
        for (uint i = 0; i < effects.length; i++) {
            EffectLib.DoEffect(effects[i], ability_key, caster_key, 0, false);
        }
    }

    function DoEffects(bytes32 ability_key, bytes32 caster_key, bytes32 target_key) internal {
        //todo
    }

    function TriggerOtherCardsAbilityType(AbilityTrigger trigger, bytes32 triggerer) internal {

        //todo
    }

    function TriggerCardAbilityTypeOneCard(bytes32 game_key, AbilityTrigger trigger, bytes32 triggerer) internal {
        bytes32[] memory players = Matches.getPlayers(game_key);
        for (uint i = 0; i < players.length; i++) {
            TriggerCardAbilityTypePlayer(trigger, triggerer, players[i]);

            bytes32[] memory cards = PlayerCardsBoard.getValue(players[i]);
            for (uint j = 0; j < cards.length; j++) {
                TriggerCardAbilityTypeTwoCard(trigger, triggerer, cards[j]);
            }
        }
    }

    function TriggerCardAbilityTypeTwoCard(AbilityTrigger trigger, bytes32 caster, bytes32 triggerer) internal {
        bytes32[] memory abilities = Cards.getAbilities(caster);
        for (uint i = 0; i < abilities.length; i++) {
            if (Ability.getTrigger(abilities[i]) == trigger) {
                //todo
            }

        }

        //todo
    }

    function TriggerCardAbilityTypePlayer(AbilityTrigger trigger, bytes32 card_key, bytes32 player_key) internal {
        //todo
    }

}