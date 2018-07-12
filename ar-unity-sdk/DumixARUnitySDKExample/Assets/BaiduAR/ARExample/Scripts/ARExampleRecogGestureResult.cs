using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class ARExampleRecogGestureResult : MonoBehaviour
    {

        private GameObject clone;
        private LineRenderer line;

        public GameObject tf;

        void Init()
        {
            clone = (GameObject)Instantiate(tf, tf.transform.position, transform.rotation);//克隆一个带有LineRender的物体  
            clone.SetActive(true);
            line = clone.GetComponent<LineRenderer>();
            line.startColor = Color.red;
            line.endColor = Color.red; //设置颜色
            line.startWidth = 4f;
            line.endWidth = 4f;

            line.loop = true;
        }

        public List<List<RecogGesture>> lstRecoges = new List<List<RecogGesture>>();
        private void TestPos(List<RecogGesture> lstRecg)
        {
            line.positionCount = 4;
            line.SetPosition(0, lstRecg[0].LeftTopPos);
            line.SetPosition(1, lstRecg[0].RightTopPos);
            line.SetPosition(2, lstRecg[0].RightBottomPos);
            line.SetPosition(3, lstRecg[0].LeftBottomPos);

        }
        ARGestureRecog argestureRecog;
        // Use this for initialization
        void Start()
        {
            Init();
            argestureRecog = GetComponent<ARGestureRecog>();
			argestureRecog.OnResultTrackCallBack((List<RecogGesture> lstRecg) =>
            {
                lstRecoges.Add(lstRecg);
            });
        }

        // Update is called once per frame
        void Update()
        {
            if (lstRecoges.Count > 0)
            {
                //  ARDebug.Log("jinlaill");
                List<RecogGesture> lstRecgq = lstRecoges[0];
                TestPos(lstRecgq);
                lstRecoges.Remove(lstRecgq);
            }

            //RecogGesture[] rgs = new RecogGesture[4];
            //rgs[0] = new RecogGesture();
            //rgs[0].x1 = 0.3f;
            //rgs[0].y1 = 0.5f;
            //rgs[0].x2 = 0.7f;
            //rgs[0].y2 = 0.8f;

            //rgs[1] = new RecogGesture();
            //rgs[1].x1 = 0.2f;
            //rgs[1].y1 = 0.3f;
            //rgs[1].x2 = 0.9f;
            //rgs[1].y2 = 0.8f;

            //rgs[2] = new RecogGesture();
            //rgs[2].x1 = 0.1f;
            //rgs[2].y1 = 0.1f;
            //rgs[2].x2 = 0.3f;
            //rgs[2].y2 = 0.4f;

            //rgs[3] = new RecogGesture();
            //rgs[3].x1 = 0.0f;
            //rgs[3].y1 = 0.2f;
            //rgs[3].x2 = 0.5f;
            //rgs[3].y2 = 0.8f;

            //RecogGesture rg = rgs[Random.Range(0, 3)];
            //line.positionCount = 4;

            //line.SetPosition(0, rg.LeftTopPos);
            ////line.positionCount = ++index;
            //line.SetPosition(1, rg.RightTopPos);
            ////line.positionCount = ++index;
            //line.SetPosition(2, rg.RightBottomPos);
            //////line.positionCount = ++index;
            //line.SetPosition(3, rg.LeftBottomPos);
        }
    }
}
