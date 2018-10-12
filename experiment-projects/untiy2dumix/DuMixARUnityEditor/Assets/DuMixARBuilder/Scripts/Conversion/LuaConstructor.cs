using UnityEngine;
using System.Collections;


namespace DuMixARInternal
{
    public class LuaConstructor
    {
        public string lua = "";

        public void Reset() {
            this.lua = "function unityInit()\n";
        }

        public void End() {
            this.lua += "end";
        }

        public void AddScript(string lines) {
            this.lua += lines;
        }
    }
}
