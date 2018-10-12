using UnityEngine;
using System.Collections;

namespace DuMixARInternal
{
    public class DuMixCMPTObject : MonoBehaviour
    {

        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
            if (DuMixARNetwork.Instance.connectState != DuMixARNetwork.ConnectState.Connected)
            {
                return;
            }
            this.SyncPropertyUpdateToMobileIfNeeded();
        }

        // 将节点转换为DuMix定义的数据格式，由子类具体实现
        virtual public DuMixNode ToDuMixNode(DuMixNodeConvertor convertor)
        {
            return new DuMixNode();
        }

        /*
         * 当节点本身属性有更新的时候，同步到App上
         */
        virtual public void SyncPropertyUpdateToMobileIfNeeded() {
            
        }

    }
}
