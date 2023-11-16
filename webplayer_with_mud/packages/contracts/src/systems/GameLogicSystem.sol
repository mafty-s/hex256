// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Matches, MatchesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayersCard, PlayersCardData} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {GameType, GameState, GamePhase} from "../codegen/common.sol";
import {SlotData} from "../codegen/index.sol";


contract GameLogicSystem is System {

    constructor() {

    }


    ///////////////////CARD LOGIC///////////////////////


    function GetAttack(CardOnBoardsData memory card) public pure returns (uint256) {
        return card.attack + card.attackOngoing;
    }

    function GetHP(CardOnBoardsData memory card) public pure returns (uint256) {
        return card.hp + card.hpOngoing - card.damage;
    }

    function GetHPMax(CardOnBoardsData memory card) public pure returns (uint256) {
        return card.hp + card.hpOngoing;
    }

    function GetMana(CardOnBoardsData memory card) public pure returns (uint256) {
        return card.mana + card.manaOngoing;
    }




    ///////////////////PLAYER LOGIC///////////////////////


    function CanPayMana(PlayersData memory player, CardOnBoardsData memory card) public pure returns (bool) {
        return player.mana > card.mana;
    }


    function PayMana(bytes32 player_key, bytes32 card_key) public {
        PlayersData memory player = Players.get(player_key);
        Players.setMana(player_key, player.mana - Cards.get(card_key).mana);
    }
    ///////////////////GAME LOGIC///////////////////////

    //public virtual void SetPlayerDeck(Player player, DeckData deck)

    //    function SetPlayerDeck(PlayersCardData player, DecksData memory deck) public {
    //
    //    }

    function CanPlayCard(PlayersData memory player, CardOnBoardsData memory card, SlotData memory slot, bool skip_cost) public pure returns (bool) {
        if (card.id == 0) {
            return false;
        }
        if (!skip_cost && !CanPayMana(player, card)) {
            return false;
        }
        //        if (card.slot != 0) {
        //            return false;
        //        }
        //        if (slot.p != card.p) {
        //            return false;
        //        }
        return true;
    }

    function CanMoveCard(PlayersData memory player, CardOnBoardsData memory card, SlotData memory slot) public pure returns (bool) {
        if (card.id == 0) {
            return false;
        }
        //        if (card.slot == 0) {
        //            return false;
        //        }
        //        if (card.slot.p != slot.p) {
        //            return false;
        //        }
        //        if (card.slot.x == slot.x && card.slot.y == slot.y) {
        //            return false;
        //        }
        return true;
    }

    function CanAttackTarget(CardOnBoardsData memory card, CardOnBoardsData memory target) public pure returns (bool){
        return true;
    }

    function GameSetting(string memory game_uid) public returns (bytes32 key)  {
        key = keccak256(abi.encode(game_uid));
        Matches.set(key, MatchesData({gameType : GameType.SOLO, gameState : GameState.INIT, gamePhase : GamePhase.NONE, uid : game_uid, firstPlayer : 0, currentPlayer : 0, turnCount : 0, players : new bytes32[](0)}));
    }

    function PlayerSetting(string memory username, string memory game_uid, string memory desk_id, bool is_ai) public {

        bytes32 desk_key = keccak256(abi.encode(desk_id));
        bytes32 match_key = keccak256(abi.encode(game_uid));
        bytes32 player_key = keccak256(abi.encode(game_uid, username));

        //        DecksData memory deck = Decks.get(desk_key);

        Matches.pushPlayers(match_key, player_key);
        Players.set(player_key, PlayersData({owner : address(0), hp : 0, mana : 0, hpMax : 0, manaMax : 0, name : username, deck : desk_id, isAI : is_ai}));


        bytes32[] memory cards = Decks.getCards(desk_key);
        for (uint i = 0; i < cards.length; i++) {
            bytes32 card_key = keccak256(abi.encode(cards[i], player_key));
            CardsData memory card = Cards.get(cards[i]);
            CardOnBoards.set(card_key, CardOnBoardsData({id : card_key, name : card.tid, hp : card.hp, hpOngoing : 0, attack : card.attack, attackOngoing : 0, mana : card.mana, manaOngoing : 0, damage : 0, exhausted : false, equippedUid : 0, playerId : player_key}));
            PlayersCard.pushCardsDeck(player_key, card_key);
        }


        if (Matches.getPlayers(match_key).length == 2) {
            StartGame(game_uid);
        }

    }

    function PlayCard(bytes32 card_key, SlotData memory slot, bool skip_cost) public {
        //        if (game_data.CanPlayCard(card, slot, skip_cost))
        //        {
        //            Player player = game_data.GetPlayer(card.player_id);
        //
        //            //Cost
        //            if (!skip_cost)
        //                player.PayMana(card);
        //
        //            //Play card
        //            player.RemoveCardFromAllGroups(card);
        //
        //            //Add to board
        //            CardData icard = card.CardData;
        //            if (icard.IsBoardCard())
        //            {
        //                player.cards_board.Add(card);
        //                card.slot = slot;
        //                card.exhausted = true; //Cant attack first turn
        //            }
        //            else if (icard.IsEquipment())
        //            {
        //                Card bearer = game_data.GetSlotCard(slot);
        //                EquipCard(bearer, card);
        //                card.exhausted = true;
        //            }
        //            else if (icard.IsSecret())
        //            {
        //                player.cards_secret.Add(card);
        //            }
        //            else
        //            {
        //                player.cards_discard.Add(card);
        //                card.slot = slot; //Save slot in case spell has PlayTarget
        //            }
        //
        //            //History
        //            if(!is_ai_predict && !icard.IsSecret())
        //                player.AddHistory(GameAction.PlayCard, card);
        //
        //            //Update ongoing effects
        //            game_data.last_played = card.uid;
        //            UpdateOngoing();
        //
        //            //Trigger abilities
        //            TriggerSecrets(AbilityTrigger.OnPlayOther, card); //After playing card
        //            TriggerCardAbilityType(AbilityTrigger.OnPlay, card);
        //            TriggerOtherCardsAbilityType(AbilityTrigger.OnPlayOther, card);
        //
        //            onCardPlayed?.Invoke(card, slot);
        //            resolve_queue.ResolveAll(0.3f);
    }

    function AttackTarget(bytes32 card_key, bytes32 target_key, uint8 slot) public {

    }


    function AttackPlayer(bytes32 card_key, uint8 slot) public {

    }

    function Move(bytes32 card_key, uint8 slot) public {
        //        if (game_data.CanMoveCard(card, slot, skip_cost))
        //        {
        //            card.slot = slot;
        //
        //            //Moving doesn't really have any effect in demo so can be done indefinitely
        //            //if(!skip_cost)
        //            //card.exhausted = true;
        //            //card.RemoveStatus(StatusEffect.Stealth);
        //            //player.AddHistory(GameAction.Move, card);
        //
        //            //Also move the equipment
        //            Card equip = game_data.GetEquipCard(card.equipped_uid);
        //            if (equip != null)
        //                equip.slot = slot;
        //
        //            UpdateOngoing();
        //
        //            onCardMoved?.Invoke(card, slot);
        //            resolve_queue.ResolveAll(0.2f);
        //        }
    }

    function EndTurn(bytes32 card_key, uint8 slot) public {

    }

    function ShuffleDeck(bytes32[] memory cards) public view returns (bytes32[] memory) {
        uint256 deckSize = cards.length;
        bytes32[] memory shuffledDeck = new bytes32[](deckSize);

        // Copy the original deck to the shuffled deck array
        for (uint256 i = 0; i < deckSize; i++) {
            shuffledDeck[i] = cards[i];
        }

        // Shuffle the deck using Fisher-Yates algorithm
        for (uint256 i = deckSize - 1; i > 0; i--) {
            uint256 j = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, i))) % (i + 1);
            bytes32 temp = shuffledDeck[i];
            shuffledDeck[i] = shuffledDeck[j];
            shuffledDeck[j] = temp;
        }

        return shuffledDeck;
    }


    function EndGame() public {

    }

    function RemoveCardFromAllGroups(bytes32 player_key, bytes32 card_key) public {

    }


    function UpdateOngoing() public {

    }

    function StartGame(string memory game_uid) internal {

        bytes32 match_key = keccak256(abi.encode(game_uid));
        if (Matches.get(match_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }

        bytes32[] memory player_keys = Matches.getPlayers(match_key);

        //Choose first player
        Matches.setGameState(match_key, GameState.PLAY);
        Matches.setFirstPlayer(match_key, player_keys[uint8(block.prevrandao % 2)]);
        Matches.setCurrentPlayer(match_key, Matches.getFirstPlayer(match_key));
        Matches.setTurnCount(match_key, 1);

        //Init each players

        for (uint8 i = 0; i < player_keys.length; i++) {
            bytes32 player_key = player_keys[i];
            PlayersData memory player = Players.get(player_key);
            Players.setHp(player_key, player.hpMax);
            Players.setMana(player_key, player.manaMax);
            //            PlayersCard.setCardsHand(player_key, new bytes32[](0));
            //            PlayersCard.setCardsBoard(player_key, new bytes32[](0));
            //            PlayersCard.setCardsEquip(player_key, new bytes32[](0));
            //            PlayersCard.setCardsDiscard(player_key, new bytes32[](0));

            DrawCard(player_key, 5);
        }


        //Start state
        StartTurn(match_key);

    }


    function DrawCard(bytes32 player_key, uint nb) internal {
        for (uint i = 0; i < nb; i++) {
            bytes32[] memory cards = PlayersCard.getCardsDeck(player_key);
            bytes32 card_key = cards[cards.length - 1];
            PlayersCard.popCardsDeck(player_key);
            PlayersCard.pushCardsHand(player_key, card_key);
        }
    }

    function StartTurn(bytes32 match_key) internal {
        if (Matches.get(match_key).gameState == GameState.GAME_ENDED) {
            revert("Game already ended");
        }
        ClearTurnData();
        Matches.setGamePhase(match_key, GamePhase.START_TURN);
        //
        //        Player player = game_data.GetActivePlayer();
        //
        //        //Cards draw
        //        if (game_data.turn_count > 1 || player.player_id != game_data.first_player)
        //        {
        //            DrawCard(player, GameplayData.Get().cards_per_turn);
        //        }
        //
        //        //Mana
        //        player.mana_max += GameplayData.Get().mana_per_turn;
        //        player.mana_max = Mathf.Min(player.mana_max, GameplayData.Get().mana_max);
        //        player.mana = player.mana_max;
        //
        //        //Turn timer and history
        //        game_data.turn_timer = GameplayData.Get().turn_duration;
        //        player.history_list.Clear();
        //
        //        //Player poison
        //        if (player.HasStatus(StatusType.Poisoned))
        //            player.hp -= player.GetStatusValue(StatusType.Poisoned);
        //
        //        if (player.hero != null)
        //            player.hero.Refresh();
        //
        //        //Refresh Cards and Status Effects
        //        for (int i = player.cards_board.Count - 1; i >= 0; i--)
        //        {
        //            Card card = player.cards_board[i];
        //
        //            if(!card.HasStatus(StatusType.Sleep))
        //                card.Refresh();
        //
        //            if (card.HasStatus(StatusType.Poisoned))
        //                DamageCard(card, card.GetStatusValue(StatusType.Poisoned));
        //        }
        //
        //        //Ongoing Abilities
        //        UpdateOngoing();
        //
        //        //StartTurn Abilities
        //        TriggerPlayerCardsAbilityType(player, AbilityTrigger.StartOfTurn);
        //        TriggerPlayerSecrets(player, AbilityTrigger.StartOfTurn);
        //
        //        resolve_queue.AddCallback(StartMainPhase);
        //        resolve_queue.ResolveAll(0.2f);

    }

    function ClearTurnData() internal {

    }


}