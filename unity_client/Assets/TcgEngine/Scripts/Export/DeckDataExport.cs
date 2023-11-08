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
                sw.WriteLine("\"ID\",\"Title\",\"Hero\",\"Card1\",\"Card2\",\"Card3\",\"Card4\",\"Card5\"");

                // 写入数据行
                foreach (DeckData deckData in deckList)
                {
                    string heroId = deckData.hero != null ? deckData.hero.id : "";
                    string[] cardIds = new string[5];
                    for (int i = 0; i < 5; i++)
                    {
                        cardIds[i] = deckData.cards.Length > i && deckData.cards[i] != null ? deckData.cards[i].id : "";
                    }

                    sw.WriteLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\"",
                        deckData.id,
                        deckData.title,
                        heroId,
                        cardIds[0],
                        cardIds[1],
                        cardIds[2],
                        cardIds[3],
                        cardIds[4]));
                }
            }

            Debug.Log("DeckData exported to CSV: " + filePath);
        }
    }
}