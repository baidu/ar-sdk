using System.Timers;

#if UNITY_EDITOR
using UnityEngine;
using Newtonsoft.Json;
#endif
 

namespace DuMixARInternal
{
    [System.Serializable]
    [ExecuteInEditMode]
    public class DuMixCMPTUIObject : DuMixCMPTObject
    {
        public string resPath;

        // 暂存节点属性值，定时器延迟发送消息到App
        [HideInInspector] public Timer propertySyncTimer;
        [HideInInspector] public string nodeName = "";
        [HideInInspector] public DuMixRDMessageScreenLayoutData hudData = new DuMixRDMessageScreenLayoutData();

        override public void SyncPropertyUpdateToMobileIfNeeded() 
        {
            if (this.gameObject.transform.hasChanged) {
                this.gameObject.transform.hasChanged = false;
               
                nodeName = this.gameObject.name;
                // 更新暂存的坐标数
                this.UpdateDuMixScreenLayout();
                // 避免频繁向App发送消息
                if (this.propertySyncTimer == null)
                {
                    this.propertySyncTimer = new Timer();
                    this.propertySyncTimer.Interval = 100;
                    this.propertySyncTimer.Elapsed += new ElapsedEventHandler(SendMessage);
                }
                else
                {
                    this.propertySyncTimer.Stop();
                }
                this.propertySyncTimer.Start();
            } 
        }

        // 不同类型的节点坐标数据转换的方式不同
        virtual public void UpdateDuMixScreenLayout() {
            
        }

        void SendMessage(object source, ElapsedEventArgs e) {
            this.propertySyncTimer.Stop();
            var msg = new DuMixRDMessageComponentUpdate();
            msg.messageId = string.Format("{0}", System.DateTime.Now.Ticks);
            msg.node = nodeName;
            msg.component = "hudDisplay";
            msg.value = hudData;
            var msgString = JsonConvert.SerializeObject(msg);
            DuMixARNetwork.Instance.sendString(msgString);
        }
    }
}
