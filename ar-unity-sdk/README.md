# 简介

本文档主要介绍DuMix AR Unity SDK 的集成和使用。在使用本文档前，您需要先了解AR（Augmented Reality）的基础知识，并已经开通了百度AR应用授权，您可以在 [AR技术开放平台](https://ar.baidu.com/developer) 的[应用控制台](https://ar.baidu.com/console#) 申请应用授权。

## 运行环境

此SDK支持发布Android和IOS应用，并且手机需要保持联网状态。

|      功能      | Android |      IOS      | Mac | Window |
|:----------:|:---------------:|:-------------:|:-------:|:-------:|
| 单目Slam    | ✓  |   ✓ | |  |
| 2D跟踪      | ✓ |  ✓  | ✓   | ✓ |
| 本地识图     |✓  | ✓   |  |  |
| 手势识别    |✓  | ✓   |  |  |
| 云端识图    |✓  | ✓   | ✓ | ✓ |
| 肢体识别    |✓  | ✓   |   | |

# 快速入门

##     开发包说明
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

## Unity的下载与安装

进入Unity的官方网站下载Unity。官方网站的网址为：<https://unity3d.com/cn>

根据你的系统选择适合的Unity版本进行下载和安装。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/262f7af170676f00a45c29bbe730b04a_1.png)

你可以选择“Unity安装程序”进行在线安装，也可以选择“Unity编辑器”下载安装包进行离线安装。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/48353922f673be0331539933901076e3_2.png)

双击打开下载的文件（Mac），如“Unity-2017.3.0f1.pkg”，点击“继续”，到安装路径的页面可以更改安装路径，其他都默认即可。最后打开Unity，创建工程。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/e0e49d8ba5e4df908ca22f833e7c93ec_3.png)

## SDK集成步骤

### 第1步：创建AR应用

前往[DuMix AR技术开放平台](https://ar.baidu.com/developer)了解详情（如图所示），点击“立即使用”或“应用控制台”申请应用授权。

![图片](http://agroup-bos.su.bcebos.com/343036350b95e5ad974f0a38d6bbef191c959482)

点击**创建应用**，创建AR应用。

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180816/cece81aa43fb8a9b965bde814f8123a1_1.png)


创建应用后，会得到相应的AppID，APIKey，SecretKey，包名和License文件。在开发完成后生成应用时，需要将包名修改成创建时填写的包名。并下载对应的**License文件**，放到StreamingAssets目录下。Android的License文件直接放到StreamingAssets文件的根目录下，iOS的License文件需要在StreamingAssets文件下创建文件夹，文件夹的名称为“iOS”，将License文件放进去。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180821/df4f58f6b4f395ad5ac83807bda3c4d6_17.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/afe34222adcd0ba1f511ec5ff770155d_3.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/7c1d7f940f9bb286e2fc3050f6807589_4.png)

### 第2步：导入SDK

首先，需要在平台上下载DuMix AR Unity SDK压缩包，然后新建Unity工程，找到DuMix AR Unity SDK Unitypackage (.unitypackage) ，打开并导入到Unity中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180821/9bcde8c9abc805a595f2a594d0f8a082_13.png)

导入后的效果如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/57f93022de5660a239b1300e84442252_8.png)

### 第3步：场景设置

为了让DuMix AR Unity SDK正常使用，需要将prefab添加到场景中。将场景中的相机删除掉，将ARCamera prefab拖入场景中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/c248bbfde0a3f2509b5a63554821aa41_5.png)

### 第4步：用户key值设置

申请AR应用后，会从平台上得到AppID，APIKey和SecretKey。在使用之前，用户需要填写AppID，APIKey和SecretKey，填写的地方在相机上。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/207a0c46f6c385c3f8222180a049cbb7_10.png)

## 功能开发介绍
根据上述步骤进行操作后，就完成了SDK的基本配置。下面对SDK中包含的功能进行介绍。


### 生成下载资源包

开发2D跟踪和本地识图功能时，需要先生成跟踪模型。首先前往[DuMix AR官网](http://dumix.baidu.com/console)（<http://dumix.baidu.com/console>），上传图片，生成并下载资源包。过程如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180829/2f11ac3b49110b53e2f46af3c32d6e11_25.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180829/cd2a997d2ed83a3498ddede8bb5b4382_26.png)



下载的资源包和资源包包含的内容，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180523/cf06f9c5f899daccf7c623bff2f46742_63.png)

