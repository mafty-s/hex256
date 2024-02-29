// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {CardOnBoards, PlayerCardsDiscard} from "../codegen/index.sol";
import {Games, Cards, Players, GamesExtended} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, Status, SelectorType, ConditionTargetType, AbilityTrigger} from "../codegen/common.sol";
import {CardPosLogicLib} from "../libs/CardPosLogicLib.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IAbilitySecretsSystem} from "../codegen/world/IAbilitySecretsSystem.sol";
import {ISlotSystem} from "../codegen/world/ISlotSystem.sol";

library GameLogicLib {


    function AddCard(bytes32 player_key, bytes32 card_config_key) internal returns (bytes32){

        uint8 i = Players.getNcards(player_key);
        bytes32 card_uid = keccak256(abi.encode(player_key, i));

//        CardsData memory card = Cards.get(card_config_key);

        CardOnBoards.setId(card_uid, card_config_key);
        CardOnBoards.setHp(card_uid, Cards.getHp(card_config_key));
        CardOnBoards.setAttack(card_uid, Cards.getAttack(card_config_key));
        CardOnBoards.setMana(card_uid, Cards.getMana(card_config_key));
        CardOnBoards.setPlayerId(card_uid, player_key);
        CardOnBoards.setName(card_uid, Cards.getTid(card_config_key));
        Players.setNcards(player_key, i + 1);

        return card_uid;
    }

    function KillCard(bytes32 game_uid, bytes32 attacker, bytes32 target) internal {
        if (attacker == 0 || target == 0) {
            return;
        }

        if (CardLogicLib.HasStatus(target, Status.Invincibility)) {
            return; //Cant be killed
        }

        DiscardCard(game_uid, target);
    }

    function DiscardCard(bytes32 game_uid, bytes32 card) internal {
        if (card == 0) {
            return;
        }

        if (CardPosLogicLib.IsInDiscard(card)) {
            return; //Already discarded
        }

        bytes32 icard = CardOnBoards.getId(card);
        bytes32 player = CardOnBoards.getPlayerId(card);

        bool was_on_board = CardPosLogicLib.IsOnBoard(card);//|| game_data.IsEquipped(card);

        //Remove card from board and add to discard
        PlayerLogicLib.RemoveCardFromAllGroups(player, card);
        PlayerCardsDiscard.pushValue(player, card);
        GamesExtended.setLastDestroyed(game_uid, card);
        SystemSwitch.call(
            abi.encodeCall(ISlotSystem.ClearCardFromSlot, (player, card))
        );

//        //Remove from bearer
//        Card bearer = player.GetBearerCard(card);
//        if (bearer != null)
//            bearer.equipped_uid = null;

        if (was_on_board)
        {
            //Trigger on death abilities
            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerCardAbilityType, (AbilityTrigger.ON_DEATH, game_uid, card, card, ConditionTargetType.Card))
            );
            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerOtherCardsAbilityType, (AbilityTrigger.ON_DEATH_OTHER, game_uid, card, card, ConditionTargetType.Card))
            );
            SystemSwitch.call(
                abi.encodeCall(IAbilitySecretsSystem.TriggerSecrets, (AbilityTrigger.ON_DEATH_OTHER, game_uid, card))
            );

        }

