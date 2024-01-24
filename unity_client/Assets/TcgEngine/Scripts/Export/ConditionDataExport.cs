using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;


#if UNITY_EDITOR
namespace TcgEngine
{
    public class ConditionDataExport
    {
        [MenuItem("TcgEngine/Export Condition to CSV")]
        public static void ExportToCSV()
        {
            string directoryPath = "Assets/Export"; // CSV文件保存目录
            string filePath = Path.Combine(directoryPath, "ConditionData.csv"); // CSV文件保存路径

            AbilityData.Load();


            List<AbilityData> abilityList = new List<AbilityData>(AbilityData.ability_dict.Values);

            // 创建目录
            Directory.CreateDirectory(directoryPath);

            List<string> names = new List<string>();

            using (StreamWriter sw = new StreamWriter(filePath))
            {
                // 写入表头
                sw.WriteLine("ID,OBJ_TYPE,HAS_TEAM,HAS_TYPE,HAS_TRAIT,");

                // 写入数据行
                foreach (AbilityData ability in abilityList)
                {
                    var conditions_targets = ability.conditions_target;
                    var conditions_triggers = ability.conditions_trigger;
                    var filters_targets = ability.filters_target;

                    foreach (var conditions_target in conditions_targets)
                    {
                        Debug.Log(conditions_target.name);
                        if (!names.Exists(n => n == conditions_target.name))
                        {

                            names.Insert(0, conditions_target.name);

                            if ("TcgEngine.ConditionCardType" == conditions_target.GetType().ToString())
                            {
                                ConditionCardType a = (ConditionCardType)conditions_target;
                                string has_team = a.has_team ? a.has_team.title : "";
                                string has_trait = a.has_trait ? a.has_trait.name : "";

                                sw.WriteLine(string.Format("{0},{1},{2},{3},{4},",
                                        conditions_target.name,
                                        conditions_target.GetType().ToString(),
                                        has_team,
                                        a.has_type.ToString(),
                                        has_trait
                                    )
                                );
                            }
                            else
                            {
                                sw.WriteLine(string.Format("{0},{1},{2},{3},{4},",
                                        conditions_target.name,
                                        conditions_target.GetType().ToString(),
                                        "",
                                        "",
                                        ""
                                    )
                                );

                                Debug.LogError(conditions_target.GetType().ToString());
                            }
                        }
                    }

                    
                    
                    
                        
                    foreach (var filters_target in filters_targets)
                    {
                        Debug.Log(filters_target.name);
                        if (!names.Exists(n => n == filters_target.name))
                        {

                            names.Insert(0, filters_target.name);
                            
                            sw.WriteLine(string.Format("{0},{1},{2},{3},{4},",
                                    filters_target.name,
                                    filters_target.GetType().ToString(),
                                    "",
                                    "",
                                    ""
                                )
                            );
                            
                            Debug.LogError(filters_target.GetType().ToString());

                        }
                    }
                        
                        
                    foreach (var conditions_trigger in conditions_triggers)
                    {
                        Debug.Log(conditions_trigger.name);
                        if (!names.Exists(n => n == conditions_trigger.name))
                        {

                            names.Insert(0, conditions_trigger.name);
                            
                            sw.WriteLine(string.Format("{0},{1},{2},{3},{4},",
                                    conditions_trigger.name,
                                    conditions_trigger.GetType().ToString(),
                                    "",
                                    "",
                                    ""
                                )
                            );
                            
                            Debug.LogError(conditions_trigger.GetType().ToString());

                        }
                    }
                }
            }

            Debug.Log("ConditionData exported to CSV: " + filePath);
        }
    }
}
#endif