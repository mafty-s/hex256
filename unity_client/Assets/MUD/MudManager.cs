using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEditor;
using System.Threading.Tasks;
using TcgEngine;


[System.Serializable]
public class MudGameExtend
{
    public int selector;
    public string selectorCasterUid;
    public string selectorPlayerId;
    public string selectorAbility;
}

[System.Serializable]
public class MudPlayCard
{
    public string card_uid;
    public int slot_x;
    public int slot_y;
    public int slot_p;
    public int mana_cost;
    public int player_mana;
}

[System.Serializable]
public class MudCard
{
    public string card_uid;
    public int hp;
    public int mana;
    public int attack;
    public int damage;
}


[System.Serializable]
public class MovePlayCard
{
    public string card_uid;
    public int slot_x;
    public int slot_y;
    public int slot_p;
}


[System.Serializable]
public class MudUserData
{
    public string owner;
    public int coin;
    public int xp;
    public int createdAt;
    public string[] cards;
    public string[] packs;
    public string id;
    public string avatar;
    public string cardback;
}


[System.Serializable]
public class MudGameSettingResult
{
    public string game_uid;
}


[System.Serializable]
public class MudPlayerSettingResult
{
    public string player_name;
    public string[] cards;
    public string[] hand;
    public string[] deck;
    public string[] board;
    public string[] all;
    public int mana;
    public int hp;
}


[System.Serializable]
public class MudEndTurnResult
{
    public string operator_player_key;
    public string opponent_player_key;
    public string board_card_key;
    public int mana;
    public int mana_max;
}

[System.Serializable]
public class MudAttackCardResult
{
    public string attacker_uid;
    public string target_uid;
}

[System.Serializable]
public class MudAttackPlayerResult
{
    public string attacker_uid;
    public int target_id;
}


[System.Serializable]
public class MudMatchingResult
{
    public int game;
    public string[] players;
    public int nb_players;
}

[System.Serializable]
public class MudActionHistory
{
    public ushort type;
    public string card_uid;
    public string target_uid;
    public int slot_x;
    public int slot_y;
    public int slot_p;
    public int player_id;
    public int value;
}


public class MudManager : MonoBehaviour
{
    public bool useMud = false;

    private static MudManager instance;
    public string msg = "";
    private Dictionary<string, string> names = new Dictionary<string, string>();

    public static MudManager Get()
    {
        return instance;
    }

    void Awake()
    {
        instance = this;
        DontDestroyOnLoad(gameObject);
    }

    // export enum Status {
    //     None,
    //     Armor,
    //     Attack,
    //     Deathtouch,
    //     Flying,
    //     Fury,
    //     Hp,
    //     Intimidate,
    //     Invicibility,
    //     Lifesteal,
    //     Paralysed,
    //     Poisoned,
    //     Protected,
    //     Shell,
    //     Silenced,
    //     Sleep,
    //     SpellImmunity,
    //     Stealth,
    //     Taunt,
    //     Trample,
    // }


    public static StatusType GetStatusTypeByInt(int code)
    {
        switch (code)
        {
            case 0:
                return StatusType.None;
            case 1:
                return StatusType.Armor;
            // case 2:
            // return StatusType.Attack;
        }

        return StatusType.None;
    }

    public static string GetCommandString(ushort code)
    {
        switch (code)
        {
            case 0:
                return "None";
            case 1000:
                return "PlayCard";
            case 1010:
                return "Attack";
            case 1012:
                return "AttackPlayer";
            case 1015:
                return "Move";
            case 1020:
                return "CastAbility";
            case 1030:
                return "SelectCard";
            case 1032:
                return "SelectPlayer";
            case 1034:
                return "SelectSlot";
            case 1036:
                return "SelectChoice";
            case 1039:
                return "CancelSelect";
            case 1040:
                return "EndTurn";
            case 1050:
                return "Resign";
            case 1090:
                return "ChatMessage";
            case 1100:
                return "PlayerSettings";
            case 1102:
                return "PlayerSettingsAI";
            case 1105:
                return "GameSettings";
            case 2000:
                return "Connected";
            case 2001:
                return "PlayerReady";
            case 2010:
                return "GameStart";
            case 2012:
                return "GameEnd";
            case 2015:
                return "NewTurn";
            case 2020:
                return "CardPlayed";
            case 2022:
                return "CardSummoned";
            case 2023:
                return "CardTransformed";
            case 2025:
                return "CardDiscarded";
            case 2026:
                return "CardDrawn";
            case 2027:
                return "CardMoved";
            case 2030:
                return "AttackStart";
            case 2032:
                return "AttackEnd";
            case 2034:
                return "AttackPlayerStart";
            case 2036:
                return "AttackPlayerEnd";
            case 2040:
                return "AbilityTrigger";
            case 2042:
                return "AbilityTargetCard";
            case 2043:
                return "AbilityTargetPlayer";
            case 2044:
                return "AbilityTargetSlot";
            case 2048:
                return "AbilityEnd";
            case 2060:
                return "SecretTriggered";
            case 2061:
                return "SecretResolved";
            case 2070:
                return "ValueRolled";
            case 2190:
                return "ServerMessage";
            case 2100:
                return "RefreshAll";
            default:
                return "Unknown";
        }
    }

#if !UNITY_EDITOR && UNITY_WEBGL
    [DllImport("__Internal")]
    private static extern bool hasMudInstalled();

