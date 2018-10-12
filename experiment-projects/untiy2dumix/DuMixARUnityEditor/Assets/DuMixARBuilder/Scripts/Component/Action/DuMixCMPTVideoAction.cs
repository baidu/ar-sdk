using UnityEngine;
using System.Collections;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixCMPTVideoAction : DuMixCMPTAction
    {

        public enum ActionProperty
        {
            Play,
            Stop,
            Pause,

        };

        public ActionProperty actionProperty = ActionProperty.Play;
        public int repeatCount = 1;

        override public string TransferToDuMixScript(string tabs) {
            var newLines = "";
            var target = GameObject.Find(this.targetObjectName);
            if (target == null) {
                Debug.LogError("无法获取目标节点");
                return "";
            }

            var cmpUIVideo = target.GetComponent<DuMixCMPTUIVideo>();
            var cmpVideo = target.GetComponent<DuMixCMPT3DVideo>();
            if (cmpVideo == null && cmpUIVideo == null) {
                Debug.LogError("目标节点无视频组件");
                return "";
            }

            var videoPath = "";
            if (cmpVideo != null) {
                videoPath = "res/" + cmpVideo.resPath;
            }
            if (cmpUIVideo != null) {
                videoPath = "res/" + cmpUIVideo.resPath;
            }


            var obj = this.targetObjectName;

            /**
             *  相关Lua脚本示例
             *  video_player = scene['bear']:video():path('/res/video/a.mp4'):repeat_count(1):start()
             *  video_player:stop()
             */
            if (this.actionProperty == ActionProperty.Play)
            {
                newLines = string.Format(tabs + "scene['{0}'].u_video_player:stop()\n" +
                                         tabs + "local u_video_player = scene['{0}']:video():path('{1}'):repeat_count({2}):start()\n" +
                                         tabs + "scene['{0}'].u_video_player = u_video_player\n",
                                         obj, videoPath, repeatCount);
            }
            else if (this.actionProperty == ActionProperty.Stop)
            {
                newLines = string.Format(tabs + "scene['{0}'].u_video_player:stop()\n", obj);
            }
            else if (this.actionProperty == ActionProperty.Pause)
            {
                newLines = string.Format(tabs + "scene['{0}'].u_video_player:pause()\n", obj);
            }
            return newLines;
        }
    }
}