//        cards_to_clear.Add(card); //Will be Clear() in the next UpdateOngoing, so that simultaneous damage effects work
    }

    function DrawDiscardCard(bytes32 game_uid, bytes32 target, int8 nb) internal {
        //todo
    }

    function DamageCard(bytes32 game_uid, bytes32 target, uint8 value) internal {
        if (target == 0)
        {
            return;
        }
        if (CardLogicLib.HasStatus(target, Status.Invincibility))
        {
            return;//Invincible
        }

        if (CardLogicLib.HasStatus(target, Status.SpellImmunity))
        {
            return;//Spell immunity
        }
        CardOnBoards.setDamage(target, (int8)(value) + CardOnBoards.getDamage(target));
        if (CardLogicLib.GetHP(target) <= 0) {
            DiscardCard(game_uid, target);
        }
    }


    function DamageCardByTarget(bytes32 game_uid, bytes32 attacker, bytes32 target, int8 value, bool spell_damage) internal {
        if (CardLogicLib.HasStatus(target, Status.Invincibility)) {
            return;
        }
        bytes32 attack_card_config_key = CardOnBoards.getId(attacker);
        if (CardLogicLib.HasStatus(target, Status.SpellImmunity) && Cards.getCardType(attack_card_config_key) != CardType.Character) {
            return;
        }

        //Shell
        bool doublelife = CardLogicLib.HasStatus(target, Status.Shell);
        if (doublelife && value > 0) {
            CardLogicLib.RemoveStatus(target, Status.Shell);
            return;
        }

        //Armor
        if (!spell_damage && CardLogicLib.HasStatus(target, Status.Armor)) {
            //todo value = Mathf.Max(value - target.GetStatusValue(StatusType.Armor), 0);
        }

        //Damage
        int8 target_hp = CardOnBoards.getHp(target);
        int8 damage_max = value;
        if (damage_max > target_hp)
        {
            damage_max = target_hp;
        }
        CardOnBoards.setDamage(target, value + CardOnBoards.getDamage(target));

        //Remove sleep on damage
        CardLogicLib.RemoveStatus(target, Status.Sleep);

        //Kill card if no hp
        if (CardLogicLib.GetHP(target) <= 0) {
            KillCard(game_uid, attacker, target);
        }
    }

    function DamagePlayer(bytes32 game_uid, bytes32 attacker, bytes32 target, int8 value, bool spell_damage) internal {
        //Damage player
        int8 target_hp = Players.getHp(target);
        target_hp -= value;
        if (target_hp <= 0) {
            target = 0;
        }
        Players.setHp(target, target_hp);

        //Lifesteal
        bytes32 aplayer = CardOnBoards.getPlayerId(attacker);
        if (PlayerLogicLib.HasStatus(aplayer, Status.LifeSteal))
        {
            int8 hp = Players.getHp(aplayer);
            hp += value;
            Players.setHp(aplayer, hp);
        }
    }

    function UpdateOngoing() internal {
        //todo
    }

    function HealCard(bytes32 target, int8 value) internal {
        if (target == 0) {
            return;
        }
        if (CardLogicLib.HasStatus(target, Status.Invincibility)) {
            return;
        }
        int8 target_damage = CardOnBoards.getDamage(target);
        if (value >= target_damage) {
            target_damage = 0;
        } else {
            target_damage -= value;
        }
        CardOnBoards.setDamage(target, target_damage);
    }

    function EquipCard(bytes32 card, bytes32 equipment) internal {
        //todo
    }

    function CheckForWinner(bytes32 game_key) internal {
        uint8 count_alive = 0;
        bytes32 alive = 0;
        bytes32[] memory players = Games.getPlayers(game_key);
        for (uint8 i = 0; i < players.length; i++) {
            bytes32 player = players[i];
            if (!PlayerLogicLib.IsDead(player)) {
                alive = player;
                count_alive++;
            }
        }
        if (count_alive == 0) {
            EndGame(game_key, 0);//Everyone is dead, Draw
        } else if (count_alive == 1) {
            EndGame(game_key, alive);
        }
    }


    function EndGame(bytes32 game_key, bytes32 winner) internal {
        if (Games.getGameState(game_key) != GameState.GAME_ENDED) {
            Games.setGameState(game_key, GameState.GAME_ENDED);
            Games.setGamePhase(game_key, GamePhase.NONE);
            GamesExtended.setSelector(game_key, SelectorType.None);
            Games.setCurrentPlayer(game_key, winner);//winner
        }
    }

    function AttackPlayer(bytes32 attacker, bytes32 target, bool skip_cost) internal {
        //todo
    }

    function AttackTarget(bytes32 attacker, bytes32 target, bool skip_cost) internal {
        //todo
    }

    function ChangeOwner(bytes32 card_uid, bytes32 player_uid) internal {
        //todo
    }

////Heal a card
//public virtual void HealCard(Card target, int value)
//{
//if (target == null)
//return;
//
//if (target.HasStatus(StatusType.Invincibility))
//return;
//
//target.damage -= value;
//target.damage = Mathf.Max(target.damage, 0);
//}

    function CanPlayCard(bytes32 player_key, bytes32 card_key, bool skip_cost) internal view returns (bool) {

        if (card_key == 0)
            return false;
        //todo

//        if (!skip_cost && !player.CanPayMana(card))
//            return false; //Cant pay mana
//        if (!player.HasCard(player.cards_hand, card))
//            return false; // Card not in hand
//
//        if (card.CardData.IsBoardCard())
//        {
//            if (!slot.IsValid() || IsCardOnSlot(slot))
//                return false;   //Slot already occupied
//            if (Slot.GetP(card.player_id) != slot.p)
//                return false; //Cant play on opponent side
//            return true;
//        }
//        if (card.CardData.IsEquipment())
//        {
//            if (!slot.IsValid())
//                return false;
//
//            Card target = GetSlotCard(slot);
//            if (target == null || target.CardData.type != CardType.Character || target.player_id != card.player_id)
//        return false; //Target must be an allied character
//
//        return true;
//        }
//        if (card.CardData.IsRequireTargetSpell())
//        {
//            return IsPlayTargetValid(card, slot); //Check play target on slot
//        }
        return true;
    }

    function GetOpponent(bytes32 game_key, bytes32 player_key) internal view returns (bytes32) {
        bytes32[] memory players = Games.getPlayers(game_key);
        require(players.length == 2, "player count must be 2");
        require(players[0] != 0 && players[1] != 0, "player key must not be 0");
        require(players[0] != players[1], "player key must not be same");
        require(players[0] == player_key || players[1] == player_key, "player key must be in game");
        if (players[0] == player_key) {
            return players[1];
        } else {
            return players[0];
        }
    }

//    function GetOpponent(bytes32 game_uid, bytes32 player_key) internal returns (bytes32){
//        bytes32[] memory players = Games.getPlayers(game_uid);
//        for (uint8 i = 0; i < players.length; i++) {
//            if (players[i] != 0 && players[i] != player_key) {
//                return players[i];
//            }
//        }
//        return 0;
//    }

    function StartMainPhase(bytes32 game_uid) internal {
        if (Games.getGameState(game_uid) == GameState.GAME_ENDED) {
            return;
        }
        Games.setGamePhase(game_uid, GamePhase.MAIN);
    }

}