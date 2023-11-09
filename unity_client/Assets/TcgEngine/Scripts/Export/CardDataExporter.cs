using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

#if UNITY_EDITOR
namespace TcgEngine
{
    public class CardDataExporter
    {
        [MenuItem("TcgEngine/Export CardData to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "CardData.csv"); // CSV文件保存路径

            CardData.Load(); // 加载数据
            
            List<CardData> cardList = new List<CardData>(CardData.card_dict.Values);

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine(
                    "ID,Title,Type,Team,Rarity,Mana,Attack,HP,Traits,Abilities,Text,Description,DeckBuilding,Cost,Packs,ArtFull,ArtBoard,SpawnFX,DeathFX,AttackFX,DamageFX,IdleFX,SpawnAudio,DeathAudio,AttackAudio,DamageAudio");

                // 写入数据行
                foreach (CardData cardData in cardList)
                {
                    string traits = "";
                    foreach (TraitData trait in cardData.traits)
                    {
                        traits += trait.id + "|";
                    }

                    traits = traits.TrimEnd('|');

                    string abilities = "";
                    foreach (AbilityData ability in cardData.abilities)
                    {
                        abilities += ability.id + "|";
                    }

                    abilities = abilities.TrimEnd('|');

                    string packs = "";
                    foreach (PackData pack in cardData.packs)
                    {
                        packs += pack.id + "|";
                    }

                    packs = packs.TrimEnd('|');
                    cardData.desc = cardData.desc.Replace("\"", "");

                    string art_full = (cardData.art_full != null) ? AssetDatabase.GetAssetPath(cardData.art_full) : "";
                    string art_board = (cardData.art_board != null) ? AssetDatabase.GetAssetPath(cardData.art_board) : "";

                    string spawn_fx = (cardData.spawn_fx != null) ? AssetDatabase.GetAssetPath(cardData.spawn_fx) : "";
                    string death_fx = (cardData.death_fx != null) ? AssetDatabase.GetAssetPath(cardData.death_fx) : "";
                    string attack_fx = (cardData.attack_fx != null) ? AssetDatabase.GetAssetPath(cardData.attack_fx) : "";
                    string damage_fx = (cardData.damage_fx != null) ? AssetDatabase.GetAssetPath(cardData.damage_fx) : "";
                    string idle_fx = (cardData.idle_fx != null) ? AssetDatabase.GetAssetPath(cardData.idle_fx) : "";

                    string spawn_audio = (cardData.spawn_audio != null) ? AssetDatabase.GetAssetPath(cardData.spawn_audio) : "";
                    string death_audio = (cardData.death_audio != null) ? AssetDatabase.GetAssetPath(cardData.death_audio) : "";
                    string attack_audio = (cardData.attack_audio != null) ? AssetDatabase.GetAssetPath(cardData.attack_audio) : "";
                    string damage_audio = (cardData.damage_audio != null) ? AssetDatabase.GetAssetPath(cardData.damage_audio) : "";
                    
                    sw.WriteLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},\"{10}\",{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25}",
                        cardData.id,
                        cardData.title,
                        cardData.type.ToString(),
                        cardData.team.name,
                        cardData.rarity.name,
                        cardData.mana,
                        cardData.attack,
                        cardData.hp,
                        traits,
                        abilities,
                        cardData.text.Replace("\"", ""),
                        cardData.desc,
                        cardData.deckbuilding.ToString(),
                        cardData.cost,
                        packs,
                        art_full,
                        art_board,
                        spawn_fx,
                        death_fx,
                        attack_fx,
                        damage_fx,
                        idle_fx,
                        spawn_audio,
                        death_audio,
                        attack_audio,
                        damage_audio));
                }
            }

            Debug.Log("CardData exported to CSV: " + filePath);
        }
    }
}
#endif