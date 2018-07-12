using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BaiduARInternal;

public class ARExampleResultA : MonoBehaviour
{

    private BaiduARImageRecognitionResult _result;
    private ARExampleResultB _resultB;
	public GameObject bear;
	public bool _isShowA;
    // Use this for initialization
    void Start()
    {
        _isShowA = false;

        _result = gameObject.GetComponent<BaiduARImageRecognitionResult>();
        _result.OnRespond.AddListener(CreateObject);
        _resultB = GameObject.FindObjectOfType<ARExampleResultB>();

    }

    public void CreateObject()
    {

        if (bear == null)
        {
            GameObject obj = Resources.Load("Bear") as GameObject;
            bear = Instantiate(obj, new Vector3(0, -10f, 300f), Quaternion.identity);
			bear.transform.eulerAngles = new Vector3 (0, 180, 0);

            _isShowA = true;
            print("bear:" + bear.name);
        }
        if (_resultB._isShowB)
        {
            _resultB.city.SetActive(false);
            _resultB._isShowB = false;

            bear.SetActive(true);
            _isShowA = true;


        }

    }

}
