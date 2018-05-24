using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace BaiduARInternal
{
    public class ARExampleLoadScene : MonoBehaviour
    {


        private RectTransform MenuPanel;

        public enum MenuItem
        {
            //ARExampleImageTrackerBee,
            ARExampleMainMenu,

            ARExampleObjectTrackerBear,
			ARExampleImageRecognition,
            ARExampleImageTrackerCity,
            //ARExampleObjectTrackerDragon,
            ARExampleContinuous,
			ARExampleRecogGestrue

        }

        private void Start()
        {
            if (null == MenuPanel)
                MenuPanel = GetComponent<RectTransform>();
            int adjustHeight = 0;
            if (ARUtils.IsIPhoneX())
            {
                adjustHeight = 100;
            }



            MenuPanel.anchoredPosition3D = new Vector3(MenuPanel.anchoredPosition3D.x, MenuPanel.anchoredPosition3D.y - adjustHeight, MenuPanel.anchoredPosition3D.z);

        }

        private MenuItem _item;

        public void SelectLoadScene(string scene)
        {
            switch (scene)
            {
//                case "ARExampleImageTrackerBee":
//                    {
//                        _item = MenuItem.ARExampleImageTrackerBee;
//                        break;
//                    }
                case "ARExampleMainMenu":
                    {
                        _item = MenuItem.ARExampleMainMenu;
                        break;
                    }
                case "ARExampleObjectTrackerBear":
                    {
                        _item = MenuItem.ARExampleObjectTrackerBear;
                        break;
                    }
			    case "ARExampleImageRecognition":
                    {
					_item = MenuItem.ARExampleImageRecognition;
                        break;
                    }
                case "ARExampleImageTrackerCity":
                    {
                        _item = MenuItem.ARExampleImageTrackerCity;
                        break;
                    }
//                case "ARExampleObjectTrackerDragon":
//                    {
//                        _item = MenuItem.ARExampleObjectTrackerDragon;
//                        break;
//                    }
                case "ARExampleContinuous":
                    {
                        _item = MenuItem.ARExampleContinuous;
                        break;
                    }
			    case "ARExampleRecogGestrue":
                    {
					_item = MenuItem.ARExampleRecogGestrue;
                        break;
                    }
                default:
                    {
                        print("没有该场景");
                        break;
                    }
            }
            //		if (_item != null) {
            GetLoadScene(_item.ToString());
            //}
        }
        private void GetLoadScene(string scene)
        {

            print("LoadScene:" + scene);
            SceneManager.LoadScene(scene, LoadSceneMode.Single);

        }
    }
}