注：下载的资源包的名字可以修改，但资源包内部的三个文件夹的名字不可以修改。


### 2D跟踪

在Assets下创建StreamingAssets文件夹（如果已经存在，则不用创建），将平台上生成的资源包导入到场景StreamingAssets文件夹中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/ee5ea9914ef1a62c2e0a35bd7aa059dc_17.png)

资源包导入后，在目录中找到ARImageTracker prefab，将ARImageTracker prefab添加到场景中。在ARImageTracker的节点下添加想要识别的模型，并在模型上添加BaiduARImageTrackable组件，在File Path的位置填上资源包的相对路径。如果想要从外部加载资源包，需要填写完整的路径，例如：“/Users/zhang/Desktop/picture/city/model/8e364efdba81cbec8ffed55b6f591d96_13042018171528.feam”，若要在代码中进行赋值，需要在Awake()中进行赋值。IsLossVisible用来控制跟踪失败后物体是否显示。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/6ebf0ca14c78994afaf257c554efe6ce_18.png)

此版本2D跟踪功能支持Unity直接运行预览效果。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/33ada165270b54a626e9dc0ca7874295_21.png)

BaiduARImageTracker组件中可调用的监听事件，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/5da8a4a1a45cf97d520b7693c9fbbcfc_34.png)

注：目前只能跟踪一个模型，并且模型的大小需要根据显示效果进行调整。只有2D跟踪功能支持Unity直接预览。

### Slam功能

Slam功能使用过程如下。将ARObjectTracker prefab添加到场景中，将模型添加到ARObjectTracker节点下，在模型上添加BaiduARObjectTrackable组件。通过调整模型的Tranform中的Rotation的值，对模型初始角度进行控制；调整Transform中Position的X，Y的值，对模型在屏幕中的初始位置进行控制；调整Transform中Position的Z值，对相机的距离进行控制。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/9ca751a396a7f3509ebe580c18913a2a_17.png)

BaiduARObjectTracker组件中可调用的监听事件，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/e4bf63f260b754b8ff402f9f38bc69e9_18.png)


注：目前只支持定位一个模型。如果想要进行进一步的功能扩展，相关接口的调用请查看样例介绍。

### 本地识图

本地识图跟2D跟踪相似，将平台上生成的资源包导入到场景StreamingAssets文件夹中，并将ARImageRecognition prefab添加到场景中。在ARImageRecognition节点下添加需要识别的图片。添加过程如下。在ARImageRecognition节点下创建空物体，自定义空物体的名字，将组件BaiduARImageRecognitionResult添加到空物体上，填写好图片资源的路径。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/6fe98fef79b062e246e44667e460d9ba_27.png)

用户开发此功能时，需要调用BaiduARImageRecognitionResult组件中的OnRespond监听事件。OnRespond监听事件在识别成功后响应，给监听事件添加自定义的方法。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/8a5edc1bfa352875a397d23591a3d90f_26.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/3b936c5a584c2173dd87e0ce00f3457e_27.png)

BaiduARImageRecognition组件中可调用的监听事件，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/4c93ef20aa42cd088dcd4defd26a7dfb_25.png)


### 手势识别

手势识别功能的使用过程如下。将ARGestureRecog prefab和识别成功后想要显示的物体添加到场景中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/351f9dc0fffd5db2b64e785ff903ba0c_33.png)


在使用此功能时，需要调用BaiduARGestureRecog组件中的OnResultCallBack监听回调事件，得到一个bool类型的值。如果得到的值是true，证明识别成功；如果得到的值是false，证明没有识别到手势。用户可以自己设置识别的精准度，通过设置BaiduARGestureRecog组件中的SetThreshold的值来改变精准度，取值范围是0～1，推荐设置成0.8。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/f066a641ca184448f3e7438b74fccc7a_20.png)

