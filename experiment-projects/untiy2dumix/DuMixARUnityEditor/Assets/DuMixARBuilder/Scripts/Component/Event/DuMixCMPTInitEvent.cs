using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DuMixARInternal
{

    public class DuMixCMPTInitEvent : DuMixCMPTEvent
    {
        public override string TransferToDuMixScript()
        {
            var actions = "";
            foreach (Transform cTransform in this.transform)
            {
                var action = cTransform.gameObject.GetComponent<DuMixCMPTAction>();
                if (action != null)
                {
                    actions += action.TransferToDuMixScript("\t");
                }
            }
            return actions;
        }
    }

}