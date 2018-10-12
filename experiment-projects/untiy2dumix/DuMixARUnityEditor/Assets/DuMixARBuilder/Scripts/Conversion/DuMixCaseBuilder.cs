using System.IO;
using UnityEngine;
using UnityEditor;
using Newtonsoft.Json;

namespace DuMixARInternal
{   

    public class DuMixCaseBuilder {

        public enum DuMixCaseType {
            SLAM,
            IMU,
            TRACK2D
        }

        public DuMixCaseType caseType = DuMixCaseType.SLAM;

        public void Run()
        {
            Debug.Log("Unit2DuMix 开始");
            // Check AR Type
            var rootScene = Object.FindObjectOfType<DuMixCMPTScene>();
            if (rootScene == null) {
                Debug.LogError("找不到有效的Scene");
                return;
            }

            if (rootScene.GetType() == typeof(DuMixCMPTSlamScene)) {
                Debug.Log("AR type: SLAM");
                this.caseType = DuMixCaseType.SLAM;
            } else if (rootScene.GetType() == typeof(DuMixCMPTTrackScene)) {
                Debug.Log("AR type: TRACK");
                this.caseType = DuMixCaseType.TRACK2D;
            } else if (rootScene.GetType() == typeof(DuMixCMPTImuScene)){
                Debug.Log("AR type: IMU");
                this.caseType = DuMixCaseType.IMU;
            }

            // setup build path
            var templatePath = DuMixGlobalStringDefs.TemplatePath() + "ar";
            var buildPath = DuMixGlobalStringDefs.BuildPath() + "ar";

            if(!Directory.Exists(DuMixGlobalStringDefs.BuildPath()))
            {
                Directory.CreateDirectory(DuMixGlobalStringDefs.BuildPath());
            }

            if (!Directory.Exists(templatePath)) {
                Debug.LogError("DuMixARCase/Templates/ar 文件夹不存在");
            }

            if (Directory.Exists(buildPath))
            {
                FileUtil.DeleteFileOrDirectory(buildPath);
            }

            FileUtil.CopyFileOrDirectory(templatePath, buildPath);

            // -- 输出 ar/res/main.json
            DuMixNodeJSONFrame frame = new DuMixNodeJSONFrame();
            DuMixNodeCamera mainCamera = new DuMixNodeCamera();
            frame.nodeList.Add(mainCamera);
            frame = this.FillSceneGraph(frame, this.caseType);
            string json = JsonConvert.SerializeObject(frame);
            var mainJsonPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/main.json";
            if (File.Exists(mainJsonPath))
            {
                File.Delete(mainJsonPath);
            }

            FileStream fileStream = new FileStream(mainJsonPath, FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter streamWriter = new StreamWriter(fileStream);
            streamWriter.WriteLine(json);
            streamWriter.Close();
            streamWriter.Dispose();
            fileStream.Close();
            fileStream.Dispose();

            // -- 输出 ar/targets.json
            DuMixCaseConfig config = new DuMixCaseConfig();
            var targetJsonPath = DuMixGlobalStringDefs.BuildPath() + "ar/targets.json";
            if (File.Exists(targetJsonPath))
            {
                File.Delete(targetJsonPath);
            }
            fileStream = new FileStream(targetJsonPath, FileMode.OpenOrCreate, FileAccess.Write);
            streamWriter = new StreamWriter(fileStream);
            // TODO
            if (this.caseType == DuMixCaseType.TRACK2D) {
                // Update target values                
            }
            json = JsonConvert.SerializeObject(config);
            streamWriter.WriteLine(json);
            streamWriter.Close();
            streamWriter.Dispose();
            fileStream.Close();
            fileStream.Dispose();

            // -- 输出 ar/default.lua
            var templateLuaPath = DuMixGlobalStringDefs.TemplatePath() + "default_lua/";
            switch (this.caseType) {
                case DuMixCaseType.IMU :
                    templateLuaPath += "default_imu.lua";
                    break;
                case DuMixCaseType.SLAM:
                    templateLuaPath += "default_slam.lua";
                    break;
                case DuMixCaseType.TRACK2D:
                    templateLuaPath += "default_track.lua";
                    break;
            }
            var desLuaPath = DuMixGlobalStringDefs.BuildPath() + "ar/default.lua";
            if (File.Exists(desLuaPath))
            {
                File.Delete(desLuaPath);
            }
            FileUtil.CopyFileOrDirectory(templateLuaPath, desLuaPath);

            // Copy Audio Resources
            var audioPlayers = Object.FindObjectsOfType<DuMixCMPTAudio>();
            foreach (var audio in audioPlayers) {
                var src = DuMixGlobalStringDefs.ResourcePath() + audio.resPath;
                var dest = DuMixGlobalStringDefs.BuildPath() + "ar/res/" + audio.resPath;
                var desDirPath = Path.GetDirectoryName(dest);
                if (!Directory.Exists(desDirPath))
                {    // create directory
                    Directory.CreateDirectory(desDirPath);
                }
                FileUtil.CopyFileOrDirectory(src, dest);
            }

            // User Scripts
            var luaFiles = Directory.GetFiles(DuMixGlobalStringDefs.LuaFilePath());
            foreach (var luaFile in luaFiles) {
                var fileName = Path.GetFileName(luaFile);
                var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/" + fileName;
                FileUtil.CopyFileOrDirectory(luaFile, desPath);
            }
            var luaFileDirs = Directory.GetDirectories(DuMixGlobalStringDefs.LuaFilePath());
            foreach (var dir in luaFileDirs) {
                var dirName = Path.GetFileName(dir);
                var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/" + dirName;
                FileUtil.CopyFileOrDirectory(dir, desPath);
            }

            // Write to ar/unity.lua
            var luaBuilder = new LuaConstructor();
            luaBuilder.Reset();
            var evtObjests = Object.FindObjectsOfType<DuMixCMPTEvent>();
            foreach (var evt in evtObjests) {
                var newLine = evt.TransferToDuMixScript();
                luaBuilder.AddScript(newLine);
            }
            luaBuilder.End();

            var unityLuaPath = DuMixGlobalStringDefs.BuildPath() + "ar/unity.lua";
            fileStream = new FileStream(unityLuaPath, FileMode.OpenOrCreate, FileAccess.Write);
            streamWriter = new StreamWriter(fileStream);
            streamWriter.WriteLine(luaBuilder.lua);
            streamWriter.Close();
            streamWriter.Dispose();

            fileStream.Close();
            fileStream.Dispose();

            // Send Case Type Message
            var setCaseTypeMsg = new DuMixRDMessageSetCaseType();
            switch (this.caseType) {
                case DuMixCaseType.IMU:
                    setCaseTypeMsg.caseType = "imu";
                    break;
                case DuMixCaseType.SLAM:
                    setCaseTypeMsg.caseType = "slam";
                    break;
                case DuMixCaseType.TRACK2D:
                    setCaseTypeMsg.caseType = "track";
                    break;
            }
            var msgJson = JsonConvert.SerializeObject(setCaseTypeMsg);

            Debug.Log("Unity2DuMix 完成");
            // Zip ar
            string zipPath = DuMixGlobalStringDefs.BuildPath() + "ar.zip";
            DuMixZipUtility.Zip(buildPath, zipPath ,delegate () {
                //DuMixARNetwork.Instance.sendString(msgJson);
                DuMixARNetwork.Instance.sendFile(zipPath);
            });
		}


        DuMixNodeJSONFrame FillSceneGraph(DuMixNodeJSONFrame frame, DuMixCaseType type) {
            var converter = new DuMixNodeConvertor();
            if (type == DuMixCaseType.SLAM) {
                Debug.Log("转换SLAM场景");
                // Convert 3D coordinate parts
                var scene = Object.FindObjectOfType<DuMixCMPTSlamScene>();
                // SLAM坐标系转换需先将3D坐标系绕X轴旋转90度
                var rootGroup = new DuMixNodeGroup
                {
                    name = "slam_root",
                    rotation = "90,0,0"
                };
                frame.nodeList.Add(rootGroup);
                foreach (Transform child in scene.gameObject.transform)
                {
                    var node = child.gameObject.GetComponent<DuMixCMPT3DObject>();
                    if (node != null)
                    {
                        var childDuMixNode = node.ToDuMixNode(converter);
                        Debug.Log("转换 " + node.name + " 节点");
                        rootGroup.children.Add(childDuMixNode);
                    }
                }
            } else if (type == DuMixCaseType.TRACK2D) {
                // TODO

            } else if (type == DuMixCaseType.IMU) {
                // TODO

            }

            // Convert HUD Coordinate parts
            var uiCanvas = Object.FindObjectOfType<DuMixCMPTUICanvas>();
            foreach (Transform child in uiCanvas.gameObject.transform)
            {
                var node = child.gameObject.GetComponent<DuMixCMPTUIObject>();
                if (node != null)
                {
                    var duMixNode = node.ToDuMixNode(converter);
                    Debug.Log("转换 " + node.name + " 节点");
                    frame.nodeList.Add(duMixNode);
                }
            }
            return frame;
        }
	}
}
