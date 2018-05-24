using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
	public class BaiduARBuild : ARBuild
    {
#if UNITY_EDITOR
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

    }
}
