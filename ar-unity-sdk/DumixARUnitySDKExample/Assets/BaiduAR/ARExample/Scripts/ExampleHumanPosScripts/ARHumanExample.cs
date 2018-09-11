using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class ObjectsPool
    {
        public List<GameObject> objects = new List<GameObject>();
        public void Add(GameObject item)
        {
            objects.Add(item);
        }
        public void Clear()
        {
            HideAll();
            // objects.Remove(item);
        }
        public void RemoveItem(GameObject item)
        {
            for (int i = 0; i < objects.Count; i++)
            {
                if (item.Equals(objects[i]))
                {
					objects[i].SetActive(false);
                    return;
                }
            }
        }
        private void HideAll()
        {
            for (int i = 0; i < objects.Count; i++)
            {
                objects[i].SetActive(false);
            }
        }
        public GameObject GetItem()
        {
            GameObject go = null;
            for (int i = 0; i < objects.Count; i++)
            {
                if (!objects[i].activeSelf)
                {
                    go = objects[i];
                    break;
                }
            }
            return go;
        }

    }
    public class ARHumanExample : MonoBehaviour {

        //public enum PoseType
        //{
        //    HumanPose_Nose = 0,
        //    HumanPose_Neck = 1,
        //    HumanPose_RShoulder = 2,
        //    HumanPose_RElbow = 3,
        //    HumanPose_RWrist = 4,
        //    HumanPose_LShoulder = 5,
        //    HumanPose_LElbow = 6,
        //    HumanPose_LWrist = 7,
        //    HumanPose_RHip = 8,
        //    HumanPose_RKnee = 9,
        //    HumanPose_RAnkle = 10,
        //    HumanPose_LHip = 11,
        //    HumanPose_LKnee = 12,
        //    HumanPose_LAnkle = 13,
        //    HumanPose_REye = 14,
        //    HumanPose_LEye = 15,
        //    HumanPose_REar = 16,
        //    HumanPose_LEar = 17
        //}
    /*  (0,  "Nose")
        (1,  "Neck")
        (2,  "RShoulder")
        (3,  "RElbow")
        (4,  "RWrist")
        (5,  "LShoulder")
        (6,  "LElbow")
        (7,  "LWrist")
        (8,  "RHip")
        (9,  "RKnee")
        (10, "RAnkle")
        (11, "LHip")
        (12, "LKnee")
        (13, "LAnkle")
        (14, "REye")
        (15, "LEye")
        (16, "REar")
        (17, "LEar")
        (18, "Bkg")
     */
        public Transform CirCleParent;
        public GameObject Circle;

        public ObjectsPool objs = new ObjectsPool();

        private Vector2 lastVet_lefthand = Vector2.zero;
        private Vector2 lastVet_righthand = Vector2.zero;
        private Vector2 lastVet_leftwrist = Vector2.zero;
        private Vector2 lastVet_rightwrist = Vector2.zero;

        public GameObject CreateCircleGame()
        {
            GameObject it = GameObject.Instantiate(Circle) as GameObject;
            it.transform.parent = CirCleParent;
            it.transform.localPosition = Vector3.zero;
            it.transform.localScale = Vector3.one * 8;
          
            // it.transform.localRotation = Quaternion.identity;
            it.transform.eulerAngles = new Vector3(-180, 0, 0);
            return it;
        }
        public void ClearCircle()
        {
            for (int i = 0; i < CirCleParent.childCount; i++)
            {
                Destroy(CirCleParent.GetChild(i).gameObject);
            }
        }
        CollideManage collideScript;
        private void Start()
        {
            collideScript = FindObjectOfType<CollideManage>();
        }

        private void OnGUI()
        {
            if (GUI.Button(new Rect(20,20,100,100),"switch"))
            {
				BaiduARWebCamera aw = FindObjectOfType<BaiduARWebCamera>();
                aw.SwitchCamera();
            }
        }
        // Use this for initialization
        void Awake () 
        {
            //return;
			BaiduARHumanPose humanPose = FindObjectOfType<BaiduARHumanPose>();
            humanPose.InvokeErrorMessage(delegate(string errNum,string errMsg) {
                ARDebug.LogError("errMsg = "+errMsg);
            });
            

            humanPose.InvokeClearMessage(delegate(){
                ARDebug.Log("InvokeClearMessage ");
                objs.Clear();

            });

            humanPose.InvokePosMessage(delegate (List<OutPutData> lstVet)
            {
                ARDebug.Log("InvokePosMessage Init lstVet = "+lstVet.Count);
                for (int i = 0; i < lstVet.Count; i++)
                {
                   // ARDebug.Log("i = "+i + " score="+lstVet[i].score);
                    if (lstVet[i].score > 0.6)
                    {
                        GameObject item = objs.GetItem();
                        if (item == null)
                        {
                            item = CreateCircleGame();
                            objs.Add(item);
                        }
                        item.SetActive(true);
                        item.transform.position = lstVet[i].VectorWorldPos;
                    }
                }
                if (lstVet.Count < 18)
                {
                    return;
                }
                ARDebug.Log("InvokePosMessage Init22");
                Vector2 vetpos = new Vector2(lstVet[1].VectorScreenPos.x, lstVet[1].VectorScreenPos.y + (lstVet[1].VectorScreenPos.x - lstVet[2].VectorScreenPos.x));
                if (null == collideScript)
                {
                    collideScript = FindObjectOfType<CollideManage>();
                }
                collideScript.SetTexiaoPos(vetpos);
             
                                                  
                for(int i = 0;i < lstVet.Count;i++)
                {
                    if (i == 4)  //表示右手腕
                    {
                        Vector2 vet = Vector2.zero;
                        if (IsBound(lstVet[i].VectorScreenPos)) //如果没有检测到点
                        {
                            lstVet[i].VectorScreenPos = lastVet_righthand;
                        }
                        if (IsBound(lstVet[i - 1].VectorScreenPos)) //如果没有检测到点
                        {
                            lstVet[i - 1].VectorScreenPos = lastVet_righthand;
                        }

                        GetHandPos(lstVet[i - 1].VectorScreenPos, lstVet[i].VectorScreenPos, out vet);
                    
                        if (null == collideScript)
                        {
                            collideScript = FindObjectOfType<CollideManage>();
                        }
                        if (!IsBound(vet))
                        {
                            collideScript.HandleData(vet, HumanPoseType.POSE_RIGHTHAND);
                            lastVet_righthand = vet;
                        }
                    }
                    if (i == 7)  //表示左手腕
                    {
                        Vector2 vet = Vector2.zero;
                        if (IsBound(lstVet[i].VectorScreenPos)) //如果没有检测到点
                        {
                            lstVet[i].VectorScreenPos = lastVet_lefthand;
                        }
                        if (IsBound(lstVet[i-1].VectorScreenPos)) //如果没有检测到点
                        {
                            lstVet[i-1].VectorScreenPos = lastVet_lefthand;
                        }

                        GetHandPos(lstVet[i - 1].VectorScreenPos, lstVet[i].VectorScreenPos, out vet);
                    
                        if (null == collideScript)
                        {
                            collideScript = FindObjectOfType<CollideManage>();
                        }
                        if(!IsBound(vet))
                        {
							collideScript.HandleData(vet, HumanPoseType.POSE_LEFTHAND);
                            lastVet_lefthand = vet;
                        }
                        // collideScript.HandleData(lstVet[i].VectorScreenPos);
                    }
                    if (i == 10) //表示右脚
                    {
                        if (null == collideScript)
                        {
                            collideScript = FindObjectOfType<CollideManage>();
                        }
                        if (IsBound(lstVet[i].VectorScreenPos))
                        {
                            lstVet[i].VectorScreenPos = lastVet_rightwrist;
                        }
                        if (!IsBound(lstVet[i].VectorScreenPos))
                        {
                            collideScript.HandleData(lstVet[i].VectorScreenPos,HumanPoseType.POSE_RIGHTWRIST);
                            lastVet_rightwrist = lstVet[i].VectorScreenPos;
                        }
                    }
                    if (i == 13) //表示左脚
                    {
                        if (null == collideScript)
                        {
                            collideScript = FindObjectOfType<CollideManage>();
                        }
                        if (IsBound(lstVet[i].VectorScreenPos))
                        {
                            lstVet[i].VectorScreenPos = lastVet_leftwrist;
                        }
                        if (!IsBound(lstVet[i].VectorScreenPos))
                        {
                            collideScript.HandleData(lstVet[i].VectorScreenPos, HumanPoseType.POSE_LEFTWRIST);
                            lastVet_leftwrist = lstVet[i].VectorScreenPos;
                        }
                    }
                   
                }
              

            });
        }
        private bool IsBound(Vector2 vet)
        {
            if (vet.x >=ARScreen.Instance.ResolutionWidth() ||vet.x <= 0)
            {
                return true;
            }
            if (vet.y >= ARScreen.Instance.ResolutionHeight() || vet.y <= 0)
            {
                return true;
            }
            return false;
           
            
        }

        //按1:4来算
        public void GetHandPos(Vector2 vetElbow,Vector2 vetWrist,out Vector2 vetHand)
        {
            vetHand = Vector2.zero;

            vetHand.x = (vetWrist.x *5 - vetElbow.x)/4.0f;
            vetHand.y = (vetWrist.y * 5 - vetElbow.y) / 4.0f;
        }
			
    }
}
