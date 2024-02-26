using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using TcgEngine;
using UnityEngine;
using UnityEditor;
using LitJson;
using Mud;
using SelectorType = TcgEngine.SelectorType;

[System.Serializable]
public class MudCardInfo
{
    public string name;
    public string key;
    public int slot;
    public int hp;
    public int hpOngoing;
    public int attack;
    public int attackOngoing;
    public int mana;
    public int manaOngoing;
    public int damage;
    public bool exhausted;
    public string equippedUid;
    public string id;
    public string playerId;
    public uint[] status;
    public uint[] ongoingStatus;
    public string[] ability;
    public uint[] trait;
}

public class MudPlayerInfo
{
    public string key;
    public string owner;
    public int hp;
    public int mana;
    public int hpMax;
    public int manaMax;
    public bool isAI;
    public int dcards;
    public string game;
    public string name;
    public string[] deck;
    public string[] status;
    public string[] hand;
    public string[] board;
    public string[] discard;
    public string[] equip;
    public string[] secret;
    public string[] temp;
    public uint[] trait;
}

[System.Serializable]
public class MudGame
{
    public int gameType;
    public int gameState;
    public int gamePhase;
    public string firstPlayer;
    public string currentPlayer;
    public int turnCount;
    public int nbPlayer;
    public string level;
    public string uid;
    public string[] players;
    public MudPlayerInfo[] player_objs;
    public MudCardInfo[] cards;

    public string lastPlayed;
    public string lastTarget;
    public string lastDestroyed;
    public string lastSummoned;
    public int rolledValue;
    public int selector;
    public string selectorPlayerId;
    public string selectorCasterUid;
    public string selectorAbility;
    public string selectorTrigger;

    public int getPlayerIndex(string player)
    {
        return Array.IndexOf(players, player);
    }

    public static MudGame FromJson(string str)
    {
        return JsonHelper.FromJson<MudGame>(str) as MudGame;
    }

    public MudPlayerInfo findPlayerByKey(string key)
    {
        foreach (var player in player_objs)
        {
            if (player.key == key)
            {
                return player;
            }
        }

        return null;
    }

    public MudCardInfo findCardByKey(string key)
    {
        foreach (var card in cards)
        {
            if (card.key == key)
            {
                return card;
            }
        }

        return null;
    }
}

public static class JsonHelper
{
    public static T FromJson<T>(string str)
    {
        T t = JsonMapper.ToObject<T>(str);
        ISupportInitialize iS = t as ISupportInitialize;
        if (iS == null)
        {
            return t;
        }

        iS.EndInit();
        return t;
    }

    public static object FromJson(Type type, string str)
    {
        object t = JsonMapper.ToObject<Type>(str);
        ISupportInitialize iS = t as ISupportInitialize;
        if (iS == null)
        {
            return t;
        }

        iS.EndInit();
        return t;
    }
}

public class MudRefresh
{
    public static void RefreshGame(MudGame mud_game, TcgEngine.Game gamedata)
    {
        gamedata.turn_count = mud_game.turnCount;
        gamedata.last_destroyed =
            mud_game.lastDestroyed == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.lastDestroyed;
        gamedata.last_summoned =
            mud_game.lastSummoned == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.lastSummoned;
        gamedata.last_played =
            mud_game.lastPlayed == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.lastPlayed;
        gamedata.last_summoned =
            mud_game.lastSummoned == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.lastSummoned;
        gamedata.last_target =
            mud_game.lastTarget == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.lastTarget;

        gamedata.rolled_value = mud_game.rolledValue;
        gamedata.state = MudEnum.ConvertGameState((Mud.GameState)mud_game.gameState);
        gamedata.phase = MudEnum.ConvertGamePhase((Mud.GamePhase)mud_game.gamePhase);

        gamedata.selector = MudEnum.ConvertSelectorType((Mud.SelectorType)mud_game.selector);
        gamedata.selector_ability_id =
            mud_game.selectorAbility == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.selectorAbility;
        gamedata.selector_caster_uid =
            mud_game.selectorCasterUid == "0x0000000000000000000000000000000000000000000000000000000000000000"
                ? null
                : mud_game.selectorCasterUid;
        gamedata.selector_player_id = mud_game.getPlayerIndex(mud_game.selectorPlayerId);
        gamedata.first_player = mud_game.getPlayerIndex(mud_game.firstPlayer);
        gamedata.current_player = mud_game.getPlayerIndex(mud_game.currentPlayer);


        foreach (var card in mud_game.cards)
        {
            RefreshCard(card, gamedata.GetCard(card.key), gamedata, mud_game);
        }

        foreach (var player in mud_game.player_objs)
        {
            int id = getPlayerIdFromName(player.name, gamedata);
            Debug.Log("find player" + player.name + ":" + id);
            if (id != -1)
            {
                RefreshPlayer(player, gamedata.GetPlayer(id), gamedata);
            }
        }
    }

