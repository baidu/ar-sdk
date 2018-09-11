using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace BaiduARInternal
{
    public class DisPatchFruit : MonoBehaviour
    {
        private ObjectsPool poolApple = new ObjectsPool();
        private ObjectsPool poolPineapple = new ObjectsPool();
        private ObjectsPool poolWatermelon = new ObjectsPool();

        private ObjectsPool poolCurrentFruit;


        public GameObject[] fruits;
        public GameObject bomb;

        public float z;
        public AudioClip sfx;
        public bool pause = false;
        public float timer = 3.0f;
        public bool started = false;
        public float powerMod;

        public float StartY;

        private void Awake()
        {
            Physics.gravity = new Vector3(0, -4, 0);

            powerMod = 1.0f;

        }
        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
          
            //return;
            if (pause)
            {
                return;
            }

            timer -= Time.deltaTime;
            if (timer <= 0.0 && !started)
            {
                timer = 0.0f;
                started = true;
            }

            if (started)
            {
                if (timer <= 0.0)
                {
                    DisPatchUp();
                    timer = 0.8f; //1.3秒钟一次
                }
            }
        }

        void DisPatchUp()
        {
            InitFruit(false);
        }

        void InitFruit(bool isbomb)
        {
            int RangeFruit = Random.Range(0, fruits.Length);
            float x = Random.Range(-4.5f, 4.5f);
            z += 1.5f;
            if (z >= 6.0) z = 0;

            GameObject gameOb;
            Vector3 vet = transform.position + new Vector3(x, StartY, z);
            Vector3 scaleVet = Vector3.one;

            if (!isbomb)
            {
                switch(RangeFruit)
                {
                    case 0:
                        poolCurrentFruit = poolApple;
                        scaleVet = Vector3.one * 1500;
                        break;
                    case 1:         
                        poolCurrentFruit = poolPineapple; 
                        scaleVet = Vector3.one * 400;
                        //菠萝
                        break;
                    case 2:          //西瓜
                        poolCurrentFruit = poolWatermelon;
                        scaleVet = Vector3.one * 600;
                        break;
                    default:break;
                }
                gameOb = poolCurrentFruit.GetItem();
                if (gameOb == null)
                {
                    gameOb = Instantiate(fruits[RangeFruit], vet, Random.rotation);
                   // gameOb.transform.parent = gameObject.transform;
                    poolCurrentFruit.Add(gameOb);
                }
                gameOb.SetActive(true);
               // gameOb.SetActive(false);
                gameOb.transform.position = vet;
                gameOb.transform.localScale = scaleVet;
                gameOb.transform.localRotation = Quaternion.identity;
                //gameOb = GameObject.Instantiate(fruits[RangeFruit], vet, Random.rotation);
            }
            else
            {
                gameOb = Instantiate(bomb, vet, Random.rotation);
            }

            float power = Random.Range(1.6f, 1.7f) * -Physics.gravity.y * 1.5f * powerMod;
            var direction = new Vector3(-x * 0.05f * Random.Range(0.32f, 0.81f), 1.0f);
            direction.z = 0.0f;
            gameOb.GetComponent<Rigidbody>().velocity = direction * power;
            gameOb.GetComponent<Rigidbody>().AddTorque(Random.onUnitSphere * 0.1f, ForceMode.Impulse);

            GetComponent<AudioSource>().PlayOneShot(sfx, 2);
        }

        public void HideFruit(GameObject item)
        {
            //if (null != poolCurrentFruit)
            //{
            //    poolCurrentFruit.RemoveItem(item);
            //}
           // Debug.Log("item = "+item.name);
            switch(item.name)
            {
                case "apple_a(Clone)":
                    
                    poolApple.RemoveItem(item);
                    break;
                case "fineaple_a(Clone)":
                    poolPineapple.RemoveItem(item);
                    break;
                case "watermelon_a(Clone)":
                    poolWatermelon.RemoveItem(item);
                    break;
                default:
                    Destroy(item);
                    break;
            }




        }
        private void OnTriggerEnter(Collider other)
        {
        //    Debug.Log("jinllll");
            HideFruit(other.gameObject);
            //Destroy(other.gameObject);
        }
    }
}
