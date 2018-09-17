# 简介
本文档主要介绍DuMix AR Unity SDK 的集成和使用。在使用本文档前，您需要先了解AR（Augmented Reality）的基础知识，并已经开通了百度AR应用授权，您可以在 [AR技术开放平台](https://ar.baidu.com/developer) 的[应用控制台](https://ar.baidu.com/console#) 申请应用授权。

## 运行环境

此SDK支持发布Android和IOS应用，并且手机需要保持联网状态。

|      功能      | Android |      IOS      | Mac | Window |
|:----------:|:---------------:|:-------------:|:-------:|:-------:|
| 单目Slam    | ✓  |   ✓ | |  |
| 2D跟踪      | ✓ |  ✓  | ✓   | ✓ |
| 本地识图     |✓  | ✓   |  |  || 手势识别    |✓  | ✓   |  |  |
| 云端识图    |✓  | ✓   | ✓ | ✓ |
| 肢体识别    |✓  | ✓   |   | |
# 快速入门
## 开发包说明
DuMix AR Unity SDK.zip

```
|- DuMix AR Unity SDK.Unitypackage               // SDK
|- DuMixARUnitySDKExample.zip                    // 样例工程
|- DuMix AR Unity SDK开发文档.md                  // 说明文档
```

DuMix AR Unity SDK开发环境如下：

*    Unity开发推荐版本：Unity2017以上。
*    XCode推荐版本：XCode 9.0以上。
*    Android Studio推荐版本：Android Studio 3.0.0以上。
*    架构：armeabi-v7a 和arm64-v8a。

## SDK集成步骤
### 第1步：创建AR应用

1.前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情，点击“立即使用”或“应用控制台”申请应用授权。

2.点击**创建应用**，创建AR应用。

3.建应用后，会得到相应的AppID，APIKey，SecretKey，包名和License文件。在开发完成后生成应用时，需要将包名修改成创建时填写的包名。并下载对应的**License文件**，放到StreamingAssets目录下。Android的License文件直接放到StreamingAssets文件的根目录下，iOS的License文件需要在StreamingAssets文件下创建文件夹，文件夹的名称为“iOS”，将License文件放进去。

### 第2步：导入SDK

首先，需要在平台上下载DuMix AR Unity SDK压缩包，然后新建Unity工程，找到DuMix AR Unity SDK Unitypackage (.unitypackage) ，打开并导入到Unity中。

### 第3步：场景设置

为了让DuMix AR Unity SDK正常使用，需要将prefab添加到场景中。将场景中的相机删除掉，将ARCamera prefab拖入场景中。

### 第4步：用户key值设置

申请AR应用后，会从平台上得到API Key和App ID。在使用之前，用户需要填写API Key和App ID，填写的地方在相机上。

**注**：详细的操作步骤可以参考[官方Unity技术文档](https://ai.baidu.com/docs#/DuMixAR-Unity-SDK/top)。

## 功能开发介绍
根据上述步骤进行操作后，就完成了SDK的基本配置。下面对SDK中包含的功能进行介绍。

**注**：详细的接口调用和操作步骤可以参考[官方Unity技术文档](https://ai.baidu.com/docs#/DuMixAR-Unity-SDK/top)。

### 生成下载资源包

开发2D跟踪和本地识图功能时，需要先生成跟踪模型。首先前往[DuMix AR官网](https://dumix.baidu.com/newtarget)（<https://dumix.baidu.com/newtarget>），上传图片，生成并下载资源包。

**注**：下载的资源包的名字可以修改，但资源包内部的三个文件夹的名字不可以修改。


### 2D跟踪

1.在Assets下创建StreamingAssets文件夹（如果已经存在，则不用创建），将平台上生成的资源包导入到场景StreamingAssets文件夹中。

2.资源包导入后，在目录中找到ARImageTracker prefab，将ARImageTracker prefab添加到场景中。在ARImageTracker的节点下添加想要识别的模型，并在模型上添加BaiduARImageTrackable组件，在File Path的位置填上资源包的相对路径。如果想要从外部加载资源包，需要填写完整的路径，例如：“/Users/zhang/Desktop/picture/city/model/8e364efdba81cbec8ffed55b6f591d96_13042018171528.feam”，若要在代码中进行赋值，需要在Awake()中进行赋值。IsLossVisible用来控制跟踪失败后物体是否显示。

注：目前只能跟踪一个模型，并且模型的大小需要根据显示效果进行调整。只有2D跟踪功能支持Unity直接预览。

### Slam功能

Slam功能使用过程如下。将ARObjectTracker prefab添加到场景中，将模型添加到ARObjectTracker节点下，在模型上添加BaiduARObjectTrackable组件。通过调整模型的Tranform中的Rotation的值，对模型初始角度进行控制；调整Transform中Position的X，Y的值，对模型在屏幕中的初始位置进行控制；调整Transform中Position的Z值，对相机的距离进行控制。


**注**：目前只支持定位一个模型。如果想要进行进一步的功能扩展，相关接口的调用请查看样例介绍。

### 本地识图

本地识图跟2D跟踪相似，将平台上生成的资源包导入到场景StreamingAssets文件夹中，并将ARImageRecognition prefab添加到场景中。在ARImageRecognition节点下添加需要识别的图片。添加过程如下。在ARImageRecognition节点下创建空物体，自定义空物体的名字，将组件BaiduARImageRecognitionResult添加到空物体上，填写好图片资源的路径。

### 手势识别

1.手势识别功能的使用过程如下。将ARGestureRecog prefab和识别成功后想要显示的物体添加到场景中。

2.在使用此功能时，需要调用BaiduARGestureRecog组件中的OnResultCallBack监听回调事件，得到一个bool类型的值。如果得到的值是true，证明识别成功；如果得到的值是false，证明没有识别到手势。用户可以自己设置识别的精准度，通过设置BaiduARGestureRecog组件中的SetThreshold的值来改变精准度，取值范围是0～1，推荐设置成0.8。

3.除了手势识别，还有手势识别跟踪功能，但目前此功能还处于优化阶段。在使用此功能时，需要调用BaiduARGestureRecog组件中的OnResultTrackCallBack监听回调事件，得到一个List<RecogGesture> lstRecg，用来获得手的位置信息。位置信息包括左上角 （LeftTopPos），右上角（RightTopPos），左下角（LeftBottomPos），右下角（RightBottomPos）和中心点（GetCenterPos）的位置。

**注**：目前只支持手掌手势，后续会进行扩展。

### 云端识图

1.云端识图是将AI平台上[图像识别](https://ai.baidu.com/docs#/ImageClassify-API/top)中的部分功能进行了封装，提供给开发者进行使用。主要包含的功能有场景识别，菜品识别，车型识别，动物识别和植物识别。先要在AI平台上创建应用，获得API Key和Secret Key。

2.将ARCloudRecognition prefab添加到场景中。将在平台获得的API Key和Secret Key填入BaiduARCloudRecognition组件中。

3.相关接口的调用可以参考[官方Unity技术文档](https://ai.baidu.com/docs#/DuMixAR-Unity-SDK/top)。

### 肢体识别

1.肢体识别功能的使用过程如下。将ARHumanPose prefab添加到场景中。

2.在使用此功能时，需要调用BaiduARHumanPose组件中的InvokePosMessage监听回调事件，得到一个List< OutPutData > lstVet，用来获取肢体各个部位的信息。OutPutData这个类中包含的信息包括：VectorWorldPos（世界坐标），VectorScreenPos（屏幕坐标）和score（可信度），score代表可信度，是这个点位置的准确程度。得到的List中一共包含18个部位信息，从0～17索引所代表的部位如下：

```
[0] : Nose               [1] : Neck
[2] : RShoulder          [3] : RElbow
[4] : RWrist             [5] : LShoulder
[6] : LElbow             [7] : LWrist
[8] : RHip               [9] : RKnee
[10]: RAnkle             [11]: LHip
[12]: LKnee              [13]: LAnkle
[14]: REye               [15]: LEye
[16]: REar               [17]: LEar

```



## Android配置

若要发布Android应用，首先需要下载安装JDK和SDK。JDK需要配置环境变量，具体操作可以搜索一下（参考链接：<https://jingyan.baidu.com/article/908080221f3cfefd91c80fbf.html>）。安装配置完毕后，将路径填写到Unity中。

## IOS配置

XCode 9.x：将“pose”和“opencv2.framework”文件添加到XCode工程中（pose文件肢体识别使用，opencv2.framework文件可以自行下载，也可以使用压缩包内提供的opencv2.framework文件），把“libBaiduARUnity_iOS.a”文件和“-force_load；$(SRCROOT)/libpaddle_capi_layers.a”添加到Other Linker Flags中。修改Project和Targets的配置。设置Build Active Architecture Only为“Yes”，设置 Enable Bitcode 为“NO”。

# 接口说明

## BaiduARWebCamera

```
/*
切换摄像头（目前只支持肢体识别功能，其他功能暂不支持前置摄像头）
*/
void SwitchCamera();

```
## BaiduARObjectTracker

```
/*
启动AR 开始对物体位置的实时监控
*/
void StartAR();

/*
停止AR 停止对物体位置的实时传送
*/
void StopAR();

/*
暂停AR
*/
void PauseAR();

/*
继续AR
*/
void ResumeAR();

/*
切换模型
参数：index 索引，模型的序列号
*/
bool SetActiveTrack(int index);

/*
定位成功（具体使用方式参考功能开发介绍中的Slam章节）
*/
UnityEvent OnSlamSuccess;

/*
定位失败（具体使用方式参考功能开发介绍中的Slam章节）
*/
UnityEvent OnSlamFail;

/*
身份报错信息（具体使用方式参考功能开发介绍中的Slam章节）
*/
UnityEventEx OnErrorEvent;
```
## BaiduARObjectTrackable

```
/*
更新物体的位置，角度信息
*/
void UpdateSlamPos()；
```

## BaiduARImageTracker

```
/*
启动AR
*/
void StartAR();

/*
停止AR
*/
void StopAR();

/*
暂停AR
*/
void PauseAR();

/*
继续AR
*/
void ResumeAR();

/*
切换模型
参数 ：path 路径，模型上BaiduARImageTrackable组件中的filePath
*/
bool SetActiveTrack (string path);

/*
跟踪成功（具体使用方式参考功能开发介绍中的2D跟踪章节）
*/
UnityEvent OnTrackSuccess;
  
/*
跟踪失败（具体使用方式参考功能开发介绍中的2D跟踪章节）
*/  
UnityEvent OnTrackFail; 

/*
身份报错信息（具体使用方式参考功能开发介绍中的2D跟踪章节）
*/
UnityEventEx OnErrorEvent;   
```

## BaiduARImageTrackable

```
/*
自定义资源包的加载路径
参数 ：path 绝对路径，比如”/Users/zhang/Desktop/picture/city/model/8e364efdba81cbec8ffed55b6f591d96_13042018171528.feam“
*/
SetAbsolutePath(string path)
```

## BaiduARImageRecognition

```
/*
启动AR
*/
void StartAR();

/*
停止AR
*/
void StopAR();

/*
暂停AR
*/
void PauseAR();

/*
继续AR
*/
void ResumeAR();

/*
身份报错信息（具体使用方式参考功能开发介绍中的本地识图章节）
*/
UnityEventEx OnErrorEvent;
```

## BaiduARImageRecognitionResult

```
/*
自定义资源包的加载路径
参数 ：path 绝对路径，比如”/Users/zhang/Desktop/picture/city/feature/20180208173518.fea“
*/
SetAbsolutePath(string path)

/*
识别成功（具体使用方式参考功能开发介绍中的本地识图章节）
*/
UnityEvent OnRespond;
```
## BaiduARGestureRecog
```
/*
启动AR
*/
void StartAR();

/*
停止AR
*/
void StopAR();

/*
暂停AR
*/
void PauseAR();

/*
继续AR
*/
void ResumeAR();

/*
手势识别（具体使用方式参考功能开发介绍中的手势识别章节）
*/
void OnResultCallBack(Action<bool> callback);

/*
手势跟踪（具体使用方式参考功能开发介绍中的手势识别章节）
*/
void OnResultTrackCallBack(Action<List<RecogGesture>> callback);

/*
身份报错信息（具体使用方式参考功能开发介绍中的手势识别章节）
*/
UnityEventEx OnErrorEvent;
```

## BaiduARCloudRecognition

```
/*
拍摄菜品
*/
void TakePictureDish()；

/*
拍摄场景
*/
void TakePictureScene()；

/*
拍摄车型
*/
void TakePictureCar()；

/*
拍摄动物
*/
void TakePictureAnimal()；

/*
拍摄植物
*/
void TakePicturePlant()；

/*
普通场景识别监听（具体使用方式参考功能开发介绍中的云端识图章节）
*/
void ResultSceneRecognition(Action<List<SceneDataItem>> call);

/*
菜品识别监听（具体使用方式参考功能开发介绍中的云端识图章节）
*/
void ResultDishRecognition(Action<List<DishDataItem>> call);

/*
车识别监听（具体使用方式参考功能开发介绍中的云端识图章节）
*/
void ResultCarRecognition(Action<List<CommonDataItem>> call);

/*
动物识别监听（具体使用方式参考功能开发介绍中的云端识图章节）
*/
void ResultAnimalRecognition(Action<List<CommonDataItem>> call);

/*
植物识别监听（具体使用方式参考功能开发介绍中的云端识图章节）
*/
ResultPlantRecognition(Action<List<CommonDataItem>> call);

/*
身份报错信息（具体使用方式参考功能开发介绍中的云端识图章节）
*/
UnityEventEx OnErrorEvent;
```
## BaiduARHumanPose

```
/*
启动AR
*/
void StartAR();

/*
停止AR
*/
void StopAR();

/*
暂停AR
*/
void PauseAR();

/*
继续AR
*/
void ResumeAR();

/*
清理坐标点（具体使用方式参考功能开发介绍中的肢体识别章节）
*/
void InvokeClearMessage(Action clear);

/*
获得肢体点（具体使用方式参考功能开发介绍中的肢体识别章节）
*/
void InvokePosMessage(Action<List<OutPutData>> posCallback);

/*
返回报错信息（具体使用方式参考功能开发介绍中的肢体识别章节）
*/
void InvokeErrorMessage(Action<string,string> errorCallback);
```


# DuMix AR Unity SDK样例介绍
1.在平台上下载样例的工程文件，用Unity打开查看。样例中包括2D跟踪，Slam，本地识图和手势识别等功能的展示。

2.运行样例前需要填写APIKey，AppID和SecretKey（每个场景都需要填写）。

**注**：详细的内容可以参考[官方Unity技术文档](https://ai.baidu.com/docs#/DuMixAR-Unity-SDK/top)。

# 常见问题
试用阶段得到了很多开发者的反馈，以下是常见问题和答复的内容。

**问**：我想知道这个做平面识别有设备限制没？ 百度AR支持哪些机型？

**答**：SDK支持Android和IOS的手机，目前对机型没有限制，可以根据使用效果要求，对机型做取舍。 

**问**：Unity环境下 测试SLAM功能 获取内容时 资源包在哪里获取呢  

**答**：SLAM不需要上传资源，只需要给将你需要定位的模型挂上相应的组件就可以了。具体的可以参考文档 。

**问**：本地识图除了有回调，其他和图像跟踪有区别吗？

**答**：图像跟踪是可以将模型定位到图片上的，但本地识图不行，本地识图给开发者提供了空间，开发者可以自己定义加载的是模型还是UI等等。 



# 版本更新说明
DuMix AR Unity SDK 1.1版（试用版）- 2018年5月 提供单目SLAM、2D图像跟踪、本地识图、手势识别等功能。

DuMix AR Unity SDK 1.2版 - 2018年7月 提供云端识图功能。
DuMix AR Unity SDK 2.0版 - 2018年8月 提供肢体识别功能。