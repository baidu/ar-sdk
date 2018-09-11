using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class ARHumanExampleFootLift : MonoBehaviour {

        public ObjectsPool objs = new ObjectsPool();

        public GameObject[] FootLiftEffect = new GameObject[2];

        public GameObject sound_footLift;
      
        bool[] IsFootUp = new bool[2]{false,false};
        bool[] IsFootDown = new bool[2]{ false, false };


        IEnumerator ActionDisable_One(int index)
        {
            int TimeCount = 2;
            float TimeCurrent = Time.time;
            while(TimeCurrent + TimeCount > Time.time)
            {
                yield return new WaitForSeconds(0.2f);
            }
            IsFootUp[index] = false;
            IsFootDown[index] = false;
        }
        IEnumerator ActionDisable_Two(int index)
        {
            int TimeCount = 2;
            float TimeCurrent = Time.time;
            while (TimeCurrent + TimeCount > Time.time)
            {
                yield return new WaitForSeconds(0.2f);
            }
            IsFootUp[index] = false;
            IsFootDown[index] = false;
        }
        GameObject[] goEffect = new GameObject[2];

        float deltime = 0;
        private void StartEffect(Vector3 vet, int index)
        {
            if (Time.time - deltime <1)
            {
                return;
            }
            deltime = Time.time;
          //  ARDebug.Log("vet.x = "+vet.x + " vet.y ="+vet.y +" vet.z = "+vet.z);
            Vector3 vetRet = ARHumanBodyDataParse.GetGroundVet(vet,0,-60,5000/ARHumanBodyDataParse.lengthShoulder);
          //  if (goEffect[index] == null){
                goEffect[index] = Instantiate(FootLiftEffect[index]) as GameObject;
                goEffect[index].SetActive(true);
                goEffect[index].transform.position = vetRet;
            //}
        }

        public bool CheckEffect(int index,Vector3 firstVet,Vector3 secondVet,Vector3 endVet,Vector3 dstVet)
        {
            if (!IsFootUp[index])
            {
               // IsFootUp[index] = ARBodyDataParse.FootLift(firstVet, secondVet,endVet,dstVet);
                IsFootUp[index] = ARHumanBodyDataParse.FootLift(firstVet,index);
                if (IsFootUp[index])
                {
                    ARDebug.Log("index = "+index);
                    if (index== 0){
						StopCoroutine("ActionDisable_One");
                        StartCoroutine("ActionDisable_One",index);
                    }else
                    {
                        StopCoroutine("ActionDisable_Two");
                        StartCoroutine("ActionDisable_Two", index);
                    }
                }

                //StartEffect(firstVet, index);
            }
            else
            {
                IsFootDown[index] = ARHumanBodyDataParse.FootDown(firstVet,index,endVet);
                if (IsFootDown[index])
                {
                    //ARDebug.Log("index11 = " + index);
                    IsFootUp[index] = false;
                    IsFootDown[index] = false;
                    //开启特效
                    StartEffect(firstVet, index);
                    return true;
                }
            }

            return false;
        }
    
        public void FootLift(List<OutPutData> lstVet)
        {
            for (int i = 0; i < lstVet.Count; i++)
            {
                if (i == 10)
                {
                    if (lstVet[10].score > 0.5 && lstVet[8].score > 0.5 && lstVet[13].score > 0.5)
                    {
                        bool retData = CheckEffect(0, lstVet[10].VectorScreenPos, lstVet[8].VectorScreenPos, lstVet[13].VectorScreenPos, lstVet[11].VectorScreenPos);

                        if (retData)
                        {
                            if (!sound_footLift.activeSelf)
                            {
                                sound_footLift.SetActive(true);
                            }
                            sound_footLift.GetComponent<AudioSource>().Play();
                          
                            return;
                        }

                        // audios[1].GetComponent<AudioSource>().Play();
                    }
                }
                if (i == 13)
                {
                    if (lstVet[13].score > 0.5 && lstVet[11].score > 0.5 && lstVet[10].score > 0.5)
                    {
                        bool retData = CheckEffect(1, lstVet[13].VectorScreenPos, lstVet[11].VectorScreenPos, lstVet[10].VectorScreenPos, lstVet[8].VectorScreenPos);

                        if (retData)
                        {
                            if (!sound_footLift.activeSelf)
                            {
                                sound_footLift.SetActive(true);
                            }
                            sound_footLift.GetComponent<AudioSource>().Play();
                            return;
                        }

                        //  audios[1].GetComponent<AudioSource>().Play();
                    }
                }
              //  sound_footLift.SetActive(false);
            }
        }
    }
}