    [DllImport("__Internal")]
    private static extern void addTask(string msg);
    
    [DllImport("__Internal")]
    private static extern void getUser();

    [DllImport("__Internal")]
    private static extern void doApiTask(string url,string json_data);
    
    [DllImport("__Internal")]
    private static extern void buyCard(string card_id,int q);

    [DllImport("__Internal")]
    private static extern void sellCard(string card_id,int q);

    [DllImport("__Internal")]
    private static extern void buyPack(string pack_id,int q);
    
    [DllImport("__Internal")]
    private static extern void openPack(string pack_id);

    [DllImport("__Internal")]
    private static extern string calculateKeccak256Hash(string name);

    [DllImport("__Internal")]
    private static extern string gameSetting(string game_uid);
    
    [DllImport("__Internal")]
    private static extern string playerSetting(string username, string game_uid, string deck_id,bool is_ai,int hp,int mana,int dcards,int pid,bool shuffer);
    
    [DllImport("__Internal")]
    private static extern string playCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,bool skip_cost,string card_key);

    [DllImport("__Internal")]
    private static extern string moveCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,bool skip_cost,string card_key);

    [DllImport("__Internal")]
    private static extern string saveDeck(string tid, string name, string cards);
    
    [DllImport("__Internal")]
    private static extern string attackCard(string game_id, string player_id, string attacker_id,string target_id);

    [DllImport("__Internal")]
    private static extern string attackPlayer(string game_id, string cardkey, int target_id);

    [DllImport("__Internal")]
    private static extern string endTurn(string game_uid,string player_name,int player_id);

    [DllImport("__Internal")]
    private static extern string startMatchmaking(string game_uid, int nb_players);
    
    [DllImport("__Internal")]
    private static extern string checkMatchmaking(int match_id);
    
    [DllImport("__Internal")]
    private static extern string checkPlayerSetting(string player_name,string game_uid);
    
    [DllImport("__Internal")]
    private static extern string checkAction(string player_name,string game_uid);
    
    [DllImport("__Internal")]
    private static extern string selectCard(string game_uid,string card_id,string card_uid);
    
    [DllImport("__Internal")]
    private static extern string selectPlayer(string game_uid,string player_id);
    
    [DllImport("__Internal")]
    private static extern string selectSlot(string game_uid,int slot_x,int slot_y,int slot_p);
    
    [DllImport("__Internal")]
    private static extern string selectChoice(string game_uid,int choice);
    
    [DllImport("__Internal")]
    private static extern string cancelSelection(string game_uid);
    
    [DllImport("__Internal")]
    private static extern string castAbility(string game_uid,string caster,string ability);
    
    [DllImport("__Internal")]
    private static extern string resign(string player);
    
    [DllImport("__Internal")]
    private static extern string walletAddress();
    
#endif

    public static void SendTask(ushort code)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        string msg = GetCommandString(code);
            addTask(msg);
#endif
    }

    void Start()
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        this.useMud = hasMudInstalled();

        if (useMud == false)
        {
            return;
        }
        getUser();

        CardData.Load(); // 加载数据

        List<CardData> cardList = new List<CardData>(CardData.card_dict.Values);
        foreach (CardData cardData in cardList)
        {
            names.Add(calculateKeccak256Hash(cardData.id), cardData.id);
        }
        
        PackData.Load(); // 加载数据

        List<PackData> packList = new List<PackData>(PackData.pack_list);
        foreach (PackData packData in packList)
        {
            names.Add(calculateKeccak256Hash(packData.id), packData.id);
        }
