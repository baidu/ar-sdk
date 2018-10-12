using System.IO;
using UnityEngine;

namespace DuMixARInternal
{
    public class DuMixCMPTAudioAction: DuMixCMPTAction
    {
        public enum ActionProperty
        {
            Play,
            Stop,
            Pause,

        };

        public ActionProperty actionProperty = ActionProperty.Play;
        public int repeatCount = 1;

        public override string TransferToDuMixScript(string tabs)
        {
            var newLines = "";
            var target = GameObject.Find(this.targetObjectName);
            if (target == null)
            {
                Debug.LogError("无法获取目标节点");
                return "";
            }
            var cmpAudio = target.GetComponent<DuMixCMPTAudio>();
            if (cmpAudio == null)
            {
                Debug.LogError("目标节点无音频组件");
                return "";
            }
            var audioPath = "res/" + cmpAudio.resPath;
            var model = cmpAudio.gameObject.transform.parent.gameObject;
            var obj = model.name;
            if (model.GetComponent<DuMixCMPT3DObject>() == null) {
                Debug.LogError("音频播放器被绑定到非 3D Object节点下");
                obj = "root";
            }
            var audioName = Path.GetFileName(audioPath).Split('.')[0];

            /**
             *  相关Lua脚本示例
             *  audio_player = scene['bear']:audio():path('/res/audio/a.mp3'):repeat_count(1):start()
             *  audio_player:stop()
             */
            if (this.actionProperty == ActionProperty.Play)
            {
                newLines = string.Format(tabs + "scene['{0}']['{1}'].u_audio_{1}_player:stop()\n" +
                                         tabs + "local u_audio_player = scene['{0}']:audio():path('{2}'):repeat_count({3}):start()\n" +
                                         tabs + "scene['{0}']['{1}'] = u_audio_player\n",
                                         obj, audioName, audioPath, repeatCount);
            }
            else if (this.actionProperty == ActionProperty.Stop)
            {
                newLines = string.Format(tabs + "scene['{0}']['{1}']:stop()\n", obj, audioName);
            }
            else if (this.actionProperty == ActionProperty.Pause)
            {
                newLines = string.Format(tabs + "scene['{0}']['{1}']:pause()\n", obj, audioName);
            }
            return newLines;
        }
    }
}
