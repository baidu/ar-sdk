using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public enum HumanPoseType
    {
        POSE_LEFTHAND,
        POSE_RIGHTHAND,
        POSE_LEFTWRIST,
        POSE_RIGHTWRIST
    };
    public class HumanPoseNode
    {
        public int HP_LinePart;
        public LineRenderer HP_Trail;
        public Vector3[] HP_TrailPositions = new Vector3[10];
    }
    public class StateManager
    {
        public Dictionary<HumanPoseType, HumanPoseNode> lstHuamPose = new Dictionary<HumanPoseType, HumanPoseNode>();

        private HumanPoseNode LEFTHANDPose = new HumanPoseNode();
        private HumanPoseNode RIGHTHANDPose = new HumanPoseNode();
        private HumanPoseNode LEFTWRISTPose = new HumanPoseNode();
        private HumanPoseNode RIGHTWRISTPose = new HumanPoseNode();

        public void InitData()
        {
            lstHuamPose.Add(HumanPoseType.POSE_LEFTHAND, LEFTHANDPose);
            lstHuamPose.Add(HumanPoseType.POSE_RIGHTHAND, RIGHTHANDPose);
            lstHuamPose.Add(HumanPoseType.POSE_LEFTWRIST, LEFTWRISTPose);
            lstHuamPose.Add(HumanPoseType.POSE_RIGHTWRIST, RIGHTWRISTPose);
        }

        public HumanPoseNode FindHumanPoseByType(HumanPoseType hpt)
        {
            return lstHuamPose[hpt];
        }
    };

    public class CollideManage : MonoBehaviour
    {

       // public GameObject elictricsItem;
        //public GameObject elictricsRoot;
      //  private GameObject[] elictrics = new GameObject[1];

        private ObjectsPool poolAppleEffect = new ObjectsPool();
        private ObjectsPool poolPineappleEffect = new ObjectsPool();
        private ObjectsPool poolWatermenoEffect = new ObjectsPool();

        public HumanPoseType currentHumanPoseType = HumanPoseType.POSE_RIGHTHAND;
        private StateManager stateManager = new StateManager();

        public GameObject ColiBox;

        public GameObject[] SplashEffectPrefab;
        public AudioClip[] SoundVoide;
        public AudioSource audioSources;

        public AudioClip friutSound;

        private GameObject currentObject;
        private bool IsMouseDown;
        private Vector3 startVec;

        public LineRenderer trail_leftHand;
        public LineRenderer trail_rightHand;
        public LineRenderer trail_leftwrist;
        public LineRenderer trail_rightwrist;

        private void InitData()
        {
            stateManager.InitData();
            // HumanPoseNode lefthand = stateManager.FindHumanPoseByType(HumanPoseType.POSE_LEFTHAND);
            FirstInit(stateManager.FindHumanPoseByType(HumanPoseType.POSE_LEFTHAND), trail_leftHand);
            FirstInit(stateManager.FindHumanPoseByType(HumanPoseType.POSE_LEFTWRIST), trail_leftwrist);
            FirstInit(stateManager.FindHumanPoseByType(HumanPoseType.POSE_RIGHTHAND), trail_rightHand);
            FirstInit(stateManager.FindHumanPoseByType(HumanPoseType.POSE_RIGHTWRIST), trail_rightwrist);
        }
        #if UNITY_EDITOR
        void Update()
        {
            Vector3 vet = new Vector3(Screen.width / 2 + Random.Range(0, 100), Screen.height / 2 + Random.Range(0, 100));
            Vector3 vet1 = new Vector3(100 + Random.Range(0, 100), 100 + Random.Range(0, 100));
            Vector3 vet2 = new Vector3(300 + Random.Range(0, 100), 300 + Random.Range(0, 100));
            Vector3 vet3 = new Vector3(900 + Random.Range(0, 100), 400 + Random.Range(0, 100));
            // HandleData_knee(vet);
            HandleData(vet, HumanPoseType.POSE_RIGHTWRIST);
            //SetTexiaoPos(vet);
            HandleData(vet1, HumanPoseType.POSE_LEFTHAND);
            // SetTexiaoPos(vet1);
            HandleData(vet2, HumanPoseType.POSE_RIGHTHAND);
            // SetTexiaoPos(vet2);
            HandleData(vet3, HumanPoseType.POSE_LEFTWRIST);
            SetTexiaoPos(new Vector2(900, 400));

            int rang = Random.Range(0, 1);
            ShowElectric(rang, 0.5f, vet3);
        }
        #endif

        public void ShowElectric(int i, float score, Vector2 vet)
        {
            //Debug.Log("score = "+score);
            if (score > 0.3)
            {
                nCurrentVet = vet;
                nCurrentVet.z = 16;
                //Vector3 splashZ = Camera.main.ScreenToWorldPoint(nCurrentVet);
                //			elictrics[i].transform.position = splashZ;
                //          elictrics[i].gameObject.SetActive(true);
            }
            else
            {
                // elictrics[i].gameObject.SetActive(false);
            }
        }
        void Start()
        {
            InitData();
        }
        private void FirstInit(HumanPoseNode hpn, LineRenderer lrender)
        {
            trial_alpha = 1.0f;
            start = screenInp;
            end = screenInp;
            hpn.HP_LinePart = 0;
            hpn.HP_Trail = lrender;
            AddTrailPosition(hpn);
            started = true;
        }
        public void AddTrailPosition(HumanPoseNode hpn)
        {
            if (hpn.HP_LinePart > 9)
            {
                for (int i = 0; i <= 8; i++)
                {
                    hpn.HP_TrailPositions[i] = hpn.HP_TrailPositions[i + 1];
                    hpn.HP_TrailPositions[9] = Camera.main.ScreenToWorldPoint(new Vector3(start.x, start.y, 10));
                }
            }
            else
            {
                for (int ii = hpn.HP_LinePart; ii <= 9; ii++)
                {
                    hpn.HP_TrailPositions[ii] = Camera.main.ScreenToWorldPoint(new Vector3(start.x, start.y, 10));
                }
            }
        }




        public float trial_alpha = 0.0f;

        public bool started = false;
        Vector3 start;
        Vector3 end;

        public bool fire = false;
        public bool fire_prev = false;
        public bool fire_down = false;
        public bool fire_up = false;

        public Vector2 screenInp;
        int raycastCount = 10;
        float lineTimer = 0;


       
        private Vector3 nCurrentVet;

        public void SetTexiaoPos(Vector2 vet)
        {
            nCurrentVet = vet;
            nCurrentVet.z = 16;
        }

        public void HandleData(Vector2 vet, HumanPoseType hpt)
        {
            HumanPoseNode hpn = stateManager.FindHumanPoseByType(hpt);
            Vector2 Mouse;

            Mouse.x = Mathf.Clamp((vet.x - (Screen.width / 2)) / Screen.width * 2, -1, 1);
            Mouse.y = Mathf.Clamp(-(vet.y - (Screen.height / 2)) / Screen.height * 2, -1, 1);
            screenInp = Mouse;
            screenInp.x = (screenInp.x + 1) * 0.5f;
            screenInp.y = (-screenInp.y + 1) * 0.5f;
            screenInp.x *= Screen.width;
            screenInp.y *= Screen.height;

            Control(hpn);

            var c1 = new Color(1, 1, 0, trial_alpha);
            var c2 = new Color(1, 0, 0, trial_alpha);
            hpn.HP_Trail.startColor = c1;
            hpn.HP_Trail.endColor = c2;
            hpn.HP_Trail.startWidth = 0.8f;
            hpn.HP_Trail.endWidth = 0.8f;

            if (trial_alpha > 0) trial_alpha -= Time.deltaTime;
        }

        public void Control(HumanPoseNode hpn)
        {
            start = screenInp;


            var a = Camera.main.ScreenToWorldPoint(new Vector3(start.x, start.y, 10));
            var b = Camera.main.ScreenToWorldPoint(new Vector3(end.x, end.y, 10));


            if (Vector3.Distance(a, b) > 0.5f)
            {
                lineTimer = 0.25f;
                AddTrailPosition(hpn);
                hpn.HP_LinePart++;
            }

            end = screenInp;

            trial_alpha = 0.75f;


            // if (trial_alpha > 0.5)
            {

                for (var p = 0; p < 8; p++)
                {
                    for (var i = 0; i < raycastCount; i++)
                    {
                        if (Vector3.Distance(hpn.HP_TrailPositions[p], hpn.HP_TrailPositions[p + 1]) < 0.5f)
                        {
                            continue;
                        }

                        Ray ray = Camera.main.ScreenPointToRay(Vector3.Lerp(Camera.main.WorldToScreenPoint(hpn.HP_TrailPositions[p]), Camera.main.WorldToScreenPoint(hpn.HP_TrailPositions[p + 1]), i * 1.0f / raycastCount * 1.0f));

                        RaycastHit hit;

                        if (Physics.Raycast(ray, out hit, 100, (1 << 10)))
                        {
                            BlowObject(hit);
                        }
                    }
                }

            }



            //lineTimer -= Time.deltaTime;
            //if (lineTimer <= 0.0)
            //{
            //    AddTrailPosition(hpn);
            //    lineTimer = 0.01f;
            //}


            // if (fire_up && started) started = false;
            SendTrailPosition(hpn);
        }

        void SendTrailPosition(HumanPoseNode hpn)
        {
            var index = 0;
            foreach (Vector3 v in hpn.HP_TrailPositions)
            {
                hpn.HP_Trail.SetPosition(index, v);
                index++;
            }

        }

        public void BlowObject(RaycastHit hit)
        {
            if (hit.collider.gameObject.tag != "destroy")
            {
                int index = 0;
                switch (hit.collider.tag)
                {
                    case "green": index = 0; break;
                    case "yellow": index = 1; break;
                    case "red": index = 2; break;
                        // case "bomb": index = 2; break;

                }

              //  hit.collider.gameObject.tag = "destroy";

                Vector3 splashZ = hit.collider.gameObject.transform.position;
                splashZ.z -= 1;


                hit.collider.gameObject.GetComponent<CreateOnKill>().Kill();

                //Destroy(hit.collider.gameObject);

                FindObjectOfType<DisPatchFruit>().HideFruit(hit.collider.gameObject);
               // hit.collider.transform.parent.GetComponent<DisPatchFruit>().HideFruit(hit.collider.gameObject);
                    

                if (index == 3)
                {
//                    elictricsRoot.SetActive(true);
                }

                audioSources.PlayOneShot(SoundVoide[index], 1.5f);
                //   Debug.Log("splashZ.x = "+splashZ.x + "splashZ.y = " + splashZ.y + " splashZ.z ="+splashZ.z);


                //GameObject game = Instantiate(SplashEffectPrefab[index], splashZ, Quaternion.identity);
                CreateEffect(index, splashZ);

            }
        }
        private void CreateEffect(int index,Vector3 splashZ)
        {
            GameObject goEffect;
            ObjectsPool currentObjects;
            switch (index)
            {
                case 0:
                    currentObjects = poolAppleEffect;
                    break;
                case 1:
                    currentObjects = poolPineappleEffect;
                    break;
                case 2:
                    currentObjects = poolWatermenoEffect;
                    break;
                default :
                    currentObjects = poolAppleEffect;
                    break;
            }
            goEffect= currentObjects.GetItem();
            if (null == goEffect)
            {
                goEffect = Instantiate(SplashEffectPrefab[index], splashZ, Random.rotation);
                // gameOb.transform.parent = gameObject.transform;
                currentObjects.Add(goEffect);
            }
            goEffect.SetActive(true);
            goEffect.transform.position = splashZ;
            goEffect.transform.localScale = new Vector3(0.2f,0.2f,1);
            goEffect.transform.localRotation = Quaternion.identity;

        }
        public void HideEffect(GameObject item)
        {
           // Debug.Log("item = " + item.name);
            switch (item.name)
            {
                case "applejuice(Clone)":

                    poolAppleEffect.RemoveItem(item);
                    break;
                case "Orangejuices(Clone)":
                    poolPineappleEffect.RemoveItem(item);
                    break;
                case "WatermlomSplatter(Clone)":
                    poolWatermenoEffect.RemoveItem(item);
                    break;
                default:
          //          Debug.Log("item000 = " + item.name);
                    Destroy(item);
                    break;
            }
        }

        private void ObjectMove()
        {

            if (Input.GetMouseButtonDown(0))
            {
                GameObject go = GetObject();
                if (null != go && go.tag != "Plane")
                {
                    currentObject = go;
                    startVec = Input.mousePosition;
                    //  currentObjectRdby = currentObject.GetComponent<Rigidbody>();
                    // currentObjectRdby.useGravity = false;
                    IsMouseDown = true;
                }
            }
            if (IsMouseDown)
            {
                //移动
                MoveToTouch(new Touch());
            }

            if (Input.GetMouseButtonUp(0))
            {
                IsMouseDown = false;
                //   if (currentObjectRdby != null)
                //     currentObjectRdby.useGravity = true;
                return;
            }
        }
        private void MoveToTouch(Touch touch)
        {
            // Debug.Log(" Input.mousePosition = " + Input.mousePosition);
            //#if UNITY_EDITOR
            //        Vector3 pos = Input.mousePosition - startVec;
            //#else
            //        Vector3 pos = new Vector3(touch.position.x,touch.position.y,0) - startVec;
            //#endif
            //        Vector3 objectScreenPos = Camera.main.WorldToScreenPoint(currentObject.transform.position);
            //        objectScreenPos += pos;
            //        Debug.Log(" pos = " + pos);
            //        currentObject.transform.position = Camera.main.ScreenToWorldPoint(objectScreenPos);
            //#if UNITY_EDITOR
            //        startVec = Input.mousePosition;
            //#else
            //        startVec = new Vector3(touch.position.x,touch.position.y,0);
            //#endif
            Vector3 pos = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, 10));
            currentObject.transform.position = pos;


        }

        private GameObject GetObject()
        {
            Debug.Log("Input.mousePosition.x = " + Input.mousePosition.x);
            Debug.Log("Input.mousePosition.y = " + Input.mousePosition.y);
            Debug.Log("Input.mousePosition.z = " + Input.mousePosition.z);

            //    return ColiBox;
            Vector2 pos = new Vector2(0, 0);

            GameObject gameObj = null;
            Ray ray = Camera.main.ScreenPointToRay(pos);
            RaycastHit hitInfo;
            if (Physics.Raycast(ray, out hitInfo))
            {
                Debug.DrawLine(ray.origin, hitInfo.point);//划出射线，只有在scene视图中才能看到
                                                          //划出射线，只有在scene视图中才能看到
                gameObj = hitInfo.collider.gameObject;
                Debug.DrawLine(ray.origin, hitInfo.point);
                Debug.Log("click object name is " + gameObj.name);
                //当射线碰撞目标为boot类型的物品，执行拾取操作
                if (gameObj.tag == "boot")
                {
                    Debug.Log("pickup!");
                }
            }
            return gameObj;
        }
    }
}