除了手势识别，还有手势识别跟踪功能，但目前此功能还处于优化阶段。在使用此功能时，需要调用BaiduARGestureRecog组件中的OnResultTrackCallBack监听回调事件，得到一个List< RecogGesture > lstRecg，用来获得手的位置信息。位置信息包括左上角 （LeftTopPos），右上角（RightTopPos），左下角（LeftBottomPos），右下角（RightBottomPos）和中心点（GetCenterPos）的位置。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/2ba22be43fe2380ee0f4d053f4a4a58b_21.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/04229bf5f9492e0b8ee87313d734b175_22.png)

BaiduARGestureRecog组件中可调用的监听事件，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/fd22313953dc4b195e90f31e9640cfcc_24.png)

注：目前只支持手掌手势，后续会进行扩展。

### 云端识图

云端识图是将AI平台上[图像识别](https://ai.baidu.com/docs#/ImageClassify-API/top)中的部分功能进行了封装，提供给开发者进行使用。主要包含的功能有场景识别，菜品识别，车型识别，动物识别和植物识别。先要在AI平台上创建应用，获得API Key和Secret Key。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180628/b0c842fcdf650860b520c1f42a2f91dc_9.png)

将ARCloudRecognition prefab添加到场景中。将在平台获得的API Key和Secret Key填入BaiduARCloudRecognition组件中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180628/49a52b98f6dfd5ddbbd603b26a6f9ddf_10.png)

在使用此功能时，调用BaiduARCloudRecognition组件中的相应的监听事件。具体的实现方式，如图所示：


![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/5ed6b0d229ce2506fe7790070006fa05_7.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/eac3056a988275a716525744d3aa3f3f_16.png)

建议开发者设计交互（如引导图），引导用户正对拍摄物，如使汽车轮胎和手机底边平行，使动物四只脚离手机底边等距，正立在拍摄视野中。

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180828/2a499bba93b7f7754951cbc10cbb1600_WechatIMG3.jpeg)

### 肢体识别
肢体识别功能的使用过程如下。将ARHumanPose prefab添加到场景中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/9416b09831bc60662700aa1df7799dfe_8.png)

在使用此功能时，需要调用BaiduARHumanPose组件中的InvokePosMessage监听回调事件，得到一个List< OutPutData > lstVet，用来获取肢体各个部位的信息。OutPutData这个类中包含的信息包括：VectorWorldPos（世界坐标），VectorScreenPos（屏幕坐标）和score（可信度），score代表可信度，是这个点位置的准确程度。得到的List中一共包含18个部位信息，从0～17索引所代表的部位如下：

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
BaiduARHumanPose组件中可调用的监听事件，如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180629/1dfe1a122e3cebd7c5aa329e0675dcd2_23.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180821/c536e125e0a223bd921a3eb2707b4368_11.png)

注：肢体识别功能Android手机支持中高端机型。
## Android配置
若要发布Android应用，首先需要下载安装JDK和SDK。JDK需要配置环境变量，具体操作可以搜索一下（参考链接：<https://jingyan.baidu.com/article/908080221f3cfefd91c80fbf.html>）。安装配置完毕后，将路径填写到Unity中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/5aba20c379d4f38a3953ded86a5279a9_38.png)

如果用Unity直接进行发布生成Android应用，需要进行如下设置。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/c26da22be8c036393d1bb5276c8b6289_39.png)

如果用Android Studio进行发布生成Android应用，需要进行如下设置。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/1f7b1de246649260c89892b953c8b735_40.png)

## IOS配置
在发布应用时需要注意，在Unity导出XCode工程时，需要切换平台。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/ba9e002c27f2b0c1251d620af48ced86_41.png)

XCode 9.x：将“pose”和“opencv2.framework”文件添加到XCode工程中（pose文件肢体识别使用，opencv2.framework文件可以自行下载，也可以使用压缩包内提供的opencv2.framework文件），把“libBaiduARUnity_iOS.a”文件和“-force_load；$(SRCROOT)/libpaddle_capi_layers.a”添加到Other Linker Flags中。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180821/5c37c42320bd0732be61e46a30316e05_16.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180821/d420367c0f0a3fa2c84c34b19add1d8b_15.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180820/5a69f03d040f0a3b30678de073dcb91e_9.png)

修改Project和Targets的配置。设置Build Active Architecture Only为“Yes”，设置 Enable Bitcode 为“NO”。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/188065ec7a024ec5ba9754934cd18fc0_43.png)


![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/2374186c61c51938dd99d690a019845a_44.png)

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

