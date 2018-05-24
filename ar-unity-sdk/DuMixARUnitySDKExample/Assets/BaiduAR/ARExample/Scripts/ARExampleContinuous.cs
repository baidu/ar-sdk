using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using BaiduARInternal;

public class ARExampleContinuous : MonoBehaviour
{

    private BaiduARImageRecognitionResult[] results;
    public GameObject imageTracker;
    public AudioSource audioSource;

    private GameObject currentObj;
    private BaiduARImageTrackable currentTrackable;

    //private bool isResetAnimator;
    private AudioClip[] clips;
    private Animator anim;
    private int currentIndex = 0;

    // Use this for initialization
    void Start()
    {
		results = GameObject.FindObjectsOfType<BaiduARImageRecognitionResult>();

		BaiduARImageTracker tracker = imageTracker.GetComponent<BaiduARImageTracker>();
        for (int i = 0; i < results.Length; i++)
        {

            for (int j = 0; j < imageTracker.transform.childCount; j++)
            {

                GameObject obj = imageTracker.transform.GetChild(j).gameObject;
                BaiduARImageTrackable trackable = obj.GetComponent<BaiduARImageTrackable>();

                if (results[i].filePath.Contains(trackable.filePath))
                {
                    results[i].OnRespond.AddListener(
                        delegate ()
                        {
                            this.ShowObject(trackable.gameObject);
                        });
                    break;

                }
            }

        }
		tracker.OnTrackFail.AddListener(OutFocus);
    }

    void ShowObject(GameObject obj)
    {

        if (!imageTracker.activeSelf)
        {
            imageTracker.SetActive(true);
        }

		if (currentObj == null || currentObj != obj)
        {

            currentObj = obj;

            BaiduARImageTrackable trackable = obj.GetComponent<BaiduARImageTrackable>();
            trackable.gameObject.SetActive(true);

            anim = obj.GetComponent<Animator>();
            clips = obj.GetComponent<BaiduARImageTrackable>().clips;

            currentIndex = 0;
            if (audioSource.isPlaying)
            {
                audioSource.Stop();
            }

            ARDebug.Log("trackable.filePath: " + trackable.filePath);
            ARImageTracker.Instance.SetActiveTrack(trackable.filePath);
        }

    }

    void OutFocus()
    {

        if (currentObj != null && currentObj.activeSelf)
        {
            currentTrackable = currentObj.GetComponent<BaiduARImageTrackable>();

            currentObj.transform.localPosition = new Vector3(0, 0, 1000f);
            currentObj.transform.eulerAngles = new Vector3(currentTrackable.OutRotateX, currentTrackable.OutRotateY, currentTrackable.OutRotateZ);
        }

    }

    void Update()
    {
		if (currentObj != null && currentObj.activeSelf) {
			if (!audioSource.isPlaying && currentIndex < clips.Length && clips.Length > 0) {

				audioSource.clip = clips [currentIndex];
				audioSource.Play ();
				currentIndex++;
			}

			if (anim != null && anim.GetCurrentAnimatorStateInfo (0).normalizedTime >= 1f && !audioSource.isPlaying) {
				currentIndex = 0;
				string name = anim.GetCurrentAnimatorClipInfo (0) [0].clip.name;
				anim.Play (name, -1, 0f);
				anim.Update (0);
			}
		}
    }


}
