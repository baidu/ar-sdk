using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BaiduARInternal;

public class ARExampleResultB : MonoBehaviour
{
    private BaiduARImageRecognitionResult _result;
    private ARExampleResultA _resultA;
	[HideInInspector]
	public GameObject city;
	[HideInInspector]
	public bool _isShowB;
    // Use this for initialization
    void Start()
    {
        _isShowB = false;

		_result = gameObject.GetComponent<BaiduARImageRecognitionResult>();
        _result.OnRespond.AddListener(CreateObject);
        _resultA = GameObject.FindObjectOfType<ARExampleResultA>();

       // CreateObject();
    }

    public void CreateObject()
    {
        if (city == null)
        {

            GameObject obj = Resources.Load("City_Map") as GameObject;
            city = Instantiate(obj, new Vector3(0, -10f, 500f), Quaternion.identity);
			city.transform.eulerAngles = new Vector3 (180, -90, 90);

            _isShowB = true;
            print("City_Map:" + city.name);
        }

        if (_resultA._isShowA)
        {

            _resultA.bear.SetActive(false);
            _resultA._isShowA = false;

            _isShowB = true;
            city.SetActive(true);

        }


    }
}
