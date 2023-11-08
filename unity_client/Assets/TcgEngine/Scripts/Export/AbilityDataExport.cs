using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace TcgEngine
{
    public class AbilityDataExporter
    {
        [MenuItem("TcgEngine/Export AbilityData to CSV")]
        public static void ExportAbilityDataToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "AbilityData.csv"); // CSV文件保存路径

            AbilityData.Load(); // 加载数据

            List<AbilityData> abilityList = AbilityData.ability_list;

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,Trigger,Target,Effects,Status,Value,Duration,ChainAbilities,ManaCost,Exhaust,Title,Description");

                // 写入数据行
                foreach (AbilityData abilityData in abilityList)
                {
                    string trigger = abilityData.trigger.ToString();
                    string target = abilityData.target.ToString();
                    string effects = GetEffectsString(abilityData.effects);
                    string status = GetStatusString(abilityData.status);
                    string chainAbilities = GetChainAbilitiesString(abilityData.chain_abilities);

                    //sw.WriteLine(string.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}",
                    sw.WriteLine(string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",\"{8}\",\"{9}\",\"{10}\",\"{11}\"",
                        abilityData.id,
                        trigger,
                        target,
                        effects,
                        status,
                        abilityData.value,
                        abilityData.duration,
                        chainAbilities,
                        abilityData.mana_cost,
                        abilityData.exhaust,
                        abilityData.title,
                        abilityData.desc));
                }
            }

            Debug.Log("AbilityData exported to CSV: " + filePath);
        }

        private static string GetEffectsString(EffectData[] effects)
        {
            string effectsString = "";
            foreach (EffectData effect in effects)
            {
                effectsString += effect.name + ",";
            }
            effectsString = effectsString.TrimEnd(',');
            return effectsString;
        }

        private static string GetStatusString(StatusData[] status)
        {
            string statusString = "";
            foreach (StatusData statusData in status)
            {
                statusString += statusData.name + ",";
            }
            statusString = statusString.TrimEnd(',');
            return statusString;
        }

        private static string GetChainAbilitiesString(AbilityData[] chainAbilities)
        {
            string chainAbilitiesString = "";
            foreach (AbilityData abilityData in chainAbilities)
            {
                chainAbilitiesString += abilityData.id + ",";
            }
            chainAbilitiesString = chainAbilitiesString.TrimEnd(',');
            return chainAbilitiesString;
        }
    }
}