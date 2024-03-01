// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Players, Ability, Games, GamesExtended, PlayerActionHistory, ActionHistory} from "../codegen/index.sol";
import {Action, PileType} from "../codegen/common.sol";
import {Cards, CardOnBoards} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";
import {ConditionTargetType} from "../codegen/common.sol";
import {CardTableLib} from "../libs/CardTableLib.sol";

contract Effect2System is System {

    event EventEffect(string name, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card);

    function EffectTransformFish(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectTransformFish", ability_key, caster, target, is_card);
        bytes32 fish = 0x922d0a331fd751dd3f9f56ab05f7acb5b6a7080eb367ecbe613cc632beee0576;
        EffectTransform(ability_key, caster, target, is_card, fish);
    }

    function EffectTransformPhoenix(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectTransformPhoenix", ability_key, caster, target, is_card);
        bytes32 phoenix = 0x45a23f50c4a44900e19828c071b86545a4e54f3522a680d87ff84742258a9071;
        EffectTransform(ability_key, caster, target, is_card, phoenix);
    }

    function EffectSendDeck(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectSendDeck", ability_key, caster, target, is_card);
        EffectSendPile(ability_key, caster, target, is_card, PileType.Deck);
    }

    function EffectSendHand(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectSendHand", ability_key, caster, target, is_card);
        EffectSendPile(ability_key, caster, target, is_card, PileType.Hand);
    }

    function EffectShuffleDeck(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectShuffleDeck", ability_key, caster, target, is_card);
        if (is_card != ConditionTargetType.Card) {
            bytes32[] memory cards = CardTableLib.getValue(PileType.Deck, target);
            cards = shuffle(cards);
            CardTableLib.setValue(PileType.Deck, target, cards);
        }
    }

    function EffectClearTemp(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectClearTemp", ability_key, caster, target, is_card);
        if (is_card == ConditionTargetType.Card) {
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32[] memory empty = new bytes32[](0);
            CardTableLib.setValue(PileType.Temp, player_key, empty);
        }
    }


    function EffectCreateTemp(bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card) public {
        emit EventEffect("EffectCreateTemp", ability_key, caster, target, is_card);
        EffectCreate(ability_key, caster, target, is_card, PileType.Temp, false);
    }

    //----------------------------------------------------------------------------------------------------------------

    function EffectCreate(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, PileType create_pile, bool create_opponent) internal {
        if (is_card == ConditionTargetType.Card) {
            bytes32 card_config_id = CardOnBoards.getId(target);
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            bytes32 game_uid = Players.getGame(player_key);
            if (create_opponent) {
                player_key = GameLogicLib.GetOpponent(game_uid, player_key);
            }
            bytes32 card_uid = GameLogicLib.AddCard(player_key, card_config_id);
            GamesExtended.setLastSummoned(game_uid, card_uid);
            CardTableLib.pushValue(create_pile, player_key, card_uid);
        }
    }

    function shuffle(bytes32[] memory array) internal view returns (bytes32[] memory) {
        uint256 arrSize = array.length;
        bytes32[] memory shuffled = new bytes32[](arrSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < arrSize; i++) {
            shuffled[i] = array[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = arrSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffled[i];
            shuffled[i] = shuffled[j];
            shuffled[j] = temp;
        }

        return shuffled;
    }


    //把一张牌变为另一张牌
    function EffectTransform(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, bytes32 card_config_key) internal {
        if (is_card == ConditionTargetType.Card) {
            string memory card_name = Cards.getTid(card_config_key);
            CardOnBoards.setId(target, card_config_key);
            CardOnBoards.setName(target, card_name);
        }
    }

    //将卡牌移动到指定区域，手牌区、弃牌区、显示区等
    function EffectSendPile(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType is_card, PileType pile_type) internal {
        bytes32 player_key = CardOnBoards.getPlayerId(target);
        PlayerLogicLib.RemoveCardFromAllGroups(player_key, target);
        CardTableLib.pushValue(pile_type, player_key, target);
    }
}