# 简介

本文档主要介绍基于DuMix AR Android SDK专业版进行开发。在使用本文档前，请确认并已经开通了AR服务（您可以在 [DuMix AR官网](https://dumix.baidu.com) 的“开放平台”页面申请开通AR服务）。

# 快速入门

支持的系统和硬件版本

- 系统：支持 Android 4.4（API Level 19）到Android8.0（API Level 26）系统。需要开发者通过minSdkVersion来保证支持系统的检测。
- CPU架构：armeabi-v7a，arm64-v8a
- 硬件要求：要求设备上有相机模块，CPU 4核及以上，内存2G及以上。
- 网络：支持WIFI及移动网络，移动网络支持使用NET网关及WAP网关（CMWAP、CTWAP、UNIWAP、3GWAP）。

## SDK集成步骤

### 第1步：导入jar包和so库
将libraries文件夹中的 dumixar.jar 拷贝到您的工程的 libs 文件夹中，并检查编译依赖。
将libraries文件夹中的arm64-v8a和armeabi-v7a文件夹拷贝到Android Studio工程`src/main/jniLibs`目录中。

### 第2步：配置Mannifest文件，添加必要的权限

```java
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<uses-feature android:name="android.hardware.camera"/>
<uses-feature android:name="android.hardware.camera.autofocus"/>
```

### 第3步：在代码中配置aip权限

```java
// 设置App Id
DuMixARConfig.setAppId("xxxx");
// 设置API Key
DuMixARConfig.setAPIKey("xxxxxxxx");
// 设置Secret Key
DuMixARConfig.setSecretKey("xxxxx");
```
### 第4步：在代码中启动AR

```java
// init arControler
arControler = new ARContraler(context,false);
// setup ar
arControler.setup(DuMixSource source, DuMixTarget target, DuMixCallback callback)
```
[DuMixSource](https://github.com/baidu/ar-sdk/wiki/android-sdk-%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E#setup%E5%8F%82%E6%95%B0dumixsource%E7%B1%BB%E8%AF%B4%E6%98%8E%E5%A6%82%E4%B8%8B) :  AR输入参数类
<br>
[DuMixTarget](https://github.com/baidu/ar-sdk/wiki/android-sdk-%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E#setup%E5%8F%82%E6%95%B0dumixtarget%E7%B1%BB%E8%AF%B4%E6%98%8E%E5%A6%82%E4%B8%8B) :  返回参数类
<br>
[DuMixCallback](https://github.com/baidu/ar-sdk/wiki/android-sdk-%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E#%E6%93%8D%E4%BD%9C%E7%BB%93%E6%9E%9C%E5%8F%8A%E5%86%85%E9%83%A8%E7%8A%B6%E6%80%81%E5%9B%9E%E8%B0%83%E6%8E%A5%E5%8F%A3%E5%A6%82%E4%B8%8B) :  AR操作过程中状态回调

#### AR类型说明

| 类型      |    Type | 说明  |
| :-------- | --------:| :--: |
| 2D跟踪类型  | 0 | 对平面图像进行即时识别和跟踪，可基于商品外包装、宣传海报、印刷品、服饰图案等局部图片触发AR内容|
| SLAM类型    | 5 | 即时定位与跟踪的AR效果，将AR内容自然地呈现在现实空间中，应用于3D人物角色、商品模型展示等场景。 |
| 本地识图    | 6 |  在手机端进行图像识别检索，用于实现基于2D图片的AR内容识别触发。 |
| 云端识图    | 7 | 云端图像识别检索，用于实现基于2D图片的AR内容识别触发。  |
| IMU类型     | 8|基于手机IMU，实时获取手机在空间中的相对位置和姿态，将AR内容定位呈现在手机当前所处的三维空间中|


其他API及参数说明参考 [API文档](https://github.com/baidu/ar-sdk/wiki/android-sdk-%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E)


