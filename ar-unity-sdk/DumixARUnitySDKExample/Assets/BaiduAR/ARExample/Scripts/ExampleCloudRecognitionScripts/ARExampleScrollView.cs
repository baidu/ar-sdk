using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class ARExampleScrollView : MonoBehaviour,IEndDragHandler {

	public GameObject content;
	public ScrollRect scrollRect;

	private int index;

	[HideInInspector]
	public int centerIndex;
	[HideInInspector]
	public float[] offsets = new float[]{ 0, 0.25f, 0.5f, 0.75f, 1f };
	// Use this for initialization
	void Awake () {
		centerIndex = offsets.Length / 2;
		scrollRect.horizontalNormalizedPosition = offsets [centerIndex];
	}
	

	public void OnEndDrag(PointerEventData eventData)  
	{  
		index = 0;
		float count = scrollRect.horizontalNormalizedPosition;
		float offset = Mathf.Abs (offsets [index] - count);

		for (int i = 0; i < offsets.Length; i++) {

			float posx = Mathf.Abs (offsets [i] - count);
			if (posx < offset) {

				offset = posx;
				index = i;
			}

		}
		scrollRect.horizontalNormalizedPosition = offsets [index];
		content.transform.GetChild (index).GetComponent<Button> ().onClick.Invoke();
	}  
}
