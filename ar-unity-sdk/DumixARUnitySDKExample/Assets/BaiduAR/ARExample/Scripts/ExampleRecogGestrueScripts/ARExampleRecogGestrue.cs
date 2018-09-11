using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BaiduARInternal;
using System.Reflection;

public class ARExampleRecogGestrue : MonoBehaviour {

	private BaiduARGestureRecog gestureRecog;
	public GameObject particleObj;

	private ParticleSystem particle;

	public bool isStartHandTracking = true;

	// Use this for initialization
	void Start () {

		gestureRecog = gameObject.GetComponent<BaiduARGestureRecog> ();
		particle = particleObj.transform.GetComponent<ParticleSystem> ();
      
		if (isStartHandTracking) {
            var main = particle.main;
            main.loop = true;

			//System.Type type = particle.main.GetType ();
			//PropertyInfo property = type.GetProperty ("loop");
            //property.SetValue (particle.main, true, null);
  
		}

		//手势识别
		gestureRecog.OnResultCallBack((bool result) =>{
			if (!isStartHandTracking) {

			   ShowObject(result);
			}

		});
			
		//实验室功能 手势跟踪
		gestureRecog.OnResultTrackCallBack((List<RecogGesture> lstRecg) =>{
			ARDebug.Log("lstRecg.Count; "+lstRecg.Count);
			//recogList = lstRecg;
			if (isStartHandTracking) {
				MoveObject (lstRecg);
			}

		});

	}


	void MoveObject(List<RecogGesture> recog){

		particleObj.transform.position = recog [0].GetCenterPos;
		if (!particle.isPlaying) {
			particle.Play (true);
		}
	}

	void ShowObject(bool isrecognition){
		ARDebug.Log("isrecognition: "+isrecognition);
		if (isrecognition) {
			if (!particle.isPlaying) {
				particle.Play ();
			}
		} 
		else {
			if (!particle.isPlaying) {
				particle.Stop ();
			}
		}
		particleObj.transform.position = new Vector3 (0, 0, 100);

	}
}
