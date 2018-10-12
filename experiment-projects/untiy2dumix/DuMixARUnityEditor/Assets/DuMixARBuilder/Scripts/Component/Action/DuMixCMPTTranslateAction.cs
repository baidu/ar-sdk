using System;
using UnityEngine;

namespace DuMixARInternal
{
    public class DuMixCMPTTranslateAction: DuMixCMPTAction
    {
        public int durationInMS = 1000;
        public string moveBy = "100,0,0";

        public override string TransferToDuMixScript(string tabs)
        {
            var newLines = "";
            newLines = string.Format(tabs + "scene['{0}']:move_by():to(Vector3({1})):duration({2}):start()",
                                     this.targetObjectName, moveBy, durationInMS);
            return newLines;
        }
    }
}
