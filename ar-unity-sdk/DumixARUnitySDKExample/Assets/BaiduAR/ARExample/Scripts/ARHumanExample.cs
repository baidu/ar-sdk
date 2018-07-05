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
    public class ARHumanExample : ARSingleton<ARHumanExample> {
        
        public Transform CirCleParent;
        public GameObject Circle;

        public ObjectsPool objs = new ObjectsPool();

       

        public GameObject CreateCircleGame()
        {
            GameObject it = GameObject.Instantiate(Circle) as GameObject;
            it.transform.parent = CirCleParent;
            it.transform.localPosition = Vector3.zero;
            it.transform.localScale = Vector3.one * 10;
          
            // it.transform.localRotation = Quaternion.identity;
            it.transform.eulerAngles = new Vector3(-180, 0, 0);
            return it;
        }
        private void ClearCircle()
        {
            for (int i = 0; i < CirCleParent.childCount; i++)
            {
                Destroy(CirCleParent.GetChild(i).gameObject);
            }
        }
       
        // Use this for initialization
        private void InitCircle (Vector3 pos) 
        {
            
            GameObject item = objs.GetItem();
            if (item == null)
            {
                item = CreateCircleGame();
                objs.Add(item);
            }
            item.SetActive(true);
            item.transform.position =pos;

        }
        
    }
}
