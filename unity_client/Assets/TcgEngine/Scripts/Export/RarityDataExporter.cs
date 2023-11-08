using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public class RarityDataExporter
    {
        [MenuItem("TcgEngine/Export RarityData to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "RarityData.csv"); // CSV文件保存路径

            RarityData.Load(); // 加载数据
            
            List<RarityData> rarityList = RarityData.rarity_list;

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,Title,Rank,Icon");

                // 写入数据行
                foreach (RarityData rarityData in rarityList)
                {
                    string iconPath = (rarityData.icon != null) ? AssetDatabase.GetAssetPath(rarityData.icon) : "";

                    sw.WriteLine(string.Format("{0},{1},{2},{3}",
                        rarityData.id,
                        rarityData.title,
                        rarityData.rank,
                        iconPath
                        ));
                }
            }

            Debug.Log("RarityData exported to CSV: " + filePath);
        }
    }
}