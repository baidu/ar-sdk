using UnityEngine;
using System.IO;
using Newtonsoft.Json;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixBuilderConfigItem {
        public string mobileIpAddress = "";
    }

    public class DuMixBuilderConfigUtil
    {
        public DuMixBuilderConfigItem configItem;

        public void SaveConfig() {
            var configPath = DuMixGlobalStringDefs.CachePath() + "build.conf";
            if (File.Exists(configPath))
            {
                File.Delete(configPath);
            }
            var content = JsonConvert.SerializeObject(this.configItem);
            FileStream fileStream = new FileStream(configPath, FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter streamWriter = new StreamWriter(fileStream);
            streamWriter.WriteLine(content);
            streamWriter.Close();
            streamWriter.Dispose();
            fileStream.Close();
            fileStream.Dispose();
        }

        public void LoadConfig() {
            var configPath = DuMixGlobalStringDefs.CachePath() + "build.conf";
            if (!File.Exists(configPath)) {
                this.configItem = new DuMixBuilderConfigItem();
                return;
            }
            FileStream fileStream = new FileStream(configPath, FileMode.Open, FileAccess.Read);
            StreamReader streamReader = new StreamReader(fileStream);
            var content = streamReader.ReadLine();
            streamReader.Close();
            streamReader.Dispose();
            fileStream.Close();
            fileStream.Dispose();

            var jsonObj = JsonConvert.DeserializeObject<DuMixBuilderConfigItem>(content);
            if (jsonObj != null) {
                this.configItem = jsonObj;
            } else {
                Debug.Log("build.conf 数据毁坏");
            }
        }
    }
}
