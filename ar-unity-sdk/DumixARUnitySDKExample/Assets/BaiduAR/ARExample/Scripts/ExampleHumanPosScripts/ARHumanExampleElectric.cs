using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class ARHumanExampleElectric : MonoBehaviour {

        public ObjectsPool objs = new ObjectsPool();

        public GameObject[] Electrics = new GameObject[5];

        public GameObject sound_Electric;

     
        public void ShowElectric(int index,Vector3 vetRet,float angle)
        {
            if (!Electrics[index].activeSelf)
            {
                Electrics[index].SetActive(true);
            }
           // ARDebug.Log(" vetRetx = " + vetRet.x + " vetRety = " + vetRet.y + " vetRetz = " + vetRet.z + " angle = " + angle);
            Electrics[index].transform.position = vetRet;
            Electrics[index].transform.eulerAngles = new Vector3(0, 0, angle);
        }	
        public void HideElectric()
        {
            for (int i = 0; i < Electrics.Length;i++)
            {
                Electrics[i].SetActive(false);
            }
            sound_Electric.SetActive(false);
        }

        public void Electric(List<OutPutData> lstVet)
        {
            for (int i = 0; i < lstVet.Count; i++)
            {
                if (i == 1 || i == 4 || i == 7 || i == 10 || i == 13
                   ||i == 3||i == 6) //电流
                {
                    Vector3 vetRet = ARHumanBodyDataParse.GetElectricVet(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos);
                    float angle = ARHumanBodyDataParse.GetAngleBetweenPos(lstVet[i].VectorScreenPos, lstVet[i - 1].VectorScreenPos);
                    if (i == 1)
                    {
                        Vector3 centerVet = (lstVet[i + 7].VectorScreenPos + lstVet[i + 10].VectorScreenPos) / 2;

                        // Vector3 centerVet = lstVet[i + 7].VectorScreenPos;
                        vetRet = ARHumanBodyDataParse.GetElectricVet(lstVet[i].VectorScreenPos, centerVet);
                        angle = ARHumanBodyDataParse.GetAngleBetweenPos(lstVet[i].VectorScreenPos, centerVet);

                        if (lstVet[i].score < 0.5 || lstVet[i + 7].score < 0.5 || lstVet[i + 10].score < 0.5)
                        {
                            Electrics[4].SetActive(false);
                            sound_Electric.SetActive(false);
                            continue;
                        }
                        ShowElectric(4, vetRet, angle);


                        if (!sound_Electric.activeSelf)
                        {
                            sound_Electric.SetActive(true);
                        }
                    }

                    //continue;
                    if (i == 4)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[0].SetActive(false);
                            continue;
                        }
                        ShowElectric(0, vetRet, angle);
                    }
                    if (i == 7)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[1].SetActive(false);
                            continue;
                        }
                        ShowElectric(1, vetRet, angle);
                    }
                    if (i == 10)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[2].SetActive(false);
                            continue;
                        }
                        ShowElectric(2, vetRet, angle);
                    }
                    if (i == 13)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[3].SetActive(false);
                            continue;
                        }
                        ShowElectric(3, vetRet, angle);
                    }

                    if (i == 3)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[5].SetActive(false);
                            continue;
                        }
                        ShowElectric(5, vetRet, angle);
                    }
                    if (i == 6)
                    {
                        if (lstVet[i].score < 0.5 || lstVet[i - 1].score < 0.5)
                        {
                            Electrics[6].SetActive(false);
                            continue;
                        }
                        ShowElectric(6, vetRet, angle);
                    }
                }

            }
        }
    }
}
