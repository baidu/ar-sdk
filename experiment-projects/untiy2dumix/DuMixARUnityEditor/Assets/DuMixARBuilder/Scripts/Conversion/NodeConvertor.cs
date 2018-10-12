using System.IO;
using UnityEngine;
using UnityEditor;

namespace DuMixARInternal
{
    public class DuMixNodeConvertor
    {

        // 转换3D坐标系下的模型节点
        public DuMixNodeGLTF Convert3DModel(DuMixCMPTModel item) {
            var duMixNode = new DuMixNodeGLTF();
            // transform
            var dPosition = CoordinateUtil.Convert3DPosition(item.transform.localPosition);
            var dEuler = CoordinateUtil.Convert3DEuler(item.transform.localEulerAngles);
            var dScale = item.transform.localScale;

            duMixNode.position = string.Format("{0},{1},{2}", dPosition.x, dPosition.y, dPosition.z);
            duMixNode.rotation = string.Format("{0},{1},{2}", dEuler.x, dEuler.y, dEuler.z);
            duMixNode.scale = string.Format("{0},{1},{2}", dScale.x, dScale.y, dScale.z);

            // base
            duMixNode.name = item.name;

            // meshFileName
            var resPath = item.resPath;
            var fbxName = Path.GetFileName(resPath).Split('.')[0];
            Debug.Log(fbxName);

            var fbxPath = DuMixGlobalStringDefs.ResourcePath() + resPath;
            var gltfGenPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/gltf/" + fbxName;

            if (File.Exists(gltfGenPath))
            {
                Debug.Log("destination folder path exits, would remove it");
                File.Delete(gltfGenPath);
            }

            var binPath = DuMixGlobalStringDefs.ToolPath() + "FBX2glTF";
            var argument = string.Format("-i {0} -o {1}", fbxPath, gltfGenPath);
            var proc = new System.Diagnostics.ProcessStartInfo();
            proc.FileName = binPath;
            proc.Arguments = argument;
            var process = System.Diagnostics.Process.Start(proc);
            process.WaitForExit();
            process.Close();
            Debug.Log("FBX-" + fbxName + ": Converted");

            var gltfPath = "res/gltf/" + fbxName + "_out/" + fbxName + ".gltf";
            duMixNode.meshFileName = gltfPath;

            return duMixNode;
        }

        public DuMixNodePlane Convert3DPlane(DuMixCMPTPlane item) {
            var dumixNode = new DuMixNodePlane();
            dumixNode.name = item.gameObject.name;
            // convert transform
            var dPosition = CoordinateUtil.Convert3DPosition(item.gameObject.transform.localPosition);
            dumixNode.position = string.Format("{0},{1},{2}",dPosition.x, dPosition.y, dPosition.z);
            var dEuler = CoordinateUtil.Convert3DEuler(item.gameObject.transform.localEulerAngles);
            dumixNode.rotation = string.Format("{0},{1},{2}", dEuler.x, dEuler.y, dEuler.z);
            var dScale = item.gameObject.transform.localScale * 10;
            dumixNode.scale = string.Format("{0},{1},{2}", dScale.x, dScale.y, dScale.z);

            dumixNode.material.common.textureList[0].textureName = "res/" + item.resPath;
            // copy image
            var srcPath = DuMixGlobalStringDefs.ResourcePath() + item.resPath;
            var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/" + item.resPath;
            if (File.Exists(desPath))
            {
                File.Delete(desPath);
            }
            var desDirPath = Path.GetDirectoryName(desPath);
            Debug.Log(desDirPath);
            if (!Directory.Exists(desDirPath))
            {    
                Directory.CreateDirectory(desDirPath);
            }
            FileUtil.CopyFileOrDirectory(srcPath, desPath);
            return dumixNode;                
        }

