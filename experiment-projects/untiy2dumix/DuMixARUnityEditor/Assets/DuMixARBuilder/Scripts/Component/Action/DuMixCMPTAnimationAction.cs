using UnityEngine;
using System.Collections;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixCMPTAnimationAction : DuMixCMPTAction
    {

        public enum ActionProperty
        {
            Play,
            Stop,
        };

        public ActionProperty actionProperty = ActionProperty.Play;

        //播放次数,默认一次
        public int count = 1;

        //动画播放速度，默认为1.0
        public double playSpeed = 1.0;


        /**
         *  相关Lua脚本示例
         *  anim_player = scene['bear']:pod_anim():speed(1.0):repeat_count(1):start()
         *  anim_player:stop()
         */
        override public string TransferToDuMixScript(string tabs)
        {
            var newLines = "";
            var obj = this.targetObjectName;
            if (this.actionProperty == ActionProperty.Play) {
                newLines = string.Format(tabs + "scene['{0}'].u_pod_anim:stop()\n" +
                                         tabs + "local anim = scene['{0}']:pod_anim():speed({1}):repeat_count({2}):start()\n" +
                                         tabs + "scene['{0}'].u_pod_anim = anim\n",
                                         obj, this.playSpeed, this.count);
            } else if (this.actionProperty == ActionProperty.Stop) {
                newLines = string.Format(tabs + "scene['{0}'].u_pod_anim:stop()\n", obj);
            }
            return newLines;
        }
    }
}
