using System;
namespace DuMixARInternal
{
    public class DuMixCMPTOpenUrlAction: DuMixCMPTAction
    {
        public string url = "";

        public override string TransferToDuMixScript(string tabs)
        {
            return string.Format(tabs + "app:open_url('{0}')", url);
        }
    }
}
