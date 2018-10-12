/**
 * DuMix节点数据结构定义
 */
using System.Collections.Generic;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixNode
    {
        public List<DuMixNode> children = new List<DuMixNode>();
    }

    /**
     * COMMON
     */
    [System.Serializable]
    public class DuMixNodeHudScreenRatio
    {
        public double screenWidthRatio = 0.1f;
        public double screenHeightRatio = 0.1f;
        public int keepAspectRatio = 0;
    }

    [System.Serializable]
    public class DuMixNodeHudDisplay
    {
        public double marginLeft = 0.5f;
        public double marginTop = 0.5f;
        public int depthPosition = 20000;
        public DuMixNodeHudScreenRatio screenRatio = new DuMixNodeHudScreenRatio();
    }

    /**
     * GLTF
     */
    [System.Serializable]
    public class DuMixNodeGLTFMaterialCommon
    {
        public string offsetRepeat = "0,0,1,1";
    }


    [System.Serializable]
    public class DuMixNodeGLTFMaterial
    {
        public DuMixNodeGLTFMaterialCommon common = new DuMixNodeGLTFMaterialCommon();
    }

    [System.Serializable]
    public class DuMixNodeGLTFShadow
    {
        public int allDropShadow = 1;
        public List<string> shadowDroppingSubNodeList = new List<string>();
        public int allReceiveShadow = 1;
        public List<string> shadowReceivingSubNodeList = new List<string>();
    }

    [System.Serializable]

    public class DuMixNodePodSuppl
    {
        public int allSubnodeTouchable = 1;
    }

    [System.Serializable]
    public class DuMixNodeGLTF : DuMixNode
    {
        public string name = "";
        public string type = "gltf";
        public int visible = 1;
        public int touchable = 1;
        public string meshFileName = "";
        public int transparentObject = 1;
        public string position = "0,0,0";
        public string scale = "1,1,1";
        public string rotation = "0,0,0";
        public DuMixNodeGLTFMaterial material = new DuMixNodeGLTFMaterial();
        public DuMixNodeGLTFShadow shadow = new DuMixNodeGLTFShadow();
        public DuMixNodePodSuppl podSuppl = new DuMixNodePodSuppl();
    }

    /**
     * GROUP
     */
    [System.Serializable]
    public class DuMixNodeGroup : DuMixNode
    {
        public string name = "";
        public string type = "group";
        public int visible = 1;
        public string position = "0,0,0";
        public string scale = "1,1,1";
        public string rotation = "0,0,0";
    }

    /**
     * CAMERA
     */
    [System.Serializable]
    public class DuMixNodeCameraNodeSuppl
    {
        public int fov = 56;
        public int zNear = 50;
        public int zFar = 10000;
    }

    [System.Serializable]
    public class DuMixNodeCamera : DuMixNode
    {
        public string name = "mainCamera";
        public string type = "camera";
        public int visible = 1;
        public DuMixNodeCameraNodeSuppl cameraNodeSuppl = new DuMixNodeCameraNodeSuppl();
    }

    /**
     * MAIN FRAME
     */
    [System.Serializable]
    public class DuMixNodeUserInteraction
    {
        public int disableAll = 0;
        public int disablePinch = 0;
        public int disableClick = 0;
        public int disableLongPress = 0;
        public int disableSingleFingerScroll = 0;
        public int disableTwoFingerScroll = 0;
        public int disableDoubleClick = 0;
        public int enableTouchZone = 0;
    }

    [System.Serializable]
    public class DuMixNodeCameraDefaultLookAt
    {
        public string eyePos = "0,0,1536";
        public string centerPos = "0,0,0";
        public string upDirection = "0,1,0";
    }

    [System.Serializable]
    public class DuMixNodeJSONFrame
    {
        public int showImmediately = 1;
        public int showOffscreenGuidance = 0;
        public int imuRelayCtrlWhenTrackLost = 0;
        public DuMixNodeUserInteraction userInteraction = new DuMixNodeUserInteraction();
        public DuMixNodeCameraDefaultLookAt cameraDefaultLookAt = new DuMixNodeCameraDefaultLookAt();
        public List<DuMixNode> nodeList = new List<DuMixNode>();
    }

    /**
     * PLANE
     */
    [System.Serializable]
    public class DuMixNodePlaneTextureListItem
    {
        public string textureName = "";
    }

    [System.Serializable]
    public class DuMixNodePlaneMaterialCommon
    {
        public string defaultShaderName = "planeShader";
        public List<DuMixNodePlaneTextureListItem> textureList = new List<DuMixNodePlaneTextureListItem>();
        public DuMixNodePlaneMaterialCommon()
        {
            var textureItem = new DuMixNodePlaneTextureListItem();
            textureList.Add(textureItem);
        }
    }

    [System.Serializable]
    public class DuMixNodePlaneMaterial
    {
        public DuMixNodePlaneMaterialCommon common = new DuMixNodePlaneMaterialCommon();
    }

    [System.Serializable]
    public class DuMixNodePlane : DuMixNode
    {
        public string name = "";
        public string type = "plane";
        public int visible = 1;
        public int touchable = 1;
        public string scale = "1,1,1";
        public string position = "0,0,0";
        public string rotation = "90,0,0";
        public int transparentObject = 1;
        public DuMixNodePlaneMaterial material = new DuMixNodePlaneMaterial();
    }

    [System.Serializable]
    public class DuMixNodeUIPlane : DuMixNodePlane
    {
        public DuMixNodeHudDisplay hudDisplay = new DuMixNodeHudDisplay();
    }

    /**
     * VIDEO
     */
    [System.Serializable]
    public class DuMixNodeVideoMaterialCommon
    {
        public string defaultShaderName = "videoShader";
        public string textureType = "video";
        public string uvUnwrapedTextureName = "";
    }

    [System.Serializable]
    public class DuMixNodeVideoMaterialAndroid
    {
        public string defaultShaderName = "androidVideoShader";
        public string textureType = "video";
        public string uvUnwrapedTextureName = "";
    }

    [System.Serializable]
    public class DuMixNodeVideoMaterial
    {
        public DuMixNodeVideoMaterialCommon common = new DuMixNodeVideoMaterialCommon();
        public DuMixNodeVideoMaterialAndroid android = new DuMixNodeVideoMaterialAndroid();
    }

    [System.Serializable]
    public class DuMixNodeVideo: DuMixNode
    {
        public string name = "";
        public string type = "video";
        public int visible = 1;
        public int touchable = 1;
        public DuMixNodeVideoMaterial material = new DuMixNodeVideoMaterial();
        public int transparentObject = 0;
        public string position = "0,0,0";
        public string scale = "1,1,1";
        public string rotation = "0,0,0";
    }

    [System.Serializable]
    public class DuMixNodeUIVideo: DuMixNodeVideo
    { 
        public DuMixNodeHudDisplay hudDisplay = new DuMixNodeHudDisplay();
    }

}