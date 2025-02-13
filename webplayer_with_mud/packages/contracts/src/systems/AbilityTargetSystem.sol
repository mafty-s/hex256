
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {IEffectSystem} from "../codegen/world/IEffectSystem.sol";
import {IConditionSystem} from "../codegen/world/IConditionSystem.sol";
import {IFilterSystem} from "../codegen/world/IFilterSystem.sol";
import {Ability, AbilityExtend, CardOnBoards, Cards, PlayerActionHistory, ActionHistory, Players, Games, GamesExtended, Config} from "../codegen/index.sol";
import {AbilityTrigger, Status, Action, AbilityTarget, SelectorType, ConditionTargetType, GameState} from "../codegen/common.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";
import {CardTableLib} from "../libs/CardTableLib.sol";
import {PileType} from "../codegen/common.sol";

contract AbilityTargetSystem is System {


    function CanTarget(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) internal returns (bool) {
        if (is_card == ConditionTargetType.Card) {
            if (CardLogicLib.HasStatus(target, Status.Stealth)) {
                return false; //Hidden
            }

            if (CardLogicLib.HasStatus(target, Status.SpellImmunity)) {
                return false; ////Spell immunity
            }
        }
        return AreTargetConditionsMet(game_uid, ability_key, caster, bytes32(uint256(target)), ConditionTargetType.Slot); //No additional conditions for slots
    }

    function AreTargetConditionsMet(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType condition_type) internal returns (bool) {
        bytes4[] memory conditions_target = AbilityExtend.getConditionsTarget(ability_key);
        if (conditions_target.length > 0) {
            for (uint i = 0; i < conditions_target.length; i++) {
                bytes4 condition = conditions_target[i];
                if (condition != 0) {
                    if (!abi.decode(SystemSwitch.call(abi.encodeCall(IConditionSystem.IsTargetConditionMet, (condition, game_uid, ability_key, caster, target, condition_type))), (bool))) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    //////////
    //Return player targets,  memory_array is used for optimization and avoid allocating new memory
    function GetPlayerTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) public returns (bytes32[] memory){
        bytes32[] memory players = Games.getPlayers(game_uid);
        bytes32[] memory targets;
        if (target == AbilityTarget.PlayerSelf) {
            targets = new bytes32[](1);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            targets[0] = player_key;
        } else if (target == AbilityTarget.PlayerOpponent) {
            targets = new bytes32[](1);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32 opponent_key = player_key == players[0] ? players[1] : players[0];
            targets[0] = opponent_key;
        } else if (target == AbilityTarget.AllPlayers) {
            targets = players;
        }

        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.Player))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

        return targets;
    }

    //Return cards targets,  memory_array is used for optimization and avoid allocating new memory
    function GetCardTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) public returns (bytes32[] memory){
        uint numTargets = 0;
        bytes32[] memory players = Games.getPlayers(game_uid);
        bytes32[] memory targets;

        if (target == AbilityTarget.Self) {
            targets = new bytes32[](1);
            if (AreTargetConditionsMet(game_uid, ability_key, caster, caster, ConditionTargetType.Card)) {
                targets[numTargets] = caster;
                numTargets++;
            }
        }

        if (target == AbilityTarget.AllCardsBoard || target == AbilityTarget.SelectTarget)
        {

//            targets = new bytes32[](0);
            bytes32[] memory cards_board_a = CardTableLib.getValue(PileType.Board, players[0]);
            bytes32[] memory cards_board_b = CardTableLib.getValue(PileType.Board, players[1]);

            targets = new bytes32[](cards_board_a.length + cards_board_b.length);
            for (uint i = 0; i < cards_board_a.length; i++) {
                if (cards_board_a[i] != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_a[i], ConditionTargetType.Card)) {
                    if (numTargets > targets.length) {
                        revert("numTargets>targets.length");
                    }
                    targets[numTargets] = cards_board_a[i];
                    numTargets++;
                }
            }
            for (uint x = 0; x < cards_board_b.length; x++) {
                if (cards_board_b[x] != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_b[x], ConditionTargetType.Card)) {
                    if (numTargets > targets.length) {
                        revert("numTargets>targets.length");
                    }
                    targets[numTargets] = cards_board_b[x];
                    numTargets++;
                }
            }
        }

        if (target == AbilityTarget.AllCardsHand)
        {
            bytes32[] memory cards_board_a = CardTableLib.getValue(PileType.Hand, players[0]);
            bytes32[] memory cards_board_b = CardTableLib.getValue(PileType.Hand, players[1]);

            targets = new bytes32[](cards_board_a.length + cards_board_b.length);
            for (uint i = 0; i < cards_board_a.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_a[i], ConditionTargetType.Card)) {
                    targets[numTargets] = cards_board_a[i];
                    numTargets++;
                }
            }
            for (uint i = 0; i < cards_board_b.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards_board_b[i], ConditionTargetType.Card)) {
                    targets[numTargets] = cards_board_b[i];
                    numTargets++;
                }
            }
        }

        if (target == AbilityTarget.AllCardsAllPiles || target == AbilityTarget.CardSelector)
        {
            for (uint i = 0; i < players.length; i++) {
                bytes32 player_key = players[i];
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Board, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Hand, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Deck, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Discard, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Secret, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Equipped, player_key), ConditionTargetType.Card));
                targets = concatArrays(targets, AddValidCards(game_uid, ability_key, caster, CardTableLib.getValue(PileType.Temp, player_key), ConditionTargetType.Card));
            }
        }

        if (target == AbilityTarget.LastPlayed)
        {
            targets = new bytes32[](1);
            bytes32 last_played = GamesExtended.getLastPlayed(game_uid);
            if (last_played != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_played, ConditionTargetType.Card)) {
                targets[numTargets] = last_played;
                numTargets++;
            }
        }

        if (target == AbilityTarget.LastDestroyed)
        {
            targets = new bytes32[](1);
            bytes32 last_destroyed = GamesExtended.getLastDestroyed(game_uid);
            if (last_destroyed != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_destroyed, ConditionTargetType.Card)) {
                targets[numTargets] = last_destroyed;
                numTargets++;
            }
        }

        if (target == AbilityTarget.LastTargeted)
        {
            targets = new bytes32[](1);
            bytes32 last_target = GamesExtended.getLastTarget(game_uid);
            if (last_target != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_target, ConditionTargetType.Card)) {
                targets[numTargets] = last_target;
                numTargets++;
            }
        }

        if (target == AbilityTarget.LastSummoned)
        {
            targets = new bytes32[](1);
            bytes32 last_summoned = GamesExtended.getLastSummoned(game_uid);
            if (last_summoned != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, last_summoned, ConditionTargetType.Card)) {
                targets[numTargets] = last_summoned;
                numTargets++;
            }
        }

        if (target == AbilityTarget.AbilityTriggerer)
        {
            targets = new bytes32[](1);
            bytes32 ability_riggerer = GamesExtended.getAbilityTriggerer(game_uid);
            if (ability_riggerer != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, ability_riggerer, ConditionTargetType.Card)) {
                targets[numTargets] = ability_riggerer;
                numTargets++;
            }
        }


        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.Card))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

        return slice(targets, 0, numTargets);
    }

    function GetSlotTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) public returns (uint16[] memory) {
        uint16[] memory targets;
        uint numTargets = 0;

        if (target == AbilityTarget.AllSlots)
        {
            Slot[] memory slots = SlotLib.GetAll();
            targets = new uint16[](slots.length);
            for (uint i = 0; i < slots.length; i++) {
                uint16 encode = SlotLib.EncodeSlot(slots[i]);
                bytes32 slot32 = bytes32(uint256(encode));
                if (AreTargetConditionsMet(game_uid, ability_key, caster, slot32, ConditionTargetType.Slot)) {
                    targets[numTargets] = encode;
                    numTargets++;
                }
            }
        }
        targets = slice_u16(targets, 0, numTargets);

        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    bytes32[] memory temp = uint16ArrToBytes32Arr(targets);
                    temp = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, temp, ConditionTargetType.Slot))
                        ),
                        (bytes32[])
                    );
                    targets = bytes32ArrToUint16(temp);
                }
            }
        }
        return targets;
    }

    function GetCardDataTargets(bytes32 game_uid, bytes32 ability_key, AbilityTarget target, bytes32 caster) public returns (bytes32[] memory){
        uint numTargets = 0;
        bytes32[] memory targets;
        if (target == AbilityTarget.AllCardData) {
            bytes32[] memory cards = Config.getCards();
            targets = new bytes32[](cards.length);
            for (uint i = 0; i < cards.length; i++) {
                if (AreTargetConditionsMet(game_uid, ability_key, caster, cards[i], ConditionTargetType.CardData)) {
                    targets[numTargets] = cards[i];
                    numTargets++;
                }
            }
        }
        //Filter targets
        bytes4[] memory filters_target = AbilityExtend.getFiltersTarget(ability_key);
        if (filters_target.length > 0 && targets.length > 0)
        {
            for (uint i = 0; i < filters_target.length; i++) {
                bytes4 filter = filters_target[i];
                if (filter != 0) {
                    targets = abi.decode(
                        SystemSwitch.call(
                            abi.encodeCall(IFilterSystem.FilterTargets, (filter, game_uid, ability_key, caster, targets, ConditionTargetType.CardData))
                        ),
                        (bytes32[])
                    );
                }
            }
        }

        return targets;
    }

    function HasValidSelectTarget() internal {
        //todo
    }

    /////
    function AddValidCards(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32[] memory source, ConditionTargetType condition_type) internal returns (bytes32[] memory){
        bytes32[] memory dist = new bytes32[](source.length);
        uint number = 0;
        for (uint i = 0; i < source.length; i++) {
            if (source[i] != 0 && AreTargetConditionsMet(game_uid, ability_key, caster, source[i], condition_type)) {
                dist[number] = source[i];
                number++;
            }
        }
        return dist;
    }

    function concatArrays(bytes32[] memory array1, bytes32[] memory array2) internal pure returns (bytes32[] memory) {
        bytes32[] memory result = new bytes32[](array1.length + array2.length);

        uint256 i;
        for (i = 0; i < array1.length; i++) {
            result[i] = array1[i];
        }

        for (uint256 j = 0; j < array2.length; j++) {
            result[i] = array2[j];
            i++;
        }

        return result;
    }

    function slice(bytes32[] memory array, uint256 start, uint256 length) internal pure returns (bytes32[] memory) {
        require(start + length <= array.length, "Invalid slice range");
        bytes32[] memory result = new bytes32[](length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = array[start + i];
        }
        return result;
    }

    function slice_u16(uint16[] memory array, uint256 start, uint256 length) internal pure returns (uint16[] memory) {
        require(start + length <= array.length, "Invalid slice range");
        uint16[] memory result = new uint16[](length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = array[start + i];
        }
        return result;
    }

    function uint16ArrToBytes32Arr(uint16[] memory arr) internal pure returns (bytes32[] memory){
        bytes32[] memory result = new bytes32[](arr.length);
        for (uint i = 0; i < arr.length; i++) {
            result[i] = bytes32(uint256(arr[i]));
        }
        return result;
    }

    function bytes32ArrToUint16(bytes32[] memory arr) internal pure returns (uint16[] memory){
        uint16[] memory result = new uint16[](arr.length);
        for (uint i = 0; i < arr.length; i++) {
            result[i] = uint16(uint256(arr[i]));
        }
        return result;
    }
}