#endif
    }

    public bool HasMudInstalled()
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        return hasMudInstalled();
#endif
        return false;
    }

    public void OnUser(string msg)
    {
        if (useMud == false)
        {
            return;
        }

        this.msg = msg;
        // Debug.Log("user from MudManager onUser :" + msg);
    }

    public void PrintUser()
    {
        if (useMud == false)
        {
            return;
        }

        Debug.Log(this.msg);
    }



    
    public MudUserData GetUserData()
    {
        if (useMud == false)
        {
            return null;
        }

        if (this.msg == "")
        {
            return null;
        }

        MudUserData playerData = JsonUtility.FromJson<MudUserData>(this.msg);

        // Access the decoded data
        // Debug.Log("Owner: " + playerData.owner);
        // Debug.Log("Coins: " + playerData.coin);
        // Debug.Log("XP: " + playerData.xp);
        // Debug.Log("Created At: " + playerData.createdAt);
        // Debug.Log("ID: " + playerData.id);
        // Debug.Log("Avatar: " + playerData.avatar);
        // Debug.Log("Cardback: " + playerData.cardback);

        return playerData;
    }

    public void BuyCard(string card_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        buyCard(card_id,q);
#endif
    }

    public void SellCard(string card_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        sellCard(card_id,q);
#endif
    }

    public void BuyPack(string pack_id, int q)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        buyPack(pack_id,q);
#endif
    }

    public void OpenPack(string pack_id)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        openPack(pack_id);
#endif
    }

    public void DoApiTask(string url, string json_data)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        doApiTask(url,json_data);
#endif
    }

    public void GameSetting(string game_uid, int nb_players, string level)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        gameSetting(game_uid);
#endif
    }

    public void PlayerSetting(string username, string game_uid, string deck_id, bool is_ai, int hp, int mana,
        int dcards, int pid, bool shuffer)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        playerSetting(username,game_uid,deck_id,is_ai,hp,mana,dcards,pid,shuffer);
#endif
    }

    public string GetCardIdByHex(string hex)
    {
        if (names.ContainsKey(hex))
        {
            return names[hex];
        }
        else
        {
            return "Unknown";
        }
    }

    //game_id, player_id, card_id, slot, skip_cost
    public void PlayCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,
        bool skip_cost, string card_key)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        playCard(game_id,player_id,card_id,slot_x,slot_y,slot_p,skip_cost,card_key);
#endif
    }

    public void MoveCard(string game_id, string player_id, string card_id, int slot_x, int slot_y, int slot_p,
        bool skip_cost, string card_key)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        moveCard(game_id,player_id,card_id,slot_x,slot_y,slot_p,skip_cost,card_key);
#endif
    }

    public void AttackCard(string game_id, string player_id, string attacker_id, string target_id)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        attackCard(game_id,player_id,attacker_id,target_id);
#endif
    }

    public void AttackPlayer(string game_uid, string attacker_id, int target_id)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        attackPlayer(game_uid,attacker_id,target_id);
#endif
    }

    public void CastAbility()
    {
    }

    public void EndTurn(string game_uid, string player_name, int player_id)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        endTurn(game_uid,player_name,player_id);
#endif
    }

    public void SaveDeck(string tid, string hero, string cards)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        saveDeck(tid,hero,cards);
#endif
    }

    public void StartMatchmaking(string game_uid, int nb_players)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        startMatchmaking(game_uid,nb_players);
#endif
    }

    public void CheckMatchmaking(int match_id)
    {
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        checkMatchmaking(match_id);
#endif
    }

    public void CheckPlayerSetting(string player_name, string game_uid)
    {
        Debug.Log("CheckPlayerSetting:" + player_name + "," + game_uid);
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
        checkPlayerSetting(player_name,game_uid);
#endif
    }

    public void CheckAction(string player_name, string game_uid)
    {
        //Debug.Log("CheckAction:" + player_name + "," + game_uid);
        if (useMud == false)
        {
            return;
        }
#if !UNITY_EDITOR && UNITY_WEBGL
            checkAction(player_name,game_uid);
#endif
    }

    public void SelectCard(string game_uid, string card_id, string card_key)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        selectCard(game_uid,card_id,card_key);
#endif
    }

    public void SelectPlayer(string game_uid, string player_id)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        selectPlayer(game_uid,player_id);
#endif
    }

    public void SelectSlot(string game_uid, int slot_x, int slot_y, int slot_p)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        selectSlot(game_uid,slot_x,slot_y,slot_p);
#endif
    }

    public void SelectChoice(string game_uid, int choice)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        selectChoice(game_uid,choice);
#endif
    }

    public void CancelSelection(string game_uid)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        cancelSelection(game_uid);
#endif
    }
    
    public void CastAbility(string game_uid,string caster, string ability)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        castAbility(game_uid,caster,ability);
#endif
    }

    public void Resign(string player)
    {
#if !UNITY_EDITOR && UNITY_WEBGL
        resign(player);
#endif
    }
    
    public string  getWalletAddress()
    {
#if !UNITY_EDITOR && UNITY_WEBGL
       return walletAddress();
#endif
        return "";
    }

}