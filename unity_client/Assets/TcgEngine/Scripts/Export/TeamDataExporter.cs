using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

#if UNITY_EDITOR
namespace TcgEngine
{
    public class TeamDataExporter
    {
        [MenuItem("TcgEngine/Export TeamData to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "TeamData.csv"); // CSV文件保存路径

            TeamData[] teamDataArray = Resources.LoadAll<TeamData>("");

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,Title,Icon,Color");

                // 写入数据行
                foreach (TeamData teamData in teamDataArray)
                {
                    string iconPath = (teamData.icon != null) ? AssetDatabase.GetAssetPath(teamData.icon) : "";
                    string colorString = ColorUtility.ToHtmlStringRGB(teamData.color);

                    sw.WriteLine(string.Format("{0},{1},{2},{3}",
                        teamData.id,
                        teamData.title,
                        iconPath,
                        colorString));
                }
            }

            Debug.Log("TeamData exported to CSV: " + filePath);
        }
    }
}
#endif