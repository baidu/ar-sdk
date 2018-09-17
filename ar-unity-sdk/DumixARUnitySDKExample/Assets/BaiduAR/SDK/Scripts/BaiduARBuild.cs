using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class BaiduARBuild : ARBuild
    {

#if UNITY_EDITOR||UNITY_STANDALONE
        private ARGlobalDefs.PLATFORM platform = ARGlobalDefs.PLATFORM.UNITY_EDITOR;
#elif UNITY_ANDROID
        private ARGlobalDefs.PLATFORM platform = ARGlobalDefs.PLATFORM.ANDROID;
#else
		private ARGlobalDefs.PLATFORM platform = ARGlobalDefs.PLATFORM.IOS;
#endif
        // Use this for initialization
        public override void Awake()
        {
            base.Awake();

            ARGlobalDefs.platform = platform;
        }


#if UNITY_EDITOR || UNITY_STANDALONE
        private void OnGUI()
        {
            if (platform == ARGlobalDefs.PLATFORM.UNITY_EDITOR)
            {
                GUIStyle bb = new GUIStyle();
                // bb.normal.textColor = new Color(1.0f, 0.0f, 0.0f);   //设置字体颜色的
                bb.normal.textColor = new Color(0.0f, 0.0f, 0.0f);   //设置字体颜色的
                bb.fontSize = 40;       //当然，这是字体大小

                //居中显示FPS
                GUI.Label(new Rect(10, 150, 200, 200), "仅2D跟踪支持Editor上的实时预览 ", bb);
            }
        }
#endif
    }
}
