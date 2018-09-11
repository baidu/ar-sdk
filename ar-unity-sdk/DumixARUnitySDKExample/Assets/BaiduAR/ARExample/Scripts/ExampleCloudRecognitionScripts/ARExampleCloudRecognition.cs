using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using BaiduARInternal;

public class ARExampleCloudRecognition : MonoBehaviour{

	public GameObject infoUI;
	public GameObject content;
	public ScrollRect scrollRect;

	private int index;

	private BaiduARCloudRecognition cloudRecognition;

	private string imageName;
	private string page;

	public Button takePictureBtn;
	public GameObject objectTracker;

	public GameObject picture;
	public GameObject loading;

	private List<DishDataItem> dishItem;
	private List<SceneDataItem> sceneItem;
	private List<CommonDataItem> commonItem;

	private bool isShow;

	private string notShowName;
	public Text text;

	private Text message;
	private ARExampleScrollView exampleScrollView;
	private BaiduARObjectTracker tracker;

	private string info;

	private Texture2D texture;
	private enum CloudItem
	{
		None,
		DishData,
		SceneData,
		CommonData
	}

	public struct ErrorInfo
	{
		public int error_code;
		public string error_msg;
	}

	private ErrorInfo errorInfo;
	private CloudItem cloudItem = CloudItem.None;
	// Use this for initialization
	void Start () {

		cloudRecognition = gameObject.GetComponent<BaiduARCloudRecognition> ();

		exampleScrollView = scrollRect.GetComponent<ARExampleScrollView> ();
		tracker = objectTracker.GetComponent<BaiduARObjectTracker> ();

		index = exampleScrollView.centerIndex;

		page = null;
		message = GameObject.Find ("message").GetComponent<Text> ();
		for (int i = 0; i < content.transform.childCount; i++) {
			
			string name = content.transform.GetChild (i).GetComponent<ARExampleButtonInfo> ().FunctionName;
			int count = i;
			content.transform.GetChild(i).GetComponent<Button>().onClick.AddListener(
			delegate ()
			{
					this.ButtonOnClick(name,count);
			});
		}
			
		takePictureBtn.onClick.AddListener (TakePicture);
		content.transform.GetChild (index).GetComponent<Button> ().onClick.Invoke();

		dishItem = new List<DishDataItem> ();
		sceneItem = new List<SceneDataItem> ();
		commonItem = new List<CommonDataItem> ();

		CloudListener ();
	}
		
	public void CloudListener(){
		cloudRecognition.ResultDishRecognition((List<DishDataItem> item) =>{

			dishItem = item;
			if (dishItem.Count>0) {
				loading.SetActive(false);
				cloudItem = CloudItem.DishData;
				InfoData(notShowName);
			}
		});
		cloudRecognition.ResultSceneRecognition ((List<SceneDataItem> item) => {

			sceneItem = item;
			if (sceneItem.Count>0) {
				loading.SetActive(false);
				cloudItem = CloudItem.SceneData;
				InfoData(notShowName);	
			}
		});
		cloudRecognition.ResultAnimalRecognition((List<CommonDataItem> item) =>{

			commonItem = item;
			if (commonItem.Count>0) {
				loading.SetActive(false);
				cloudItem = CloudItem.CommonData;
				InfoData(notShowName);
			}

		});
		cloudRecognition.ResultCarRecognition((List<CommonDataItem> item) =>{

			commonItem = item;
			if (commonItem.Count>0) {
				loading.SetActive(false);
				cloudItem = CloudItem.CommonData;
				InfoData(notShowName);
			}

		});
		cloudRecognition.ResultPlantRecognition((List<CommonDataItem> item) =>{

			commonItem = item;
			if (commonItem.Count>0) {
				loading.SetActive(false);
				cloudItem = CloudItem.CommonData;
				InfoData(notShowName);
			}

		});
	}
		
	public void ButtonOnClick(string name,int count){

		if (objectTracker.activeSelf && imageName != name) {
			
			tracker.StopAR ();
			for (int i = 0; i < objectTracker.transform.childCount; i++) {
				objectTracker.transform.GetChild (i).gameObject.SetActive (false);
			}
			text.text = "";
		}
		if (!message.gameObject.activeSelf) {
			message.gameObject.SetActive (true);
		}
		message.text = "请正对" + name + "后，点击拍照识别按钮";

		imageName = name;
		index = count;	

		scrollRect.horizontalNormalizedPosition = exampleScrollView.offsets[count];

	}

