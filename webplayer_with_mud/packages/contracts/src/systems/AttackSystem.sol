// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType} from "../codegen/common.sol";
import {CardCommonSingleton} from "../codegen/index.sol";

import "../libs/AbilityLib.sol";

contract AttackSystem is System {

    constructor() {

    }

    function AttackTarget(bytes32 attacker_key, bytes32 target_key, uint8 slot) public {

        //        if (game_data.CanAttackTarget(attacker, target, skip_cost))
        //        {
        //
        //            Player player = game_data.GetPlayer(attacker.player_id);
        //            if(!is_ai_predict)
        //                player.AddHistory(GameAction.Attack, attacker, target);
        //
        //            //Trigger before attack abilities
        //            TriggerCardAbilityType(AbilityTrigger.OnBeforeAttack, attacker, target);
        //            TriggerCardAbilityType(AbilityTrigger.OnBeforeDefend, target, attacker);
        //            TriggerSecrets(AbilityTrigger.OnBeforeAttack, attacker);
        //            TriggerSecrets(AbilityTrigger.OnBeforeDefend, target);

        AbilityLib.TriggerCardAbilityTypeTwoCard(AbilityTrigger.ON_BEFORE_ATTACK, attacker_key, target_key);
        AbilityLib.TriggerCardAbilityTypeTwoCard(AbilityTrigger.ON_BEFORE_DEFEND, target_key, attacker_key);

        //            //Resolve attack
        //            resolve_queue.AddAttack(attacker, target, ResolveAttack, skip_cost);
        //            resolve_queue.ResolveAll();
        //        }

        //todo

    }


    function AttackPlayer(bytes32 card_key, uint8 slot, bytes32 player_key) public {
        //todo
    }
}