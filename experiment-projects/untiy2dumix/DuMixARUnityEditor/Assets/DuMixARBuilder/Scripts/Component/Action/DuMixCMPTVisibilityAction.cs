using UnityEngine;
using System.Collections;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixCMPTVisibilityAction : DuMixCMPTAction
    {

        public enum ActionProperty
        {
            visible,
            hidden
        };

        public ActionProperty actionProperty = ActionProperty.visible;

        /**
         *  相关Lua脚本示例
         *  scene['bear']:set_visible(true)
         */
        override public string TransferToDuMixScript(string tabs) {
            var param = this.actionProperty == ActionProperty.visible ? "true" : "false";
            var obj = this.targetObjectName;
            var newLine = string.Format(tabs + "scene['{0}']:set_visible({1})\n", obj, param);
            return newLine;
        }
    }
}