	public void TakePicture(){
		
		message.text = "";
		message.gameObject.SetActive (false);
		if (imageName == null)
			return;
		
		switch (imageName) {

		case "Food":
			{
				cloudRecognition.TakePictureDish ();
				notShowName = "非菜";
				break;
			}
		case "Car":
			{
				cloudRecognition.TakePictureCar ();
				notShowName = "非车类";
				break;
			}
		case "Scene":
			{
				cloudRecognition.TakePictureScene ();
				notShowName = "非场景";
				break;
			}
		case "Animal":
			{
				cloudRecognition.TakePictureAnimal ();
				notShowName = "非动物";
				break;
			}
		case "Plant":
			{
				cloudRecognition.TakePicturePlant ();
				notShowName = "非植物";
				break;
			}
		default:
			break;
		}
		StartCoroutine (ShowPicture());
		loading.SetActive (true);
	}

	IEnumerator ShowPicture(){

        string path = "file:///" + Application.persistentDataPath + "/ScreenWholeShot.png";
		WWW www = new WWW (path);
		yield return www;

		if (www.error != null && www.error != "") {
			print(www.error);
			yield return null;
		} 
		else {
			Destroy (texture);
			texture=www.texture;
			Sprite sprite = Sprite.Create (texture, new Rect (0, 0, texture.width, texture.height), new Vector2 (0.5f, 0.5f));
			picture.GetComponent<Image> ().sprite = sprite;

			if (!picture.activeSelf) {
				picture.SetActive (true);
			}

		}
	}
		
	public void InfoData(string name){
		
		isShow = true;
		info = "";
		if (cloudItem == CloudItem.DishData) {
			for (int i = 0; i < dishItem.Count; i++) {
				if (dishItem[i].error !=null && dishItem[i].error != "") {
					ErrorShow (dishItem [i].error);
					break;
				}
				info += dishItem [i].name+ " : " + dishItem [i].probability  + "\n";
				if (dishItem [i].name.Contains (name)) {
					isShow = false;
				}
			}
		} else if (cloudItem == CloudItem.CommonData) {			
			for (int i = 0; i < commonItem.Count; i++) {
				if (commonItem[i].error !=null && commonItem[i].error != "") {
					ErrorShow (commonItem [i].error);
					break;
				}
				info += commonItem [i].name + " : " + commonItem [i].score + "\n";
				if (commonItem [i].name.Contains (name)) {
					isShow = false;
				}
			}
		} else if (cloudItem == CloudItem.SceneData) {
			for (int i = 0; i < sceneItem.Count; i++) {
				if (sceneItem[i].error !=null && sceneItem[i].error != "") {
					ErrorShow (sceneItem [i].error);
					break;
				}
				info += sceneItem [i].keyword+ " : " +sceneItem [i].score + "\n";
				if (sceneItem [i].keyword.Contains (name)) {
					isShow = false;
				}
			}
		}
		text.text = info;
		if (isShow) {
			if (!objectTracker.activeSelf) {
				objectTracker.SetActive (true);
			}

			GameObject obj = objectTracker.transform.GetChild (index).gameObject;

			if (page == imageName && obj.activeSelf) {
				
				tracker.StopAR ();
				obj.transform.position = new Vector3 (0, -50f, 1000f);
				obj.GetComponent<BaiduARObjectTrackable> ().UpdateSlamPos ();
				tracker.StartAR ();

			} else {

				tracker.SetActiveTrack (index);
				page = imageName;
			}
		}
		cloudItem = CloudItem.None;
	}

	void ErrorShow(string errorJson)
	{
		errorInfo = CreateFromJson (errorJson);
		infoUI.SetActive (true);
		infoUI.transform.Find ("Error").GetComponent<Text> ().text = errorInfo.error_code + " : " + errorInfo.error_msg;
		isShow = false;
		loading.SetActive(false);
	}

	void Update(){
		
		if (loading.activeSelf) {
			loading.transform.Rotate (new Vector3 (0, 0, -90) * Time.deltaTime);
		}
	}

	//解析
	private ErrorInfo CreateFromJson(string json)
	{
		ErrorInfo info = JsonUtility.FromJson<ErrorInfo>(json);
		ARDebug.Log("error_code:" + info.error_code + " " + "error_msg:" + info.error_msg);
		return info;
	}
}
