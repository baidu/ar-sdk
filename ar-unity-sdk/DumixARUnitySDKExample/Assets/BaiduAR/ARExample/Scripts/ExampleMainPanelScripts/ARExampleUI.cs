using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using BaiduARInternal;

public class ARExampleUI : MonoBehaviour
{

    public GameObject loading;
    public GameObject _infoUI;
    public Button _sureButton;

    private Button _resetButton;

	private BaiduARWebCamera _cameraDevice;
	private BaiduARObjectTrackable _arObjectTrackle;


    //private RectTransform returnBtn;
    private RectTransform resetBtn;


    // Use this for initialization
    void Start()
    {
        //ARLogin.Instance.OnStopCamera.AddListener (ErrorInfo);
        loading.SetActive(true);

        _sureButton.onClick.AddListener(ErrorOnClick);

		_cameraDevice =  FindObjectOfType<BaiduARWebCamera>();
        Transform bg = transform.Find("ResetButton");

        if (bg != null)
        {
            resetBtn = bg.GetComponent<RectTransform>();
            _resetButton = bg.GetComponent<Button>();
            _resetButton.onClick.AddListener(ResetOnClick);
			_arObjectTrackle = GameObject.FindObjectOfType<BaiduARObjectTrackable>();
        }

        int adjustHeight = 0;
        ARDebug.Log("SystemInfo.deviceModel = " + SystemInfo.deviceModel);

        ARDebug.Log("SystemInfo.nam = " + SystemInfo.deviceName);
        if (ARUtils.IsIPhoneX())
        {
            adjustHeight = 100;
        }

        if (null != resetBtn)
            resetBtn.anchoredPosition3D = new Vector3(resetBtn.anchoredPosition3D.x, resetBtn.anchoredPosition3D.y + 2 * adjustHeight, resetBtn.anchoredPosition3D.z); ;

    }

    public void ErrorInfo(string num, string msg)
    {
        _infoUI.SetActive(true);

        ARDebug.LogWarning("msg =" + msg + "  error=" + num);
        if (num != null && msg != null)
        {
			_infoUI.transform.Find("Error").GetComponent<Text>().text = num + ": "+msg;

        }
        else
        {
            _infoUI.transform.Find("Error").GetComponent<Text>().text = "出错了！";
        }

    }

    public void ErrorOnClick()
    {
        Application.Quit();
    }

    public void ResetOnClick()
    {

        ARObjectTracker.Instance.ResetModel();

        Vector3 pos = new Vector3(0.5f * _cameraDevice.width, 0.5f * _cameraDevice.height, 0);

        _arObjectTrackle.x = _cameraDevice.width - pos.x;
        _arObjectTrackle.y = _cameraDevice.height - pos.y;
    }

    private void Update()
    {
        if (_cameraDevice.isLoad)
        {
            loading.SetActive(false);
        }
    }

}
