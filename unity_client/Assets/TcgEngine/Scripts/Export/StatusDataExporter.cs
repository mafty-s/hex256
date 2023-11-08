using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace TcgEngine
{
    public class StatusDataExporter
    {
        [MenuItem("TcgEngine/Export StatusData to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "StatusData.csv"); // CSV文件保存路径

            StatusData[] statusDataArray = Resources.LoadAll<StatusData>("");

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("Effect,Title,Icon,Description,FX,HeuristicValue");

                // 写入数据行
                foreach (StatusData statusData in statusDataArray)
                {
                    string iconPath = (statusData.icon != null) ? AssetDatabase.GetAssetPath(statusData.icon) : "";
                    string fxPath = (statusData.status_fx != null) ? AssetDatabase.GetAssetPath(statusData.status_fx) : "";

                    sw.WriteLine(string.Format("{0},{1},{2},{3},{4},{5}",
                        statusData.effect.ToString(),
                        statusData.title,
                        iconPath,
                        statusData.desc.Replace(",",";").Replace("\n",";"),
                        fxPath,
                        statusData.hvalue));
                }
            }

            Debug.Log("StatusData exported to CSV: " + filePath);
        }
    }
}