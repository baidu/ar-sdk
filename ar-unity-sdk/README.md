# 简介
本文档主要介绍DuMix AR Unity SDK的安装和使用。在使用本文档前，您需要先了解AR（Augmented Reality）的基础知识，并已经开通了AR服务（您可以在 [DuMix AR官网](http://ar.baidu.com) 的“开放平台”页面申请AR服务）。
## 运行环境

此SDK支持发布Android和IOS应用，并且手机需要保持联网状态。

|      功能      | Android |      IOS      | Mac | Window |
|:----------:|:---------------:|:-------------:|:-------:|:-------:|
| 单目Slam    | ✓  |   ✓ | |  |
| 2D跟踪      | ✓ |  ✓  | ✓   | ✓ |
| 本地识图     |✓  | ✓   |  |  |
| 手势识别    |✓  | ✓   |  |  |

# 快速入门
##    开发包说明

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


# DuMix AR Unity SDK样例介绍
在平台上下载样例的工程文件，用Unity打开查看。样例中包括2D跟踪，Slam，本地识图和手势识别等功能的展示。具体包含内容如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/d6b94aa11f771c342027e2c6c41b980a_45.png)

运行样例前需要填写API Key和App ID（每个场景都需要填写）。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/a9ebab288d1b1bda0f0bb282cfb29180_46.png)

样例主界面如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/d905e5859a7f7c82045711f5a6e474ae_47.png)

## 2D跟踪样例
2D跟踪样例的效果图如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/d15b58533f5cbdc986484833a900964d_48.png)

## Slam样例
Slam样例的效果图如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/3f1441034799ae8fdb8239fe64d1d6b6_49.png)

在Slam的样例中，添加了手势控制的功能，通过手势对模型进行移动，旋转和缩放的操作。将控制手势的脚本ARExampleGestrue添加到物体，就实现了此功能。以此功能为例，讲解一下相关SDK的接口调用。
首先需要在脚本中引入BaiduARInternal的程序集。BaiduARObjectTracker类中的StopAR()方法是暂停对物体位置的实时传送，StartAR()是再次开始对物体的位置的实时监控。主要应用在手势控制物体移动时调用。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/b38660a939ce81acbe8b155470e06995_62.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/295dbf0fe5bf7d191b7dc6e6747a831c_50.png)

用手势控制物体移动后，需要将物体移动后新的位置传递给接口，这时注意这里传递的位置是屏幕的像素坐标，需要将物体的坐标转化成像素坐标进行传递。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/d0df84b57bc21ab1dfbfbcbd582bb532_51.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/c8c876fe9d3747da225707fb0a1d0569_52.png)

## 本地识图样例
本地识图样例的效果图如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/c98db48e3433ee9e0334509e45f27ea4_53.png)


## 手势识别样例
手势识别样例的效果图如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/714db66e7c41147a9383d7329b04fa9a_54.png)

## 连续识图样例
连续识图样例的效果图如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/ff9d961a8a365aabe4c7935c4a8d86db_55.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/0c7415fd8d5c13f2164fd64eac3ac4d1_56.png)

连续识图样例是结合了2D跟踪和本地识图两个基本功能开发的样例。具体的操作是连续识别图片，出现图片对应的模型，模型可以定位在图片上。具体实现过程如下。将ARImageRecognition prefab和ARImageTracker prefab添加到场景中，在ARImageRecognition节点下创建空物体，将BaiduARImageRecognitionResult组件添加到空物体上，填写好图片资源的相对路径（具体过程可以参考本地识图的操作流程）。在ARImageTracker的节点下添加想要识别的模型，并在模型上添加BaiduARImageTrackable组件，填写好图片资源的相对路径。这里需要注意，模型和空物体要一一对应上，想要识别几个模型，就对应几个空物体。初始状态下，将ARImageTracker设置成false。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/f96bda8c43637d431a0ae4ab9078db6e_57.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/6a1522545eb3e7a84306818a66bc05d3_58.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/64e6a05571d8e92e5d41bc77c4c2930e_59.png)

场景设置好后，创建脚本。跟本地识图操作一致，识别成功后响应OnRespond监听事件，所以需要给OnRespond监听事件添加方法。在自定义的方法中，调用ARImageTracker组件中的SetActiveTrack (string path)方法，用来控制对应模型的跟踪。ARImageTracker组件中的OnTrackFail监听事件在跟踪失败时调用， 给OnTrackFail监听事件添加方法，可以控制跟踪失败后模型的状态。如图所示：

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/8e0d37532bc92e9076ecbbec2cf77814_60.png)

![](http://ar-fm.cdn.bcebos.com/upload/content-document/20180518/a35c47bc4aedefe44c0cef63645e5002_61.png)


# 开发者反馈
我们试用版一上线就得到了很多开发者的反馈，以下是问题和答复的内容。

|    问题   |     答复内容    |
|:----------:|:---------------:|
| 我想知道这个做平面识别有设备限制没？ 百度AR那些机型支持那些机型不支持 | 我们的SDK支持Android和IOS的手机，对机型目前还没有什么限制。  |
| Unity环境下 测试Slam功能 获取内容时 资源包在哪里获取呢  | Slam不需要上传资源，只需要给将你需要定位的模型挂上相应的组件就可以了。具体的可以参考文档 。|
| 那本地识图除了有这个回调其他和2d跟踪有区别吗|2D跟踪是可以将模型定位到图片上的，但本地识图不行，本地识图给开发者提供了空间，开发者可以自己定义加载的是模型还是UI等等。 |



# 版本更新说明
DuMix AR Unity SDK 1.1版（试用版） - 2018年5月 提供单目Slam、2D图像跟踪、本地识图、手势识别等功能。

正式版将于7月份上线。


