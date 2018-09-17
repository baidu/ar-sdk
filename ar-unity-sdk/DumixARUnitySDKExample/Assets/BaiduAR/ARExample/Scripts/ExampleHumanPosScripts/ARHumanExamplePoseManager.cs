using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class ARHumanExamplePoseManager : MonoBehaviour
    {
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

        public GameObject[] Static_pose = new GameObject[3];


        private bool IsWistFrontChest = false;

        public GameObject[] audios = new GameObject[5];

        List<OutPutData> lstVets = new List<OutPutData>();
        private ARHumanExampleElectric electRoot;
        private ARHumanExampleFootLift footRoot;

		private ARExampleUI exampleUI;

        public GameObject CreateCircleGame(int z)
        {
            GameObject it = Instantiate(Circle) as GameObject;
            //  it.transform.parent = CirCleParent;
            it.transform.localPosition = Vector3.zero;

            it.transform.localScale = Vector3.one * z;

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


        private void OnGUI()
        {
            //GUIStyle fontStyle = new GUIStyle();

            GUI.skin.button.fontSize = 30;
            if (GUI.Button(new Rect(40, 40, 100, 60), "切换"))
            {
				BaiduARWebCamera aw = FindObjectOfType<BaiduARWebCamera>();
                aw.SwitchCamera();
                //CheckEffect(0, lstVets[0].VectorScreenPos, lstVets[1].VectorScreenPos, lstVets[2].VectorScreenPos);
            }

            if (GUI.Button(new Rect(300, 40, 100, 60), "暂停"))
            {
				BaiduARHumanPose aw = FindObjectOfType<BaiduARHumanPose>();
                aw.PauseAR();

                objs.Clear();
                electRoot.HideElectric();
                //CheckEffect(0, lstVets[0].VectorScreenPos, lstVets[1].VectorScreenPos, lstVets[2].VectorScreenPos);
            }

            if (GUI.Button(new Rect(450, 40, 100, 60), "继续"))
            {
				BaiduARHumanPose aw = FindObjectOfType<BaiduARHumanPose>();
                aw.ResumeAR();
                //CheckEffect(0, lstVets[0].VectorScreenPos, lstVets[1].VectorScreenPos, lstVets[2].VectorScreenPos);
            }
        }

        // Use this for initialization
        void Awake()
        {
            electRoot = FindObjectOfType<ARHumanExampleElectric>();
            footRoot = FindObjectOfType<ARHumanExampleFootLift>();
			BaiduARHumanPose humanPose = FindObjectOfType<BaiduARHumanPose>();

			exampleUI = FindObjectOfType<ARExampleUI>();
            humanPose.InvokeErrorMessage(delegate (string errNum, string errMsg)
            {
					exampleUI.ErrorInfo(errNum,errMsg);
                ARDebug.LogError("errMsg = " + errMsg);
            });

            humanPose.InvokeClearMessage(delegate ()
            {

                ARDebug.Log("InvokeClearMessage ");
                objs.Clear();
            });
            humanPose.InvokePosMessage(delegate (List<OutPutData> lstVet)
            {
                if (lstVet[1].score > 0 && lstVet[8].score > 0)
                {
                    ARHumanBodyDataParse.lengthShoulder = Vector2.Distance(lstVet[1].VectorScreenPos, lstVet[8].VectorScreenPos);
                    ARDebug.Log("datas lengthShoulder = " + ARHumanBodyDataParse.lengthShoulder);

                    if (lstVet[10].score > 0 && lstVet[13].score > 0)
                    {
                        float left = Vector2.Distance(lstVet[10].VectorScreenPos, lstVet[8].VectorScreenPos);
                        float right = Vector2.Distance(lstVet[13].VectorScreenPos, lstVet[11].VectorScreenPos);
                        if (right < ARHumanBodyDataParse.lengthShoulder && left < ARHumanBodyDataParse.lengthShoulder)
                        {
                            return;
                        }
                    }
                }



                int z = (int)(ARHumanBodyDataParse.lengthShoulder / 60);

                int ZeroCount = 0;
                for (int i = 0; i < lstVet.Count; i++)
                {
                    if (lstVet[i].score > 0.6)
                    {
                        //  if ( i == 4 ||  i == 2 || i == 7  || i ==5)
                        {
                            //GameObject item = objs.GetItem();
                            //if (item == null)
                            //{
                            //    item = CreateCircleGame(z);
                            //    objs.Add(item);
                            //}
                            //item.transform.localScale = Vector3.one * z;
                            //item.SetActive(true);
                            //// item.transform.position = GameObject.Find("UICamera").GetComponent<Camera>().ScreenToWorldPoint(lstVet[i].VectorScreenPos);//lstVet[i].VectorWorldPos;
                            //item.transform.position = FindObjectOfType<ARWebCamera>().GetComponent<Camera>().ScreenToWorldPoint(lstVet[i].VectorScreenPos);//lstVet[i].VectorWorldPos;
                        }
                    }
                    else
                    {
                        ZeroCount++;
                    }
                }
                if (ZeroCount > 15)
                {
                    objs.Clear();
                }

                if (ARHumanBodyDataParse.foots[0] == null)
                {
                    ARHumanBodyDataParse.foots[0] = new Queue<float>();
                    ARHumanBodyDataParse.foots[1] = new Queue<float>();
                }
                if (ARHumanBodyDataParse.foots[0].Count < ARHumanBodyDataParse.footsize)
                {
                    ARHumanBodyDataParse.foots[0].Enqueue(lstVet[10].VectorScreenPos.y);
                    ARHumanBodyDataParse.foots[1].Enqueue(lstVet[13].VectorScreenPos.y);
                }
                else
                {
                    ARHumanBodyDataParse.foots[0].Dequeue();
                    ARHumanBodyDataParse.foots[1].Dequeue();

                    ARHumanBodyDataParse.foots[0].Enqueue(lstVet[10].VectorScreenPos.y);
                    ARHumanBodyDataParse.foots[1].Enqueue(lstVet[13].VectorScreenPos.y);
                }

                electRoot.Electric(lstVet);
                StaticPose(lstVet);

                if (lstVet[10].score > 0 && lstVet[13].score > 0)
                {
                    float left = Vector2.Distance(lstVet[10].VectorScreenPos, lstVet[8].VectorScreenPos);
                    float right = Vector2.Distance(lstVet[13].VectorScreenPos, lstVet[11].VectorScreenPos);
                    if (right < ARHumanBodyDataParse.lengthShoulder && left < ARHumanBodyDataParse.lengthShoulder)
                    {
                        lastNosePose = lstVet[0].VectorScreenPos;
                        return;
                    }

                    if (!lastNosePose.Equals(Vector2.one))
                    {
                        float Distan = Vector2.Distance(lastNosePose, lstVet[0].VectorScreenPos);
                        lastNosePose = lstVet[0].VectorScreenPos;
                        //Debug.Log("Distan="+Distan);
                        if (Distan > ARHumanBodyDataParse.lengthShoulder/10)
                        {
                            ARHumanBodyDataParse.foots[0].Clear();
                            ARHumanBodyDataParse.foots[1].Clear();
                            return;
                        }
                    }
                }
                lastNosePose = lstVet[0].VectorScreenPos;
                footRoot.FootLift(lstVet);
            });
        }
      
        Vector2 lastNosePose= Vector2.one;

        private int FistInWaistFrameCount = 0;
        private int FistFrontChestFrameCount = 0;
        private int DomainNumber = 5;
        private void FistInWaist(List<OutPutData> lstVet, int i)
        {
            bool RightFistInWaist = false;
            bool LeftFistInWaist = false;
            //叉腰动作

            if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5 || lstVet[i - 2].score < 0.5 ||
                lstVet[i + 3].score < 0.5 || lstVet[i + 2].score < 0.5 || lstVet[i + 1].score < 0.5)
            {
                StopSoundEffect(0);
                FistInWaistFrameCount = 0;
                return;
            }
            RightFistInWaist = ARHumanBodyDataParse.fistInWaistRight(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos);
            LeftFistInWaist = ARHumanBodyDataParse.fistInWaistLeft(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos);

            if (RightFistInWaist && LeftFistInWaist)
            {
                Static_pose[0].transform.position = ARHumanBodyDataParse.GetGroundVet(lstVet[0].VectorScreenPos, 0, (int)(300 * ARHumanBodyDataParse.lengthShoulder / 600), 1000 / ARHumanBodyDataParse.lengthShoulder);
                wistTogether = false;
                FistInWaistFrameCount++;
                if (FistInWaistFrameCount < DomainNumber) //5帧才认
                {
                    return;
                }
                //表示叉腰动作
                if (!Static_pose[0].activeSelf)
                {
                    Static_pose[0].SetActive(true);
                    //特效消失
                    if (Static_pose[1].activeSelf)
                    {
                        Static_pose[1].SetActive(false);
                    }
                }

                if (!audios[0].activeSelf)
                {
                    audios[0].SetActive(true);
                    if (audios[1].activeSelf)
                    {
                        audios[1].SetActive(false);
                    }
                }
              
                return;
            }
            else
            {
                //动作消失
                StopSoundEffect(0);
                FistInWaistFrameCount = 0;
            }

        }
        private void StopSoundEffect(int i)
        {
            if (Static_pose[i].activeSelf)
            {
                Static_pose[i].SetActive(false);
            }
            if (audios[i].activeSelf)
            {
                audios[i].SetActive(false);
            }
        }



        private void FistFrontChest(List<OutPutData> lstVet, int i)
        {
            bool RightFistFrontChest = false;
            bool LeftFistFrontChest = false;

            if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5 || lstVet[i - 2].score < 0.5 ||
               lstVet[i + 3].score < 0.5 || lstVet[i + 2].score < 0.5 || lstVet[i + 1].score < 0.5)
            {

                StopSoundEffect(1);
                return;
            }

            if (!wistTogether)
            {
                RightFistFrontChest = ARHumanBodyDataParse.fistFrontChestRight(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos); ;
                LeftFistFrontChest = ARHumanBodyDataParse.fistFrontChestLeft(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos);
                if (RightFistFrontChest && LeftFistFrontChest)
                {
                    if (ARHumanBodyDataParse.fistTogether(lstVet[i].VectorScreenPos, lstVet[i + 3].VectorScreenPos))
                    {
                        wistTogether = true;
                    }
                }
            }

            if (wistTogether)
            {

                //双掌在胸前的动作
                RightFistFrontChest = ARHumanBodyDataParse.fistFrontChestRight(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos); ;
                LeftFistFrontChest = ARHumanBodyDataParse.fistFrontChestLeft(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos);

                if (RightFistFrontChest && LeftFistFrontChest)
                {
                    FistFrontChestFrameCount = 0;
                    //双掌在胸前动作
                    StopCoroutine("WaitFrontChestEnable");
                    StartCoroutine("WaitFrontChestEnable");
                    ARDebug.Log("chayao chestFront");

                    Vector3 centerChest = (lstVet[i].VectorScreenPos + lstVet[i + 3].VectorScreenPos) / 2;
                    centerChest.y = centerChest.y + ARHumanBodyDataParse.lengthShoulder/20;
                    //  Vector2 centerChest = new Vector2((lstVet[i].VectorScreenPos.x + lstVet[i +3].VectorScreenPos.x)/2,(lstVet[i].VectorScreenPos.y + lstVet[i + 3].VectorScreenPos.y)/2);
                    ARDebug.Log("my = " + centerChest.x + "  " + centerChest.y);

                    float distance = Vector2.Distance(lstVet[i].VectorScreenPos, lstVet[i + 3].VectorScreenPos);
                    float z = 20;
                    z = z * 500 / distance;
                    Static_pose[1].transform.position = ARHumanBodyDataParse.GetGroundVet(centerChest, 0, 0, z);

                    if (!audios[1].activeSelf)
                    {
                        audios[1].SetActive(true);
                    }
                    ARDebug.Log("chayao chestFront Hinde");
                    if (!Static_pose[1].activeSelf)
                    {
                        Static_pose[1].SetActive(true);
                    }
                    audios[0].SetActive(false);

                    return;
                }
                else
                {
                    FistFrontChestFrameCount++;
                    if (FistFrontChestFrameCount > (DomainNumber - 3))
                    {
                        StopSoundEffect(1);
                    }

                }
            }
            else
            {
                //特效消失
                FistFrontChestFrameCount++;
                if (FistFrontChestFrameCount > (DomainNumber - 3))
                {
                    StopSoundEffect(1);
                }
            }
        }
        private void FistFrontIn(List<OutPutData> lstVet, int i)
        {
            bool RightFistFrontChest = false;
            bool LeftFistFrontChest = false;

            bool RightFistFrontTo = false;
            bool LeftFistFrontTo = false;

            if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5 || lstVet[i - 2].score < 0.5 ||
                lstVet[i + 3].score < 0.5 || lstVet[i + 2].score < 0.5 || lstVet[i + 1].score < 0.5)
            {
                return;
            }

            RightFistFrontChest = ARHumanBodyDataParse.fistFrontChestRight(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos);
            LeftFistFrontChest = ARHumanBodyDataParse.fistFrontChestLeft(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos);

            if (RightFistFrontChest && LeftFistFrontChest)
            {
                IsWistFrontChest = true;
            }

            if (IsWistFrontChest)
            {
                //双掌向前推动作
                RightFistFrontTo = ARHumanBodyDataParse.fistFrontToRight(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos);
                LeftFistFrontTo = ARHumanBodyDataParse.fistFrontToLeft(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos);


                if (RightFistFrontTo && LeftFistFrontTo)
                {
                    if (ARHumanBodyDataParse.FistIntenal(lstVet[i - 1].VectorScreenPos, lstVet[i].VectorScreenPos)
                        && ARHumanBodyDataParse.FistIntenal(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos))
                    {
                        return;
                    }
                    IsWistFrontChest = false;
                    wistTogether = false;
                    FistFrontChestFrameCount = DomainNumber + 5;
                    StopCoroutine("WaitFrontChestEnable");
                    //时间到了消失
                    if (!Static_pose[2].activeSelf)
                    {
                        Static_pose[2].SetActive(true);
                    }
                    Static_pose[2].GetComponent<ParticleSystem>().Play();
                    Vector3 centerChest = (lstVet[i].VectorScreenPos + lstVet[i + 3].VectorScreenPos) / 2;
                    //  Vector2 centerChest = new Vector2((lstVet[i].VectorScreenPos.x + lstVet[i +3].VectorScreenPos.x)/2,(lstVet[i].VectorScreenPos.y + lstVet[i + 3].VectorScreenPos.y)/2);
                    ARDebug.Log("my = " + centerChest.x + "  " + centerChest.y);

                    float distance = Vector2.Distance(lstVet[i].VectorScreenPos, lstVet[i + 3].VectorScreenPos);
                    ARDebug.Log("distance = " + distance);
                    float z = 20;
                    z = z * 500 / distance;
                    Static_pose[2].transform.position = ARHumanBodyDataParse.GetGroundVet(centerChest, 0, 0, 1000 / ARHumanBodyDataParse.lengthShoulder);
                    //Static_pose[2].transform.position = ARBodyDataParse.GetGroundVet(centerChest, 0, 0, 2);
                    //双掌向前推动作
                    ARDebug.Log("chayao wistFront");

                    if (!audios[2].activeSelf)
                    {
                        audios[2].SetActive(true);
                    }
                    audios[2].GetComponent<AudioSource>().Play();
                    return;
                }
            }
        }

        bool wistTogether = false;

        private void StaticPose(List<OutPutData> lstVet)
        {
            for (int i = 0; i < lstVet.Count; i++)
            {
                if (i == 4)
                {
                    if (ARHumanBodyDataParse.StaticPose(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos, lstVet[i - 2].VectorScreenPos, lstVet[i + 4].VectorScreenPos) ||
                        ARHumanBodyDataParse.StaticPose(lstVet[i + 3].VectorScreenPos, lstVet[i + 2].VectorScreenPos, lstVet[i + 1].VectorScreenPos, lstVet[i + 7].VectorScreenPos)
                       )
                    {
                        IsWistFrontChest = false;
                        wistTogether = false;
                        FistInWaistFrameCount = 0;

                    }

                    FistInWaist(lstVet, i);
                    FistFrontChest(lstVet, i);
                    FistFrontIn(lstVet, i);
                }
            }
        }


        IEnumerator WaitFrontChestEnable()
        {
            float TimeDelay = 2.0f;
            float CurrentTime = Time.time;
            while (CurrentTime + TimeDelay > Time.time)
            {
                yield return null;
            }
            IsWistFrontChest = false;
        }

    }
}