    public static int getPlayerIdFromName(string name, TcgEngine.Game gamedata)
    {
        for (int i = 0; i < gamedata.players.Length; i++)
        {
            if (gamedata.players[i].username == name)
            {
                return i;
            }
        }

        return -1;
    }

    public static void RefreshPlayer(MudPlayerInfo mud_player, TcgEngine.Player player, TcgEngine.Game gamedata)
    {
        Debug.Log("RefreshPlayer");
        Debug.Log(player.mana);
        Debug.Log(mud_player.mana);
        player.hp = mud_player.hp;
        player.hp_max = mud_player.hpMax;
        player.mana = mud_player.mana;
        player.mana_max = mud_player.manaMax;
        player.is_ai = mud_player.isAI;

        player.cards_deck.Clear();
        foreach (var card in mud_player.deck)
        {
            player.cards_deck.Add(gamedata.GetCard(card));
        }

        player.cards_hand.Clear();
        foreach (var card in mud_player.hand)
        {
            player.cards_hand.Add(gamedata.GetCard(card));
        }

        player.cards_discard.Clear();
        foreach (var card in mud_player.discard)
        {
            player.cards_discard.Add(gamedata.GetCard(card));
        }

        player.cards_equip.Clear();
        foreach (var card in mud_player.equip)
        {
            player.cards_equip.Add(gamedata.GetCard(card));
        }

        player.cards_secret.Clear();
        foreach (var card in mud_player.secret)
        {
            player.cards_secret.Add(gamedata.GetCard(card));
        }

        player.cards_temp.Clear();
        foreach (var card in mud_player.temp)
        {
            player.cards_temp.Add(gamedata.GetCard(card));
        }

        player.cards_board.Clear();
        foreach (var card in mud_player.board)
        {
            player.cards_board.Add(gamedata.GetCard(card));
        }

        // player.history_list.Clear();
    }

