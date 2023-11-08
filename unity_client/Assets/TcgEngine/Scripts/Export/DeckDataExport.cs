using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public class DeckDataExport
    {
        [MenuItem("TcgEngine/Export DeckData to CSV")]
        public static void ExportDeckDataToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "DeckData.csv"); // CSV文件保存路径

            DeckData.Load(); // 加载数据

            List<DeckData> deckList = DeckData.deck_list;

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("\"ID\",\"Title\",\"Hero\",\"Cards\"");

                // 写入数据行
                foreach (DeckData deckData in deckList)
                {
                    string heroId = deckData.hero != null ? deckData.hero.id : "";

                    // 将卡牌ID列表转换为逗号分隔的字符串
                    string cardIds = "";
                    for (int i = 0; i < deckData.cards.Length; i++)
                    {
                        string cardId = deckData.cards[i] != null ? deckData.cards[i].id : "";
                        cardIds += cardId;
                        if (i < deckData.cards.Length - 1)
                        {
                            cardIds += ",";
                        }
                    }

                    sw.WriteLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\"",
                        deckData.id,
                        deckData.title,
                        heroId,
                        cardIds));
                }
            }

            Debug.Log("DeckData exported to CSV: " + filePath);
        }
    }
}