using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

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
                    "ID,Title,Type,Team,Rarity,Mana,Attack,HP,Traits,Abilities,Text,Description,DeckBuilding,Cost,Packs");

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

                    sw.WriteLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14}",                        cardData.id,
                        cardData.title,
                        cardData.type.ToString(),
                        cardData.team.name,
                        cardData.rarity.name,
                        cardData.mana,
                        cardData.attack,
                        cardData.hp,
                        traits,
                        abilities,
                        cardData.text,
                        cardData.desc,
                        cardData.deckbuilding.ToString(),
                        cardData.cost,
                        packs));
                }
            }

            Debug.Log("CardData exported to CSV: " + filePath);
        }
    }
}