        public DuMixNodeVideo Convert3DVideo(DuMixCMPT3DVideo item) {
            var dumixNode = new DuMixNodeVideo();
            dumixNode.name = item.gameObject.name;
            // convert transform
            var dPosition = CoordinateUtil.Convert3DPosition(item.gameObject.transform.localPosition);
            dumixNode.position = string.Format("{0},{1},{2}", dPosition.x, dPosition.y, dPosition.z);
            var dEuler = CoordinateUtil.Convert3DEuler(item.gameObject.transform.localEulerAngles);
            dumixNode.rotation = string.Format("{0},{1},{2}", dEuler.x, dEuler.y, dEuler.z);
            var dScale = item.gameObject.transform.localScale * 10;
            dumixNode.scale = string.Format("{0},{1},{2}", dScale.x, dScale.y, dScale.z);

            dumixNode.material.common.uvUnwrapedTextureName = "res/" + item.resPath;
            dumixNode.material.android.uvUnwrapedTextureName = "res/" + item.resPath;
            if (item.videoType == DuMixCMPT3DVideo.VideoType.commonVideo)
            {
                dumixNode.material.common.defaultShaderName = "ordinaryVideoShader";
                dumixNode.material.android.defaultShaderName = "androidOrdinaryVideoShader";
            }

            // resource part
            var srcPath = DuMixGlobalStringDefs.ResourcePath() + item.resPath;
            var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/" + item.resPath;
            if (File.Exists(desPath))
            {
                File.Delete(desPath);
            }
            var desDirPath = Path.GetDirectoryName(desPath);
            Debug.Log(desDirPath);
            if (!Directory.Exists(desDirPath))
            {    
                Directory.CreateDirectory(desDirPath);
            }
            FileUtil.CopyFileOrDirectory(srcPath, desPath);
            return dumixNode;
        }


        // 转换UI坐标系下的平面节点
        public DuMixNodeUIPlane ConvertUIPlane(DuMixCMPTUIObject item) {
            var canvasSize = new Vector2(720, 1280);
            // TODO: Handle Rotation
            var nodeName = item.gameObject.name;
            var position = CoordinateUtil.ConvertUIPosition(item.gameObject.transform.localPosition, canvasSize);
            var scale = CoordinateUtil.ConvertUIScale(item.gameObject.transform.localScale, canvasSize);
            // json part
            var duMixNode = new DuMixNodeUIPlane();
            duMixNode.name = nodeName;
            duMixNode.material.common.textureList[0].textureName = "res/" + item.resPath;
            duMixNode.hudDisplay.marginTop = position.y;
            duMixNode.hudDisplay.marginLeft = position.x;
            duMixNode.hudDisplay.screenRatio.screenWidthRatio = scale.x;
            duMixNode.hudDisplay.screenRatio.screenHeightRatio = scale.y;
            // resource part
            var srcPath = DuMixGlobalStringDefs.ResourcePath() + item.resPath;
            var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/" + item.resPath;
            if (File.Exists(desPath)) {
                File.Delete(desPath);
            }
            var desDirPath = Path.GetDirectoryName(desPath);
            Debug.Log(desDirPath);
            if (!Directory.Exists(desDirPath)) {    // create directory
                Directory.CreateDirectory(desDirPath);
            }

            FileUtil.CopyFileOrDirectory(srcPath, desPath);
            return duMixNode;
        }

        // 转换UI坐标系下的视频节点
        public DuMixNodeUIVideo ConvertUIVideo(DuMixCMPTUIVideo item) {
            var canvasSize = new Vector2(720, 1280);
            // TODO: Handle Rotation
            var nodeName = item.gameObject.name;
            var position = CoordinateUtil.ConvertUIPosition(item.gameObject.transform.localPosition, canvasSize);
            var scale = CoordinateUtil.ConvertUIScale(item.gameObject.transform.localScale, canvasSize);
            // json part
            var duMixNode = new DuMixNodeUIVideo();
            duMixNode.name = nodeName;
            duMixNode.material.common.uvUnwrapedTextureName = "res/" + item.resPath;
            duMixNode.material.android.uvUnwrapedTextureName = "res/" + item.resPath;
            if (item.videoType == DuMixCMPTUIVideo.VideoType.commonVideo) {
                duMixNode.material.common.defaultShaderName = "ordinaryVideoShader";
                duMixNode.material.android.defaultShaderName = "androidOrdinaryVideoShader";
            }
            duMixNode.hudDisplay.marginTop = position.y;
            duMixNode.hudDisplay.marginLeft = position.x;
            duMixNode.hudDisplay.screenRatio.screenWidthRatio = scale.x;
            duMixNode.hudDisplay.screenRatio.screenHeightRatio = scale.y;
            duMixNode.rotation = "90,0,0";
            //// resource part
            var srcPath = DuMixGlobalStringDefs.ResourcePath() + item.resPath;
            var desPath = DuMixGlobalStringDefs.BuildPath() + "ar/res/" + item.resPath;
            if (File.Exists(desPath))
            {
                File.Delete(desPath);
            }
            var desDirPath = Path.GetDirectoryName(desPath);
            Debug.Log(desDirPath);
            if (!Directory.Exists(desDirPath))
            {    // create directory
                Directory.CreateDirectory(desDirPath);
            }

            FileUtil.CopyFileOrDirectory(srcPath, desPath);
            return duMixNode;                        
        }
    }
}
