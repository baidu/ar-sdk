using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DuMixARInternal
{
    [System.Serializable]
    public class DuMixCMPTAction : DuMixCMPTObject
    {
        public string targetObjectName;

        virtual public string TransferToDuMixScript(string tabs) 
        {
            return "";
        }
    }
}
