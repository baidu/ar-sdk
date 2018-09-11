using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace BaiduARInternal
{
    public class CreateOnKill : MonoBehaviour
    {

        public bool killed = false;
        public GameObject[] prefab;

        public void Kill()
        {
           // Debug.Log("jinnsddsdsdsnnnnnn");
            //if (killed) return;
            //killed = true;
           // Debug.Log("jinnnnnnnn");
            foreach (var p in prefab)
            {
                GameObject ins = Instantiate(p, transform.position, Random.rotation);
                if (ins.GetComponent<Rigidbody>())
                {
                    ins.GetComponent<Rigidbody>().velocity = Random.onUnitSphere + Vector3.up;
                    ins.GetComponent<Rigidbody>().AddTorque(Random.onUnitSphere * 1, ForceMode.Impulse);
                }
            }
        }
        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {

        }
    }
}
