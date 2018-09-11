using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideGameOb : MonoBehaviour {

    public float LeftTime = 5;
	// Use this for initialization
	void OnEnable () {
        StopCoroutine("HideGameObject");
        StartCoroutine("HideGameObject");
	}
    IEnumerator HideGameObject()
    {
        float CurrentTime = Time.time;
        while(CurrentTime + LeftTime > Time.time)
        {
            yield return new WaitForSeconds(0.5f);
        }
        Destroy(gameObject);
       // gameObject.SetActive(false);
    }
	
	
}
