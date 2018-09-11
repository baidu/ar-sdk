using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BaiduARInternal;
using UnityEngine.EventSystems;
using UnityEngine.UI;
public class ARExampleGestrue : MonoBehaviour
{

    private Vector3 _beginMovePosition;
    private Vector3 _beginRotatePosition;

    private GameObject _target;

	private BaiduARObjectTrackable _arObjectTrackle;
	private BaiduARObjectTracker arObjectTracker;
	private BaiduARWebCamera _cameraDevice;
    //旋转速度
    public float _rotateSpeed = 10f;
    public float _zoomSpeed = 10f;

    //public Text _text;

    private Touch oldTouch_1;
    private Touch oldTouch_2;

	private GameObject canvas;
    // Use this for initialization
    void Start()
    {
        _target = transform.gameObject;

		_arObjectTrackle = transform.GetComponent<BaiduARObjectTrackable>();
		arObjectTracker = FindObjectOfType<BaiduARObjectTracker> ();	
		_cameraDevice = FindObjectOfType<BaiduARWebCamera> ();

		canvas = GameObject.Find ("Canvas");

    }

    // Update is called once per frame
    void Update()
    {
        //判断物体是否在UI上
		if (canvas == null || !EventSystem.current.currentSelectedGameObject)
        {
            if (Input.touchCount == 1)
            {
                MoveObject(Input.touches[0]);

            }
            if (Input.touchCount > 1)
            {
                ZoomObject(Input.touches[0], Input.touches[1]);
            }
        }
    }


    //移动
    public void MoveObject(Touch touch)
    {
        if (touch.phase == TouchPhase.Began)
        {
			arObjectTracker.StopAR();

            _beginMovePosition = new Vector3(touch.position.x, touch.position.y, 0);
        }

        if (touch.phase == TouchPhase.Moved)
        {
            Vector3 objPos = Camera.main.WorldToScreenPoint(_target.transform.position);
            Vector3 pos = new Vector3(touch.position.x, touch.position.y, 0) - _beginMovePosition;

            objPos += pos;
            
            _target.transform.position = Camera.main.ScreenToWorldPoint(objPos);
            _beginMovePosition = new Vector3(touch.position.x, touch.position.y, 0);

        }

        if (touch.phase == TouchPhase.Ended)
        {
			_arObjectTrackle.UpdateSlamPos();

			arObjectTracker.StartAR();

        }
    }

    //缩放和旋转
    public void ZoomObject(Touch touch_1, Touch touch_2)
    {
        Touch newTouch_1 = touch_1;
        Touch newTouch_2 = touch_2;

        if (newTouch_2.phase == TouchPhase.Began)
        {
			arObjectTracker.StopAR();
            //_target = GameObject.Find("Cube").gameObject;
            _beginRotatePosition = new Vector3(touch_1.position.x, touch_1.position.y, 0);

            oldTouch_1 = newTouch_1;
            oldTouch_2 = newTouch_1;
        }
        if (newTouch_1.phase == TouchPhase.Moved && newTouch_2.phase == TouchPhase.Moved)
        {
            //根据差值判断缩放
            float disBegin = Vector3.Distance(oldTouch_1.position, oldTouch_2.position);
            float disNow = Vector3.Distance(newTouch_1.position, newTouch_2.position);
            float offset = disNow - disBegin;

            //判断向量夹角
            Vector3 touchVector_1 = newTouch_1.position - oldTouch_1.position;
            Vector3 touchVector_2 = newTouch_2.position - oldTouch_2.position;
            float angle = Vector3.Dot(touchVector_1, touchVector_2);

            //缩放
            if (angle < 0)
            {
                if (offset > 0)
                {
                    _target.transform.localScale += new Vector3(_zoomSpeed, _zoomSpeed, _zoomSpeed);

                }
                else
                {	
					if (_target.transform.localScale.x > 1f + _zoomSpeed) {
						_target.transform.localScale -= new Vector3 (_zoomSpeed, _zoomSpeed, _zoomSpeed);
					}
                    
                }
            }

            //旋转
            else
            {
                Vector3 nowPos = touch_1.position;
                //求方向
                Vector3 dir = nowPos - _beginRotatePosition;
                _target.transform.Rotate(new Vector3(dir.y, -dir.x, dir.z).normalized * _rotateSpeed, Space.World);

                _beginRotatePosition = nowPos;
            }

            oldTouch_1 = newTouch_1;
            oldTouch_2 = newTouch_2;
        }
        if (newTouch_1.phase == TouchPhase.Ended || newTouch_2.phase == TouchPhase.Ended)
        {
			_arObjectTrackle.UpdateSlamPos();
			arObjectTracker.StartAR();
        }
    }
}
