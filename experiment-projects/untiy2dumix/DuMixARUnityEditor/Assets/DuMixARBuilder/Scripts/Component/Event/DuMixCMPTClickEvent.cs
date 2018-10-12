using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DuMixARInternal
{

    public class DuMixCMPTClickEvent : DuMixCMPTEvent
    {
        // DuMix ARSDK 目前仅支持单击点击模型
        //public enum DuMixClickType
        //{
        //    Click,
        //    DoubleClick
        //};

        //public DuMixClickType clickType = DuMixClickType.Click;

        override public string TransferToDuMixScript() {

            // setup script for actions
            var actions = "";
            foreach (Transform cTransform in this.transform) {
                var action = cTransform.gameObject.GetComponent<DuMixCMPTAction>();
                if (action != null) {
                    actions += action.TransferToDuMixScript("\t\t");
                }
            }

            var parentName = this.transform.parent.gameObject.name;
            var luaLine = string.Format("\tscene['{0}'].unity_click_binder = function ()\n" +
                                        "{1}\n" +
                                        "\tend\n"
                                        , parentName, actions);
            return luaLine;
        }

        private void ClickOn()
        {

        }
    }
}