    public static void RefreshCard(MudCardInfo mud_card, TcgEngine.Card card, TcgEngine.Game gamedata, MudGame gameinfo)
    {
        Debug.Log("RefreshCard" + mud_card.key);
        if (card != null)
        {
            Debug.Log("find card:" + mud_card.key + "=>" + mud_card.name);
            card.hp = mud_card.hp;
            card.hp_ongoing = mud_card.hpOngoing;
            card.attack = mud_card.attack;
            card.attack_ongoing = mud_card.attackOngoing;
            card.mana = mud_card.mana;
            card.mana_ongoing = mud_card.manaOngoing;
            card.damage = mud_card.damage;
            card.exhausted = mud_card.exhausted;
            // card.equipped_uid = mud_card.equippedUid;
            //card.player_id = mud_card.playerId;

            if (mud_card.equippedUid != "0x0000000000000000000000000000000000000000000000000000000000000000")
            {
                Card equiped = gamedata.GetCard(mud_card.equippedUid);
                card.equipped_uid = mud_card.equippedUid;
            }
            else
            {
                card.equipped_uid = null;
            }

            if (mud_card.status.Length > 0)
            {
                card.status.Clear();
                foreach (var status in mud_card.status)
                {
                    (uint status_id, uint duration, uint value, uint unuse) = MudEnum.SplitUint32(status);

                    StatusType s = MudEnum.CoverStatus((Mud.Status)status_id);
                    if (s != StatusType.None)
                    {
                        duration = 10000;
                        Debug.Log("status:" + status_id + " duration:" + (int)duration + " value" + (int)value +
                                  " card_key: " +
                                  mud_card.key + " name:" + mud_card.name);
                        card.AddStatus(s, (int)value, (int)duration);
                    }
                }
            }

            if (mud_card.ongoingStatus.Length > 0)
            {
                card.ongoing_status.Clear();
                foreach (var status in mud_card.ongoingStatus)
                {
                    (uint status_id, uint duration, uint value, uint unuse) = MudEnum.SplitUint32(status);

                    StatusType s = MudEnum.CoverStatus((Mud.Status)status_id);
                    if (s != StatusType.None)
                    {
                        Debug.Log("ongoing status:" + status_id + " value" + (int)value + " card_key: " +
                                  mud_card.key + " name:" + mud_card.name);
                        card.AddOngoingStatus(s, (int)value);
                    }
                }
            }

            if (mud_card.trait.Length > 0)
            {
                card.traits.Clear();
                foreach (var trait in mud_card.trait)
                {
                    (uint trait_id, uint trait_value) = MudEnum.SplitUint16(trait);
                    string traitName = MudEnum.GetTraitById((Mud.CardTrait)(trait_id));
                    Debug.Log("trait:" + trait_id + " value:" + (int)trait_value + " card_key: " +
                              mud_card.key + " card_name:" + mud_card.name + " traitName:" + traitName);
                    card.AddTrait(traitName,(int)(trait_value));
                }
            }
        }
        else
        {
            MudPlayerInfo mudPlayerInfo = gameinfo.findPlayerByKey(mud_card.playerId);
            if (mudPlayerInfo == null)
            {
                Debug.Log("mud player not found:" + mud_card.playerId);
                return;
            }

            int player_id = getPlayerIdFromName(mudPlayerInfo.name, gamedata);

            Player owner = gamedata.GetPlayer(player_id);
            CardData config = CardData.Get(mud_card.name);
            if (config == null)
            {
                Debug.Log("card config not found:" + mud_card.name);
                return;
            }

            if (owner == null)
            {
                Debug.Log("player is null:" + player_id + "=>" + mud_card.playerId);
                return;
            }

            VariantData variant = VariantData.GetDefault();
            Card new_card = Card.Create(config, variant, owner, mud_card.key);


            new_card.hp = mud_card.hp;
            new_card.hp_ongoing = mud_card.hpOngoing;
            new_card.attack = mud_card.attack;
            new_card.attack_ongoing = mud_card.attackOngoing;
            new_card.mana = mud_card.mana;
            new_card.mana_ongoing = mud_card.manaOngoing;
            new_card.damage = mud_card.damage;
            new_card.exhausted = mud_card.exhausted;
            if (mud_card.slot != 0)
            {
                int x = SlotEncoderDecoder.DecodeSlotX(mud_card.slot);
                int y = SlotEncoderDecoder.DecodeSlotY(mud_card.slot);
                int p = SlotEncoderDecoder.DecodeSlotP(mud_card.slot);

                Debug.Log("x=" + x + " y=" + y + " p=" + p);
                new_card.slot = new Slot(x, y, p);
            }
            // new_card.equipped_uid = mud_card.equippedUid;

            Debug.Log("create card:" + mud_card.key + "=>" + mud_card.name + " player:" + player_id);
            // Debug.Log("当前手牌数量："+owner.cards_hand.Count);
            // owner.cards_hand.Add(new_card);
        }
    }
}

public class SlotEncoderDecoder
{
    // public static ushort EncodeSlot(Slot slot)
    // {
    //     return (ushort)(slot.x + (slot.y * 10) + (slot.p * 100));
    // }

    public static int DecodeSlotX(int slot)
    {
        return (slot % 10);
    }

    public static int DecodeSlotY(int slot)
    {
        return ((slot / 10) % 10);
    }

    public static int DecodeSlotP(int slot)
    {
        return (slot / 100);
    }
}