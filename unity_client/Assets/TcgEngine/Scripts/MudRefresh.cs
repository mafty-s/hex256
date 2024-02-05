using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using TcgEngine;
using UnityEngine;
using UnityEditor;
using LitJson;

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
    public int[] status;
    public string[] ability;
    public string[] trait;
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
            }

            if (mud_card.status.Length > 0)
            {
                foreach (var status in mud_card.status)
                {
                    StatusType s = MudEnum.CoverStatus((Mud.Status)status);
                    if (s != StatusType.None)
                    {
                        card.AddStatus(s, 1, 1);
                    }
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
            // new_card.equipped_uid = mud_card.equippedUid;

            Debug.Log("create card:" + mud_card.key + "=>" + mud_card.name + " player:" + player_id);
            // Debug.Log("当前手牌数量："+owner.cards_hand.Count);
            // owner.cards_hand.Add(new_card);
        }
    }
}